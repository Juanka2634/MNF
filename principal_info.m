function [ids_control,ids_patients,num_files,paths_ctr_out,paths_pat_out] = principal_info (path_in,path_out,id_controls,id_patients,pair)
    
pair=(pair);

id_ctr = fullfile(path_in,id_controls+'*');
ids_control = listdir(id_ctr,'dirs');

id_pat = fullfile(path_in,id_patients+'*');
ids_patients_all = listdir(id_pat,'dirs');

i = 0;
j = 0;

for x = 1 : length(ids_patients_all)
    if (strlength(ids_patients_all(x)) == 8)
        i = i + 1;
        ids_patients(i) = ids_patients_all(x);
    else
        j = j + 1;
        ids_patientes_sec(j) = ids_patients_all(x);
    end
end
y = 0;
if pair == "pair"
    ids_patients = ids_patientes_sec;
    for z = 1 : length(ids_patients)
        y = y + 1;
        name = char(ids_patients(z));
        ids_temp(y) = cellstr(string(name(1:end-1)));
    end
    ids_control = ids_temp;
end

num_files = length(ids_control) + length(ids_patients);

num_control = sprintf('Number of expected controls = %d',length(ids_control));
num_patients = sprintf('Number of expected patients = %d',length(ids_patients));
num_total = sprintf('Total expected images = %d',num_files);

path_out_ctr_seg = '';
for nfile = 1 : length(ids_control)
    outfile = char(fullfile(path_in,ids_control(nfile),ids_control(nfile)));
    prevdir = dir([outfile '.nii*']);
    if ~isempty (prevdir)
        if ~exist(char(ids_control(nfile)),'dir')
            mkdir (char(fullfile(path_out,ids_control(nfile))))
            copyfile (char(fullfile(path_in,ids_control(nfile),"T1-"+char(ids_control(nfile))+".nii")),char(fullfile(path_out,ids_control(nfile))))
        end
        if nfile == 1
            path_out_ctr_seg = [char(fullfile(path_out,char(ids_control(nfile)),char(ids_control(nfile))+".nii,1"))];
            path_out_ctr_tmp = [char(fullfile(path_out,char(ids_control(nfile)),"rc1"+char(ids_control(nfile))+".nii,1"))];
            path_out_ctr_tmp2 = [char(fullfile(path_out,char(ids_control(nfile)),"rc2"+char(ids_control(nfile))+".nii,1"))];
            path_out_ctr_urc1 = [char(fullfile(path_out,char(ids_control(nfile)),"u_rc1"+char(ids_control(nfile))+"_Template.nii"))];
            path_out_ctr_rc = [char(fullfile(path_out,char(ids_control(nfile)),"c1"+char(ids_control(nfile))+".nii"))];
            path_out_ctr_mat = [char(fullfile(path_out,char(ids_control(nfile)),char(ids_control(nfile))+"_seg8.mat"))];
            path_out_ctr_test = [char(fullfile(path_out,char(ids_control(nfile)),"smwc1"+char(ids_control(nfile))+".nii,1"))];
        else
            path_out_ctr_seg = [char(path_out_ctr_seg);char(fullfile(path_out,char(ids_control(nfile)),char(ids_control(nfile))+".nii,1"))];
            path_out_ctr_tmp = [char(path_out_ctr_tmp);char(fullfile(path_out,char(ids_control(nfile)),"rc1"+char(ids_control(nfile))+".nii,1"))];
            path_out_ctr_tmp2 = [char(path_out_ctr_tmp2);char(fullfile(path_out,char(ids_control(nfile)),"rc2"+char(ids_control(nfile))+".nii,1"))];
            path_out_ctr_urc1 = [char(path_out_ctr_urc1);char(fullfile(path_out,char(ids_control(nfile)),"u_rc1"+char(ids_control(nfile))+"_Template.nii"))];
            path_out_ctr_rc = [char(path_out_ctr_rc);char(fullfile(path_out,char(ids_control(nfile)),"c1"+char(ids_control(nfile))+".nii"))];
            path_out_ctr_mat = [char(path_out_ctr_mat);char(fullfile(path_out,char(ids_control(nfile)),char(ids_control(nfile))+"_seg8.mat"))];
            path_out_ctr_test = [char(path_out_ctr_test);char(fullfile(path_out,char(ids_control(nfile)),"smwc1"+char(ids_control(nfile))+".nii,1"))];
        end
    end
