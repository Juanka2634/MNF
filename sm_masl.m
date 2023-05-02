% path = (fullfile('/opt','dora','Dora','IBEAS','Resultados','Asl_faltantes'));
% files_id = listdir(path,'dirs');

path = (fullfile('/opt','dora','Dora','IBEAS','Resultados','ASL_multiple_pcasl'));
files_id = listdir(path,'dirs');

for x = 152: length(files_id)
    
%     asl_path = char(fullfile(path,files_id(x),'basil_results','std_space','perfusion_calib.nii.gz'));
%     skernel = 8;
%     asl_sm_path = char(fullfile(path,files_id(x),sprintf('%s_perfusion_sm_%d.nii.gz',char(files_id(x)),skernel)));
%     system(['fslmaths ' asl_path ' -s ' num2str(1/2.3548 * skernel) ' ' asl_sm_path])
%     gunzip(asl_sm_path)
    arrival_path = char(fullfile(path,files_id(x),sprintf('%s_arrival_sm.nii.gz',char(files_id(x)))));
    arrival_mask_sm_path = char(fullfile(path,files_id(x),sprintf('%s_arrival_sm_mask.nii.gz',char(files_id(x)))));
    mask = char(fullfile(path,files_id(x),'*.anat','MNI152_T1_2mm_brain_mask_dil1.nii.gz'));
    system(['fslmaths ' arrival_path ' -mul ' mask ' ' arrival_mask_sm_path])
    gunzip(arrival_mask_sm_path)
%     path_sm_arrival = char(fullfile(path,files_id(x),sprintf('%s_arrival_sm%d.nii.gz',char(files_id(x)),skernel)));
%     system(['fslmaths ' arrival_mask_sm_path ' -s ' num2str(1/2.3548 * skernel) ' ' path_sm_arrival]);
%     gunzip(path_sm_arrival)
end

% for y = 1 : length(files_id)
%     gunzip(char(fullfile(path,files_id(y),sprintf('%s_perfusion_sm_%d.nii.gz',char(files_id(y)),skernel))))
% end

