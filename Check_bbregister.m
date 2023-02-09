function Check_bbregister(session_dir, subject_name)

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
    
%     bbregister(subject_name,filefor_reg,bbreg_out_file,acq_type);

    mincost = load([bbreg_out_file '.mincost']);
    mincost = mincost(1);
    fprintf('The min cost value of registration for %s:\n%f\n\n',filefor_reg,mincost);
    
    [~,~] = system(['tkregister2 --mov ' filefor_reg ' --reg ' bbreg_out_file ' --surf']);
    
end

end