end
for nfile = 1 : length(ids_patients)
    outfile = char(fullfile(path_in,ids_patients(nfile),ids_patients(nfile)));
    prevdir = dir([outfile '.nii']);
    if ~isempty (prevdir)
        if ~exist(char(ids_patients(nfile)),'dir')
            mkdir (char(fullfile(path_out,ids_patients(nfile))))
            copyfile (char(fullfile(path_in,ids_patients(nfile),char(ids_patients(nfile))+".nii")),char(fullfile(path_out,ids_patients(nfile))))
        end
        if nfile == 1
            path_out_pat_seg = [char(fullfile(path_out,char(ids_patients(nfile)),char(ids_patients(nfile))+".nii,1"))];
            path_out_pat_tmp = [char(fullfile(path_out,char(ids_patients(nfile)),"rc1"+char(ids_patients(nfile))+".nii,1"))];
            path_out_pat_tmp2 = [char(fullfile(path_out,char(ids_patients(nfile)),"rc2"+char(ids_patients(nfile))+".nii,1"))];
            path_out_pat_urc1 = [char(fullfile(path_out,char(ids_patients(nfile)),"u_rc1"+char(ids_patients(nfile))+"_Template.nii"))];
            path_out_pat_rc = [char(fullfile(path_out,char(ids_patients(nfile)),"c1"+char(ids_patients(nfile))+".nii"))];
            path_out_pat_mat = [char(fullfile(path_out,char(ids_patients(nfile)),char(ids_patients(nfile))+"_seg8.mat"))];
            path_out_pat_test = [char(fullfile(path_out,char(ids_patients(nfile)),"smwc1"+char(ids_patients(nfile))+".nii,1"))];
        else
            path_out_pat_seg = [char(path_out_pat_seg);char(fullfile(path_out,char(ids_patients(nfile)),char(ids_patients(nfile))+".nii,1"))];
            path_out_pat_tmp = [char(path_out_pat_tmp);char(fullfile(path_out,char(ids_patients(nfile)),"rc1"+char(ids_patients(nfile))+".nii,1"))];
            path_out_pat_tmp2 = [char(path_out_pat_tmp2);char(fullfile(path_out,char(ids_patients(nfile)),"rc2"+char(ids_patients(nfile))+".nii,1"))];
            path_out_pat_urc1 = [char(path_out_pat_urc1);char(fullfile(path_out,char(ids_patients(nfile)),"u_rc1"+char(ids_patients(nfile))+"_Template.nii"))];
            path_out_pat_rc = [char(path_out_pat_rc);char(fullfile(path_out,char(ids_patients(nfile)),"c1"+char(ids_patients(nfile))+".nii"))];
            path_out_pat_mat = [char(path_out_pat_mat);char(fullfile(path_out,char(ids_patients(nfile)),char(ids_patients(nfile))+"_seg8.mat"))];
            path_out_pat_test = [char(path_out_pat_test);char(fullfile(path_out,char(ids_patients(nfile)),"smwc1"+char(ids_patients(nfile))+".nii,1"))];
        end
    end
end

paths_ctr_out = [string(path_out_ctr_seg),string(path_out_ctr_tmp),string(path_out_ctr_tmp2),string(path_out_ctr_urc1),string(path_out_ctr_rc),path_out_ctr_mat,string(path_out_ctr_test)];
paths_pat_out = [string(path_out_pat_seg),string(path_out_pat_tmp),string(path_out_pat_tmp2),string(path_out_pat_urc1),string(path_out_pat_rc),path_out_pat_mat,string(path_out_pat_test)];

%     path_out_img = [path_out_ctr_seg;path_out_pat_seg];
%     path_out_img = cellstr(path_out_img);
%     path_out_tmp1 = [path_out_ctr_tmp;path_out_pat_tmp];
%     path_out_tmp2 = [path_out_ctr_tmp2;path_out_pat_tmp2];
%     path_out_tmp1 = cellstr(path_out_tmp1);
%     path_out_tmp2 = cellstr(path_out_tmp2);

num_control_found = sprintf('Number of controls found = %d',length(string(path_out_ctr_seg)));
num_patients_found = sprintf('Number of patients found = %d',length(string(path_out_pat_seg)));
num_total_found = sprintf('Total images = %d',length([string(path_out_ctr_seg);path_out_pat_seg]));

disp(num_control);
disp(num_patients);
disp(num_total);
disp(num_control_found);
disp(num_patients_found);
disp(num_total_found);

end