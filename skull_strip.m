function skull_strip(session_dir, subject_name)

    % Skullstrip structual file using Freesurfer
    
    SUBJECTS_DIR = getenv('SUBJECTS_DIR');
    
%     if exist(fullfile(session_dir,'MP2RAGE'),'dir')
%         disp('Skull stripping anatomical using bbregister');
%         % Register using bbregister
%         filefor_reg = fullfile(session_dir,'MP2RAGE','004','MP2RAGE.nii.gz'); % Anatomical file for bbregister
%         bbreg_out_file = fullfile(session_dir,'MP2RAGE','004','bbreg.dat'); % name of registration file
%         mask_file = fullfile(session_dir,'MP2RAGE','004','MP2RAGE_mask'); % mask file
%         [~,~] = system(['bbregister --s ' subject_name ' --mov ' filefor_reg ' --reg ' bbreg_out_file ' --init-fsl --t1']);
%         load(fullfile(session_dir,'MP2RAGE','004','bbreg.dat.mincost'));
%         mincost = bbreg_dat(1);
%         disp('The min cost value of MP2RAGE registration was:')
%         disp(num2str(mincost));
%         if mincost > 0.6
%             % adjust poor registration
%             [~,~] = system(['tkregister2 --mov ' filefor_reg ' --reg ' bbreg_out_file ' --surf']);
%             [~,~] = system(['bbregister --s ' subject_name ' --mov ' filefor_reg ' --reg ' bbreg_out_file ' --init-reg ' ...
%                 bbreg_out_file ' --t1']);
%             load(fullfile(session_dir,'MP2RAGE','004','bbreg.dat.mincost'));
%             mincost = bbreg_dat(1);
%             disp('The min cost value of MP2RAGE registration was:')
%             disp(num2str(mincost));
%             if mincost > 0.6
%                 input('Registration is still poor, proceed anyway?');
%             end
%         end
%         % Project 'brain.mgz' to subject's anatomical space
%         [~,~] = system(['mri_vol2vol --mov ' filefor_reg ' --targ ' ...
%             fullfile(SUBJECTS_DIR,subject_name,'mri','brain.mgz') ' --o ' ...
%             mask_file ' --reg ' bbreg_out_file ' --inv --nearest']);
%         % Mask original anatomical file using 'brain.mgz' to skull strip
%         out_file = fullfile(session_dir,'MP2RAGE','004','MP2RAGE_brain.nii.gz'); % brain extracted output file
%         [~,~] = system(['fslmaths ' filefor_reg ' -mas ' mask_file ' ' out_file]);

%     if exist(fullfile(session_dir,'MPRAGE'),'dir')
        disp('Skull stripping anatomical using bbregister');
        % Register using bbregister
        filefor_reg = fullfile(session_dir,'MPRAGE','001','MPRAGE.nii.gz'); % Anatomical file for bbregister
        bbreg_out_file = fullfile(session_dir,'MPRAGE','001','bbreg.dat'); % name of registration file
        mask_file = fullfile(session_dir,'MPRAGE','001','MPRAGE_mask.nii.gz'); % mask file
        [~,~] = system(['bbregister --s ' subject_name ' --mov ' filefor_reg ' --reg ' bbreg_out_file ' --init-fsl --t1']);
        load(fullfile(session_dir,'MPRAGE','001','bbreg.dat.mincost'));
        mincost = bbreg_dat(1);
        disp('The min cost value of MPRAGE registration was:')
        disp(num2str(mincost));
        if mincost > 0.6
            % adjust poor registration
            [~,~] = system(['tkregister2 --mov ' filefor_reg ' --reg ' bbreg_out_file ' --surf']);
            [~,~] = system(['bbregister --s ' subject_name ' --mov ' filefor_reg ' --reg ' bbreg_out_file ' --init-reg ' ...
                bbreg_out_file ' --t1']);
            load(fullfile(session_dir,'MPRAGE','001','bbreg.dat.mincost'));
            mincost = bbreg_dat(1);
            disp('The min cost value of MPRAGE registration was:')
            disp(num2str(mincost));
            if mincost > 0.6
                input('Registration is still poor, proceed anyway?');
            end
        end
        % Project 'brain.mgz' to subject's anatomical space
        [~,~] = system(['mri_vol2vol --mov ' filefor_reg ' --targ ' ...
            fullfile(SUBJECTS_DIR,subject_name,'mri','brain.mgz') ' --o ' ...
            mask_file ' --reg ' bbreg_out_file ' --inv --nearest']);
        % Mask original anatomical file using 'brain.mgz' to skull strip
        out_file = fullfile(session_dir,'MPRAGE','001','MPRAGE_brain.nii.gz'); % brain extracted output file
        [~,~] = system(['fslmaths ' filefor_reg ' -mas ' mask_file ' ' out_file]);
        %Convert transform from FS to FSL format for future use
        FSLbbreg_out_file = fullfile(session_dir,'MPRAGE','001','bbreg.mat'); % name of registration file
        commandc = ['tkregister2' ' --reg ' bbreg_out_file ' --mov ' filefor_reg ' --fstarg ' ' --fslregout ' FSLbbreg_out_file ' --noedit'];
        disp(commandc);
        system(commandc);
        %Calculate inverse transform
        FSLbbreg_out_file_inv = fullfile(session_dir,'MPRAGE','001','bbreg_inv.mat'); % name of registration file
        outmat = FSLbbreg_out_file_inv;
        inmat  = FSLbbreg_out_file;
        commandc = ['convert_xfm ' '-omat ' outmat ' -inverse ' inmat];
        disp(commandc);
        system(commandc);
%     end
end