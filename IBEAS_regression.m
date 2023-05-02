% Methylation regression
clear
clc

addpath('/opt/dora/Dora/IBEAS/Functions')

%%
path_pat = fullfile('/opt','dora','Dora','IBEAS','BIDS-IBEAS','derivatives','DTI','fa','origdata/');
path_ibeas_pac = fullfile(path_pat,'sub-PAC*');
path_ibeas_pap = fullfile(path_pat,'sub-PAP*');

ids_patientes_pac = listdir(path_ibeas_pac,'files');
ids_patientes_pap = listdir(path_ibeas_pap,'files');

% pat = '';
% for x = 1 : length(ids_patientes_pap)
%     pat = [pat ' ' strcat(char(ids_patientes_pap(x)),'/smwc1T1-',char(ids_patientes_pap(x)),'.nii')]
% end
% system(['fslmerge -t QA_t1.nii' pat])

% for x = 1 : length(ids_patientes_pap)
% %     system(['flirt -in ' strcat(char(ids_patientes_pap(x)),'/smwc1T1-',char(ids_patientes_pap(x)),'.nii') ' -ref /usr/local/fsl/data/standard/MNI152_T1_1mm_brain_mask.nii.gz -out ' strcat(char(ids_patientes_pap(x)),'/smwc1T1-',char(ids_patientes_pap(x)),'_rsmp.nii') ' -applyxfm'])
% %     system(['fslmaths ' strcat(char(ids_patientes_pap(x)),'/smwc1T1-',char(ids_patientes_pap(x)),'_rsmp.nii') ' -mul ' '/usr/local/fsl/data/standard/MNI152_T1_1mm_brain_mask.nii.gz ' strcat(char(ids_patientes_pap(x)),'/smwc1T1-',char(ids_patientes_pap(x)),'_mask.nii')])
%     system(['gunzip ' strcat(char(ids_patientes_pap(x)),'/smwc1T1-',char(ids_patientes_pap(x)),'_mask.nii')])
% end


for i = 1 : length(ids_patientes_pac)
    new_pat = (convertCharsToStrings(ids_patientes_pac{i}));
    splt_pat = split(new_pat,'-');
    splt_pat = split(splt_pat(2),'_');
    pat = splt_pat(1);
    a(i,1) = pat;
end

for i = 1 : length(ids_patientes_pap)
    new_pat = (convertCharsToStrings(ids_patientes_pap{i}));
    splt_pat = split(new_pat,'-');
    splt_pat = split(splt_pat(2),'_');
    pat = splt_pat(1);
    b(i,1) = pat;
end

all_ids = [b];

path_out_database = fullfile('/opt','dora','Dora','IBEAS','Resultados','Variables','Metilación','DTI_FA','stats');
[name_database, name_var] = search_database(all_ids,path_out_database);
%%

fileID = readtable(name_database);

%fileID(8,:) = [];
%fileID(47,:) = [];

name_var = name_var(end);
path_out_analysis = fullfile('/opt','dora','Dora','IBEAS','Resultados','Variables','Metilación','DTI_FA','stats',name_var(end));
mkdir(path_out_analysis)

% Create matrix design

norm_data_3 = normalize(fileID{:,2});
norm_data_4 = normalize(fileID{:,4});

[rows, columns] = size(fileID);

fid = fopen( 'design1.txt', 'wt' );
formatSpec = '/NumWaves %d\n/NumPoints %d\n/Matrix\n';
fprintf(fid, formatSpec, columns,rows);
for i = 1 : rows
    if string(fileID{i,3}) == 'Hombre'
        sex_norm(i,1) = 1;  %Hombre = 1
    else
       sex_norm(i,1) = 2;  %Mujer = 2
    end
end

matrix_final = [ones(rows,1) norm_data_3 normalize(sex_norm) norm_data_4];

for x = 1 : length(matrix_final)
    fprintf(fid, '%f %f %f %f\n',matrix_final(x,1),matrix_final(x,2),matrix_final(x,3),matrix_final(x,4)) %Hombre = 1
end
%fprintf(fid, '%f\n %f\n %f\n %f\n',matrix_final) %Hombre = 1

fclose(fid);

fid = fopen( 'design.con', 'wt' );
formatSpec = '/NumWaves %d\n/NumPoints %d\n/Matrix\n0 0 0 1\n0 0 0 -1\n';
fprintf(fid, formatSpec, columns,2);
fclose(fid);

mk_folders = fullfile('/opt','dora','Dora','IBEAS','Resultados','Variables','Metilación','DTI_FA','stats');

movefile(fullfile(mk_folders,'design1.txt'),fullfile(path_out_analysis,'design.mat'))
movefile(fullfile(mk_folders,'design.con'),fullfile(path_out_analysis,'design.con'))
movefile(fullfile(mk_folders,name_database), path_out_analysis)

%%

cmd = (['randomise -i ' char(fullfile(mk_folders,'all_FA_skeletonised.nii.gz')) ' -o ' char(fullfile(path_out_analysis,'tbss_FA')) ' -m ' char(fullfile(mk_folders,'mean_FA_skeleton_mask.nii.gz')) ' -d ' char(fullfile(path_out_analysis,'design.mat')) ' -t ' char(fullfile(path_out_analysis,'design.con')) ' -n 500 --T2 --uncorrp']);
disp(cmd)
system(cmd);
%%
cmd = (['randomise -i ' char(fullfile(mk_folders,'all_MD_skeletonised.nii.gz')) ' -o ' char(fullfile(path_out_analysis,'tbss_MD')) ' -m ' char(fullfile(mk_folders,'mean_FA_skeleton_mask.nii.gz')) ' -d ' char(fullfile(path_out_analysis,'design.mat')) ' -t ' char(fullfile(path_out_analysis,'design.con')) ' -n 500 --T2 --uncorrp']);
disp(cmd)
system(cmd);


