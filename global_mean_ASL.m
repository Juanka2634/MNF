clear
clc

%Declaración de la ruta y cuantos sujectos existen dentro de la ruta
asl_names=fullfile('/opt','dora','Dora','IBEAS','Resultados','ASL_multiple_pcasl/');
ids = listdir(fullfile(asl_names,'PA*'),'dirs');

%inicializo las tablas de pacientes y medias
individuos=[];
medias=[];

%Recorremos los sujetos de los cuales se extraen la media global

for x = 1 : length(ids)

    %Ruta de cada sujeto 
%     %asl_path = fullfile(asl_names,char(ids(x)),sprintf('%s_perfusion_sm_8.nii',char(ids(x))));
%     asl_path = fullfile(asl_names,char(ids(x)),'basil_results','std_space','perfusion_calib.nii.gz');
%     mask_asl_path = fullfile(asl_names,char(ids(x)),'*.anat');
%     folder = listdir(mask_asl_path,'dirs');
%     mask_asl_path = fullfile(asl_names,char(ids(x)),char(folder),'MNI152_T1_2mm_brain_mask_dil1.nii.gz');
%     %Se añade el nombre del individuo a la tabla final
%     individuos = [individuos; ids(x)];
% 
%     x_perfusion = spm_vol(fullfile(asl_path));
%     y=spm_read_vols(x_perfusion);
% 
%     mask_name=spm_vol(mask_asl_path);
%     mask=spm_read_vols(mask_name);
%        
%     global_value = mean(y(mask(:)>0));
% 
%     %añado el valor de la media
%     medias = [medias ; global_value];
% 
%     img_mean_global = x_perfusion;
%     img_mean_global.fname=char(fullfile(asl_names,char(ids(x)),sprintf('%s_perfusion_global_mean.nii',char(ids(x)))));
%     img_out = char(fullfile(asl_names,char(ids(x)),sprintf('%s_perfusion_global_mean_out_sm.nii',char(ids(x)))));
%     spm_write_vol(img_mean_global,y./global_value);
%     kernel_2 = 8;
%     system(['fslmaths ' img_mean_global.fname ' -s ' num2str(1/2.3548*kernel_2) ' ' img_out ]);
    img_out_mask = char(fullfile(asl_names,char(ids(x)),sprintf('%s_perfusion_global_mean_sm_mask.nii.gz',char(ids(x)))));
%     system(['fslmaths ' img_out ' -mul ' mask_asl_path ' ' img_out_mask]);
    gunzip(img_out_mask)

end

% T=table(ids',medias);
% writetable(T , 'Medias_befores_IBEAS.txt');