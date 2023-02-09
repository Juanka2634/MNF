function register_mni_ASL(session_dir, subject_name, PAR)


%% FS -> MNI
%   Outputs a matrix of transformation from FS to MNI
%   /FreeSurfer/FS_Subject/mri/mni152.orig.mgz.reg

% This creates .dat file
% commandc = ['mni152reg ' '--s ' subject_name];
% This commands fails to work in the cluster, because it actually tries to
% register the MNI152 image in FSL path to the subject's space.
% We don't have permission in the cluster to write into FSL path
% I have coded manually the steps within mni152reg below:
MNIvolume  = fullfile(PAR.FreeSurferDir, 'MNI152_T1_2mm_brain.nii.gz');
if ~exist(MNIvolume,'file')
    sourcename = fullfile(getenv('FSLDIR'), 'data', 'standard', 'MNI152_T1_2mm_brain.nii.gz');
    destinname = MNIvolume;
    copyfile(sourcename, destinname);
end

FSLoutregfile_inv = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'transforms', 'reg.mni152.2mm_inv.mat'); % name of registration file
if ~exist(FSLoutregfile_inv,'file')
    
    outregfile = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'transforms', 'reg.mni152.2mm.dat');
    commandc = ['fslregister ' '--mov ' MNIvolume ' --s ' subject_name ' --reg ' outregfile ' --dof 12'];
    disp(commandc);
    system(commandc);

    origvolume    = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'orig.mgz');
    MNIorigvolume = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'mni152.orig.mgz');
    commandc = ['mri_vol2vol ' '--mov ' MNIvolume ' --targ ' origvolume ' --reg ' outregfile ' --inv ' ' --o ' MNIorigvolume];
    disp(commandc);
    system(commandc);

    %Convert transform from FS to FSL format for future use
    FSLoutregfile = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'transforms', 'reg.mni152.2mm.mat');
    commandc = ['tkregister2' ' --reg ' outregfile ' --mov ' MNIvolume ' --fstarg ' ' --fslregout ' FSLoutregfile ' --noedit'];
    disp(commandc);
    system(commandc);
    %Calculate inverse transform
    FSLoutregfile_inv = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'transforms', 'reg.mni152.2mm_inv.mat'); % name of registration file
    outmat = FSLoutregfile_inv;
    inmat  = FSLoutregfile;
    commandc = ['convert_xfm ' '-omat ' outmat ' -inverse ' inmat];
    disp(commandc);
    system(commandc);

end
%% Find ASL run directories
d = listdir(fullfile(session_dir,'ASL*'),'dirs');
if isempty(d)
    d = listdir(fullfile(session_dir,'*asl*'),'dirs');
end
nruns = length(d);
disp(['Session_dir = ' session_dir]);
disp(['Number of ASL runs = ' num2str(nruns)]);

%% Perfusion dirs - separate into ASL / M0 scans
ASLparam= PAR.ASL;

perfdir = ['perf_' ASLparam.SubtractionType];


M0_runs = [];
ASL_runs = [];
for r = 1:nruns
    if strfind(d{r},'M0')
        fprintf('Run %02d - %s: M0 scan.\n',r,d{r});
        M0_runs = [M0_runs, r];
        
    else
        fprintf('Run %02d - %s: L-C scan.\n',r,d{r});
        ASL_runs = [ASL_runs, r];
    end
    
end

%% FUNC -> FS -> MNI
%   Need to combine two matrices (FUNC->FS) and (FS->MNI) to get FUNC->MNI
%   transformation matrix.
%   Session_Dir/ASLxx/raw_f_mc_bbreg.mat: FUNC -> FS
%   /FreeSurfer/FS_Subject/mri/transformation/reg.mni152.2mm.dat: FS -> MNI

for r = ASL_runs
    %
    fprintf('\nRun %s:\n',d{r});
    % Concatenate the matrices
    mat_AtoB = fullfile(session_dir, d{r}, 'mc', 'raw_f_mcf_reg_bbreg.mat');
    mat_BtoC = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'transforms', 'reg.mni152.2mm_inv.mat');
    outmat_AtoC = fullfile(session_dir, d{r}, perfdir, 'func2mni.mat');
    commandc = ['convert_xfm -omat ' outmat_AtoC ' -concat ' mat_BtoC ' ' mat_AtoB];
    disp(commandc);
    system(commandc);

    % Apply the concatenated transformation        
    % CBF Map
    funcvol = fullfile(session_dir, d{r}, perfdir, 'CBFMean.nii.gz');

    % MNI Volume
    targetvol = MNIvolume;

    % Normalized CBF Map
    outputvol = fullfile(session_dir, d{r}, perfdir, 'wCBFMean.nii.gz');

    commandc = ['mri_vol2vol' ' --fsl ' outmat_AtoC ' --mov ' funcvol ' --targ ' targetvol ' --o ' outputvol]; % ' --fstarg'];
    disp(commandc);
    system(commandc);
    
    %Smooth mean CBF map
    targetvol = outputvol;        
    outputvol = fullfile(session_dir, d{r}, perfdir, 'swCBFMean.nii.gz');
    commandc = (['fslmaths ' targetvol ' -s ' num2str(1/2.3548 * 8) ' '  outputvol]);
    disp(commandc);
    system(commandc);

end

for r = M0_runs
    fprintf('\nRun %s:\n',d{r});
    % Concatenate the matrices
    mat_AtoB = fullfile(session_dir, d{r}, 'mc', 'raw_f_mcf_bbreg.mat');
    mat_BtoC = fullfile(PAR.FreeSurferDir, subject_name, 'mri', 'transforms', 'reg.mni152.2mm_inv.mat');
    outmat_AtoC = fullfile(session_dir, d{r}, perfdir, 'func2mni.mat');
    commandc = ['convert_xfm -omat ' outmat_AtoC ' -concat ' mat_BtoC ' ' mat_AtoB];
    disp(commandc);
    system(commandc);

    % Apply the concatenated transformation        
    % CBF Map
    funcvol = fullfile(session_dir, d{r}, perfdir, 's4meanM0.nii.gz');

    % MNI Volume
    targetvol = MNIvolume;

    % Normalized CBF Map
    outputvol = fullfile(session_dir, d{r}, perfdir, 'ws4meanM0.nii.gz');

    commandc = ['mri_vol2vol' ' --fsl ' outmat_AtoC ' --mov ' funcvol ' --targ ' targetvol ' --o ' outputvol]; % ' --fstarg'];
    disp(commandc);
    system(commandc);
    
    %Smooth mean CBF map
    targetvol = outputvol;        
    outputvol = fullfile(session_dir, d{r}, perfdir, 'sws4meanM0.nii.gz');
    commandc = (['fslmaths ' targetvol ' -s ' num2str(1/2.3548 * 8) ' '  outputvol]);
    disp(commandc);
    system(commandc);

end

end