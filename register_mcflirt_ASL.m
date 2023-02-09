function register_mcflirt_ASL(session_dir,subject_name,despike,B0)

% Registers functional runs in feat directories to freesurfer anatomical,
%   following feat_mc_b0. Also copies over motion correction parameters
%   resulting from feat_mc_b0.
%
% Usage:
%   register_feat(session_dir,subject_name,despike,func)
%
% Defaults:
%   despike = 1; % despike data
%   feat_dir = 'f_brain.feat'; % feat directory
%   func = 'brf'
%
% Outputs (in each bold directory):
%   bbreg.dat - registration text file
%   <func>_motion_params.par - motion correction parameter file (6 dof)
% if despike
%   <func>_spikes.mat - cell matrix, non-empty cells contain the location
%   of spikes in "filtered_func_data.nii.gz"
%   <func>_spikes.nii.gz - binary volume, where non-zero values indicate
%   the location of spikes in "filtered_func_data.nii.gz"
%
% Note: assumes functional runs are in the session_dir, and begin with
%   "bold_" (not case sensitive, unless environment is set as such)
%
%   Written by Andrew S Bock Dec 2014
%
% 12/15/14      spitschan       Added case of BOLD runs called 'RUN_'
%
%   Modified my M Vidorreta Jan 2015

%% Add to log
% SaveLogInfo(session_dir, mfilename)

%% Set default parameters
if ~exist('session_dir','var')
    error('"session_dir" not defined')
end
if ~exist('subject_name','var')
    error('"subject_name" not defined')
end
if ~exist('despike','var')
    despike = 0; % despike data
end
if ~exist('B0','var')
    B0 = 0; 
end


%% Find ASL run directories
d = listdir(fullfile(session_dir,'ASL*'),'dirs');
if isempty(d)
    d = listdir(fullfile(session_dir,'*asl*'),'dirs');
end

nruns = length(d);
disp(['Session_dir = ' session_dir]);
disp(['Number of ASL runs = ' num2str(nruns)]);

%% functional data file
feat_dir ='mc';

% %% Copy over files from feat directory
% % progBar = ProgressBar(nruns,'copying files from feat directory');
% fprintf('Copying files from feat directory.\n');
% for r = 1:nruns
%     if despike
%         disp('Despiking filtered functional data');
%         remove_spikes(fullfile(session_dir,d{r},feat_dir,[func '.nii.gz']),...
%             fullfile(session_dir,d{r},[func '.nii.gz']),fullfile(session_dir,d{r},[func '_spikes']));
%     else
%         copyfile(fullfile(session_dir,d{r},feat_dir,'filtered_func_data.nii.gz'),...
%             fullfile(session_dir,d{r},[func '.nii.gz']));
%     end
%     % Also copy over the motion correction parameters
%     copyfile(fullfile(session_dir,d{r},feat_dir,'mc','prefiltered_func_data_mcf.par'),...
%         fullfile(session_dir,d{r},[func '_motion_params.par']));
% %     progBar(r);
% end

%% Register functional to freesurfer anatomical
% progBar = ProgressBar(nruns, 'Registering functional runs to freesurfer anatomical...');
fprintf('Registering functional runs to freesurfer anatomical.\n');
for r = 1:nruns
    if strfind(d{r},'M0')
        fprintf('Run %02d - %s: M0 scan. No MC filtering.\n',r,d{r});
        func = 'raw_f_mcf';
    else
        fprintf('Run %02d - %s: L-C scan. With MC filtering.\n',r,d{r});
        func = 'raw_f_mcf_reg';
    end
    filefor_reg = fullfile(session_dir,d{r},feat_dir,[func '.nii.gz']); % Functional file for bbregister
    bbreg_out_file = fullfile(session_dir,d{r},feat_dir,[func '_bbreg.dat']); % name registration file
    acq_type = 't2';
    bbregister(subject_name,filefor_reg,bbreg_out_file,acq_type);
    %Convert transform from FS to FSL format for future use
    FSLbbreg_out_file = fullfile(session_dir,d{r},feat_dir,[func '_bbreg.mat']); % name registration file
    commandc = ['tkregister2' ' --reg ' bbreg_out_file ' --mov ' filefor_reg ' --fstarg ' ' --fslregout ' FSLbbreg_out_file ' --noedit'];
    disp(commandc);
    system(commandc);
    %Calculate inverse transform
    FSLbbreg_out_file_inv = fullfile(session_dir,d{r},feat_dir,[func '_bbreg_inv.mat']); % name of registration file
    outmat = FSLbbreg_out_file_inv;
    inmat  = FSLbbreg_out_file;
    commandc = ['convert_xfm ' '-omat ' outmat ' -inverse ' inmat];
    disp(commandc);
    system(commandc);
%     progBar(r);
end