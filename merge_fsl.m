function merge_fsl(list_asl,path_out)

if ~exist(fullfile(path_out,'asl_merge.nii.gz'))
    cd(path_out)
    cmdsys = ['fslmerge -t asl_merge' list_asl];
    disp(cmdsys);
    system(cmdsys);
else
    warning("The file already exist in this path")
    warning("Merge operation no performed")
end
end