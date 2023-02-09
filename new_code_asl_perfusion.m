% Code main for the asl series preprocessing
clear
clc

% Add paths oh functions
%%
path_work = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect');
addpath(path_work)

%% Paths init

path_in_data = fullfile('/opt','dora','Dora','BIDS_ELA','RAW_DATA');
path_out_data = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect');
asl_files_folder = listdir(fullfile(path_in_data,'sub-*'),'dirs');

for  i = 1 : length(asl_files_folder)
    id = char(asl_files_folder(i));
    id_free = strsplit(id,'-');
    id_freesurfer = id_free{2};
    if length(id_free) > 2
        id_freesurfer = char(string(id_free(2))+"-2");
        idss = strsplit(char(asl_files_folder(i)),'-');
        ids = char(string(idss{1})+"-"+string(idss{2})+"2");
    else
        id_freesurfer = char(string(id_free(2)));
        idss = strsplit(char(asl_files_folder(i)),'-');
        ids = char(string(idss{1})+"-"+string(idss{2}));
    end

    asl_files = listdir(fullfile(path_in_data,id,'*_wip_pcasl*'),'dirs');
    if length(asl_files) ~= 1
        for q = 1 : length(asl_files)

            path_asl = fullfile(path_in_data,id,char(asl_files(q)));
            path_T1_folder = char(listdir(fullfile(path_in_data,id,'*t1_mprage_sag_p2_iso_ns_'),'dirs'));
            path_T1 = fullfile(path_in_data,id,path_T1_folder);
            path_out = fullfile(path_out_data,id);

            %% Move files and convert go to nifti files

            %Definir el formato de los archivos descargados (ELA)
            
            protocol_name = mv_cv_files(path_asl,path_out,"ELA");
            
            path_work = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect',id,protocol_name);
            
            rm_files_dir = listdir(fullfile(path_work,'asl_alin_mni_*'),'files');
            for xx = 1 : length(rm_files_dir)
                delete (string(fullfile(path_work,rm_files_dir(xx))));
            end

            %% MCFLIRT for correrction motion

            count_file = dir(fullfile(path_work,"/*.nii"));

            list_asl='';
            for img_asl = 2 : length(count_file)
                list_asl = [list_asl ' ' count_file(img_asl).name];
            end

            merge_fsl(list_asl,fullfile(path_out,protocol_name));

            asl_merge_in = 'asl_merge.nii';
            file_mcf = 'asl_merge_mcf.nii.gz';

            MCFLIRT(path_work,asl_merge_in,file_mcf,0);

            %% Smooth series registed and M0 registed

            % Note. FSL uses sigma instead of FWHM to define the Gaussian
            % kernel
            % FWHM = 2.3548 * sigma; % http://mathworld.wolfram.com/GaussianFunction.html

            % labels, controls

            file_mcf = fullfile(path_work,'mcflirt','asl_merge_mcf.nii.gz');
            skernel = 8; %mm (puede ser 6)
            smooth_mcf = fullfile(path_work,'mcflirt',['s' num2str(skernel) 'asl_merge_mcf.nii.gz']);

            commandc = (['fslmaths ' file_mcf ' -s ' num2str(1/2.3548 * skernel) ' ' smooth_mcf]);
            disp(commandc);
            system(commandc);

            % M0

            file_mcf_M0 = fullfile(path_work,count_file(1).name);
            smooth_mcf_M0 = fullfile(path_work,'mcflirt',['s' num2str(skernel) count_file(1).name '.gz']);

            commandc = (['fslmaths ' file_mcf_M0 ' -s ' num2str(1/2.3548 * skernel) ' ' smooth_mcf_M0]);
            disp(commandc);
            system(commandc);

            %%

            cd(path_work)
            dir_split = fullfile(path_work,'mcflirt','s8asl_merge_mcf.nii.gz');
            cmdsys = ['fslsplit ' dir_split ' grot'];
            system(cmdsys);

            sub_files = dir(fullfile(path_work,'grot*'));

            listvols = '';
            aux = 1;
            for iscan = 1 : length(sub_files)
                if rem(iscan,2) == 0
                    res = ['fslmaths ' sprintf('grot%04d',iscan-1) ' -sub ' sprintf('grot%04d',iscan-2) ' ' sprintf('asl_alin_%d',aux)];
                    disp(res);
                    system(res);
                    listvols = [listvols ' ' sprintf('asl_alin_%d',aux)];
                    if exist(fullfile(path_work,sprintf('asl_alin_%d.nii',aux)),'file')
                        delete(fullfile(path_work,sprintf('asl_alin_%d.nii',aux)))
                        system(['gunzip ' fullfile(path_work,sprintf('asl_alin_%d.nii.gz',aux))]);
                    else
                        system(['gunzip ' fullfile(path_work,sprintf('asl_alin_%d.nii.gz',aux))]);
                    end
                    aux = aux + 1;
                end
            end
            cmdsys = ['fslmerge -t asl_merge_alin_sm' listvols];
            disp(cmdsys);
            system(cmdsys)

            %% Perfusion

            new_str = split(path_asl,'_');
            cbf=[];

            asl_alin_files = dir(fullfile(path_work,'asl_alin_*.nii'));
            asl_m0_zip = (['s' num2str(skernel) count_file(1).name '.gz']);
            asl_m0_gunzip = (['s' num2str(skernel) count_file(1).name]);
            if exist(fullfile(path_work,'mcflirt',asl_m0_gunzip),'file')
                system(['gunzip ' fullfile(path_work,'mcflirt',asl_m0_zip)]);
                delete(fullfile(path_work,'mcflirt',asl_m0_gunzip))
            else
                system(['gunzip ' fullfile(path_work,'mcflirt',asl_m0_zip)]);
            end
            

            M0_vol = spm_vol(fullfile(path_work,'mcflirt',asl_m0_gunzip));
            M0 = spm_read_vols(M0_vol);
            
            if length(new_str) > 10
                tau1 = split(new_str(8),'L');
            tau = str2double(tau1(2))/1000; % seconds

            PLD1 = split(new_str(9),'P');
            PLD = str2double(PLD1(2))/1000; %seconds
            
            else

            tau1 = split(new_str(7),'L');
            tau = str2double(tau1(2))/1000; % seconds

            PLD1 = split(new_str(8),'P');
            PLD = str2double(PLD1(2))/1000; %seconds
            
            end
            for x = 1 : length(asl_alin_files)

                restado1 = spm_vol(fullfile(path_work,sprintf('asl_alin_%d.nii',x)));
                rest = spm_read_vols(restado1);

                lambda = 0.9; % mL/g, blood-brain partition coefficient
                T1_blood = 1.65; % s
                alpha = 0.6; % 0.85 labeling efficiency
                %tau = 1.5 ; % Labeling duration
                %PLD = 1.5 ;% Time post labeling
                SI_PD = M0*10; % The signal intensity of a proton density-weightes image

                cbf(:,:,:,x) = (6000*lambda*(rest)*exp(PLD/T1_blood))./(2*alpha*T1_blood*SI_PD*(1-exp(-tau/T1_blood)));

                %             V3 = M0_vol;
                %             V3.fname = fullfile(path_work,sprintf('asl_cbf_%d.nii',x));

            end

            cbf_average = mean(cbf,4);

            V3 = M0_vol;
            V3.fname = fullfile(path_work,'asl_cbf.nii');
            spm_write_vol(V3,(cbf_average));



            %% register asl_files to t1_talairach(freesurfer)

            M0_img = fullfile(path_work,count_file(1).name);
            asl_T1_matrix = fullfile(path_work,'asl_T1_matrix.dat');

            system(['bbregister --s T1-' id_freesurfer ' --mov ' M0_img ' --reg ' asl_T1_matrix ' --init-fsl --t2'])

            asl_t1_matrix_fsl = fullfile(path_work,'asl_T1_matrix.mat'); % name registration file
            commandc = ['tkregister2' ' --reg ' asl_T1_matrix ' --mov ' M0_img ' --fstarg ' ' --fslregout ' asl_t1_matrix_fsl ' --noedit'];
            disp(commandc);
            system(commandc);

            %% space talairach to space mni152

            MNI_file = fullfile('/usr','local','fsl','data','standard','MNI152_T1_2mm_brain.nii.gz');
            MNI_T1_matrix = fullfile(path_work,'MNI_T1_matrix.dat');
            % get the array mni152 to talairach and the inverse talairach to mni152
            system(['mni152reg ' '--s T1-' id_freesurfer]);
            SUBJECTS_DIR = getenv('SUBJECTS_DIR');
            FSLbbreg_out_file_inv = fullfile(SUBJECTS_DIR, sprintf('T1-%s',id_freesurfer), 'mri', 'transforms', 'reg.mni152.2mm_inv.mat'); % name of registration file;
            inmat  = fullfile(SUBJECTS_DIR, sprintf('T1-%s',id_freesurfer), 'mri', 'transforms', 'reg.mni152.2mm.dat.fsl.mat');
            commandc = ['convert_xfm ' '-omat ' FSLbbreg_out_file_inv ' -inverse ' inmat];
            disp(commandc);
            system(commandc);
            %Arrays in your diferents spaces, the space A is scanner space, the space B is talairach space and space C is MNI space.
            mat_AtoB = asl_t1_matrix_fsl;
            mat_BtoC = FSLbbreg_out_file_inv;
            outmat_AtoC = fullfile(path_work, 'asl2mni.mat');
            %Concatenate arrays to change to different spaces
            commandc = ['convert_xfm -omat ' outmat_AtoC ' -concat ' mat_BtoC ' ' mat_AtoB];
            disp(commandc);
            system(commandc);
            %apply arrays to change scanner space to MNI space
            outputvol = fullfile(path_work,'asl_cbf_mni.nii');
            commandc = ['mri_vol2vol' ' --fsl ' outmat_AtoC ' --mov ' fullfile(path_work,'asl_cbf.nii') ' --targ ' MNI_file ' --o ' outputvol]; % ' --fstarg'];
            disp(commandc);
            system(commandc);

            %% get brainmask with freesurfer

            outputvol_mask = fullfile(path_work,'asl_cbf_mni_mask.nii');
            commandc = ['mri_vol2vol' ' --fsl ' FSLbbreg_out_file_inv ' --mov ' fullfile(SUBJECTS_DIR,sprintf('T1-%s',id_freesurfer),'mri','aseg.mgz ') ...
                ' --targ ' MNI_file ' --o ' outputvol_mask]; % ' --fstarg'];
            disp(commandc);
            system(commandc);
            %
            % brain_talairach = fullfile(path_work,'aseg_talairach.nii.gz');
            % system(['mri_convert ' fullfile(SUBJECTS_DIR,sprintf('T1-%s',id_freesurfer),'mri','aseg.mgz ') brain_talairach])

            %% asl_final to space mni
            
            asl_all_files = listdir(fullfile(path_work,'asl_alin_*'),'files');
            for k = 1 : length(asl_all_files)
                files_asl = fullfile(path_work,string(asl_all_files(k)));
                files_asl_mni = fullfile(path_work,sprintf('mni_asl_%d.nii',k));
                system(['mri_vol2vol --fsl ' outmat_AtoC ' --mov ' char(files_asl) ' --targ ' MNI_file ' --o ' char(files_asl_mni)])
            end

            %% get brainmask with spm

            path_dartel = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','Volumetria','DARTEL',ids);
            c1_gm = fullfile(path_dartel,sprintf('c1%s.nii',ids));
            c2_wm = fullfile(path_dartel,sprintf('c2%s.nii',ids));

            skernel_dartel = 4; %mm (puede ser 6)
            c1_gm_sm = fullfile(path_out,'c1_gm_sm.nii.gz');
            c2_wm_sm = fullfile(path_out,'c2_wm_sm.nii.gz');

            thc1 = '0.5';
            thc2 = '0.5';

            c11_gm_sm = fullfile(path_work,sprintf('c1_gm_sm_thr_%s.nii.gz',thc1));
            c21_wm_sm = fullfile(path_work,sprintf('c2_wm_sm_thr_%s.nii.gz',thc2));

            cmd=(['fslmaths ' c1_gm ' -s ' num2str(1/2.3548 * skernel_dartel) ' ' c1_gm_sm]);
            disp(cmd);
            system(cmd);

            cmd=(['fslmaths ' c2_wm ' -s ' num2str(1/2.3548 * skernel_dartel) ' ' c2_wm_sm]);
            disp(cmd);
            system(cmd);

            img_c1_gm_sm = spm_vol(c1_gm_sm);
            c1_gm_sm_img = spm_read_vols(img_c1_gm_sm);
            img_c2_wm_sm = spm_vol(c2_wm_sm);
            c2_wm_sm_img = spm_read_vols(img_c2_wm_sm);

            threshold = 0.15;
            n_pasadas = 3;
            segmented_mask_12 = double((c1_gm_sm_img+c2_wm_sm_img) >= threshold & (c1_gm_sm_img >= threshold | c2_wm_sm_img >= threshold));
            segmented_mask_12 = fill_in_holes_inside_brain(segmented_mask_12,n_pasadas);
            V3 = img_c1_gm_sm;
            V3.fname = fullfile(path_work,'img_brain_fillholes.nii');
            spm_write_vol(V3,(segmented_mask_12))

            %segmentar c1 y c2

            %         segmented_mask_12 = double(c1_gm_sm_img) >= 0.75
            % %         segmented_mask_12 = fill_in_holes_inside_brain(segmented_mask_12,n_pasadas);
            %
            %         V3 = img_c1_gm_sm;
            %         V3.fname = fullfile(path_work,'img_c1gm_fillholes.nii');
            %         spm_write_vol(V3,(segmented_mask_12))
            %
            %         segmented_mask_12 = double(c2_wm_sm_img) >= 0.5
            % %         segmented_mask_12 = fill_in_holes_inside_brain(segmented_mask_12,n_pasadas);
            %         V3 = img_c1_gm_sm;
            %         V3.fname = fullfile(path_work,'img_c2wm_fillholes.nii');
            %         spm_write_vol(V3,(segmented_mask_12))

            %

            MNI_flirt_mask = fullfile(path_work,'mni_flirt_mask_fillholes.nii');
            MNI_flirt_mask_mat = fullfile(path_work,'mni_flirt_mask_fillholes.mat');

            % Use mat_BtoC

            cmd = (['flirt -in ' V3.fname ' -ref ' MNI_file ' -out ' MNI_flirt_mask ' -omat ' MNI_flirt_mask_mat ...
                ' -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear']);
            disp(cmd);
            system(cmd);

            %%

            mask_brain_talairach = fullfile(path_work,'mask_brain_mni.nii.gz');
            mask_brain_talairach_bin = fullfile(path_work,'mask_brain_mni_bin.nii.gz');

            system(['fslmaths ' MNI_flirt_mask ' -mas ' outputvol ' ' mask_brain_talairach]);
            system(['fslmaths ' mask_brain_talairach ' -bin ' mask_brain_talairach_bin]);

            perfusion_mni = fullfile(path_work,'perfusion_mni_.nii.gz');
            system(['fslmaths ' mask_brain_talairach_bin ' -mul ' outputvol ' ' perfusion_mni]);

            threshold_mni_c1 = '0.5';
            threshold_mni_c2 = '0.5';

            MNI_c1_flirt_mask = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c1_%s.nii',threshold_mni_c1));
            MNI_c1_flirt_mask_mat = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c1_%s.mat',threshold_mni_c1));

            system(['fslmaths ' c1_gm_sm ' -thr ' threshold_mni_c1 ' -bin ' c11_gm_sm]);

            cmd = (['flirt -in ' c11_gm_sm ' -ref ' MNI_file ' -out ' MNI_c1_flirt_mask ' -omat ' MNI_c1_flirt_mask_mat ...
                ' -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear']);
            disp(cmd);
            system(cmd);

            system(['fslmaths ' MNI_c1_flirt_mask ' -mul ' perfusion_mni ' ' fullfile(path_work,sprintf('c1_gm_sm_mni_%s.nii.gz',threshold_mni_c1))]);

            MNI_c2_flirt_mask = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c2_%s.nii',threshold_mni_c2));
            MNI_c2_flirt_mask_mat = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c2_%s.mat',threshold_mni_c2));

            system(['fslmaths ' c2_wm_sm ' -thr ' threshold_mni_c2 ' -bin ' c21_wm_sm]);

            cmd = (['flirt -in ' c21_wm_sm ' -ref ' MNI_file ' -out ' MNI_c2_flirt_mask ' -omat ' MNI_c2_flirt_mask_mat ...
                ' -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear']);
            disp(cmd);
            system(cmd);

            system(['fslmaths ' MNI_c2_flirt_mask ' -mul ' perfusion_mni ' ' fullfile(path_work,sprintf('c2_wm_sm_mni_%s.nii.gz',threshold_mni_c2))])

            %%
            rm_files_dir = listdir(fullfile(path_work,sprintf('MF%s*',id_freesurfer)),'files');
            for x = 2 : length(rm_files_dir)
                delete (string(fullfile(path_work,rm_files_dir(x))))
            end

            cmdsys = 'rm -f grot*';
            disp(cmdsys);
            system(cmdsys)

            cd(fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect'));
        end
    else
        path_asl = fullfile(path_in_data,id,char(asl_files(1)));
        path_T1_folder = char(listdir(fullfile(path_in_data,id,'*t1_mprage_sag_p2_iso_ns_'),'dirs'));
        path_T1 = fullfile(path_in_data,id,path_T1_folder);
        path_out = fullfile(path_out_data,id);

        %% Move files and convert go to nifti files

        %Definir el formato de los archivos descargados (ELA)

        protocol_name = mv_cv_files(path_asl,path_out,"ELA");

        path_work = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect',id,protocol_name);

        %% MCFLIRT for correrction motion

        count_file = dir(fullfile(path_work,"/*.nii"));

        list_asl='';
        for img_asl = 2 : length(count_file)
            list_asl = [list_asl ' ' count_file(img_asl).name];
        end

        merge_fsl(list_asl,fullfile(path_out,protocol_name));

        asl_merge_in = 'asl_merge.nii';
        file_mcf = 'asl_merge_mcf.nii.gz';

        MCFLIRT(path_work,asl_merge_in,file_mcf,0);

        %% Smooth series registed and M0 registed

        % Note. FSL uses sigma instead of FWHM to define the Gaussian
        % kernel
        % FWHM = 2.3548 * sigma; % http://mathworld.wolfram.com/GaussianFunction.html

        % labels, controls

        file_mcf = fullfile(path_work,'mcflirt','asl_merge_mcf.nii.gz');
        skernel = 8; %mm (puede ser 6)
        smooth_mcf = fullfile(path_work,'mcflirt',['s' num2str(skernel) 'asl_merge_mcf.nii.gz']);

        commandc = (['fslmaths ' file_mcf ' -s ' num2str(1/2.3548 * skernel) ' ' smooth_mcf]);
        disp(commandc);
        system(commandc);

        % M0

        file_mcf_M0 = fullfile(path_work,count_file(1).name);
        smooth_mcf_M0 = fullfile(path_work,'mcflirt',['s' num2str(skernel) count_file(1).name '.gz']);

        commandc = (['fslmaths ' file_mcf_M0 ' -s ' num2str(1/2.3548 * skernel) ' ' smooth_mcf_M0]);
        disp(commandc);
        system(commandc);

        %%

        cd(path_work)
        dir_split = fullfile(path_work,'mcflirt','s8asl_merge_mcf.nii.gz');
        cmdsys = ['fslsplit ' dir_split ' grot'];
        system(cmdsys);

        sub_files = dir(fullfile(path_work,'grot*'));

        listvols = '';
        aux = 1;
        for iscan = 1 : length(sub_files)
            if rem(iscan,2) == 0
                res = ['fslmaths ' sprintf('grot%04d',iscan-1) ' -sub ' sprintf('grot%04d',iscan-2) ' ' sprintf('asl_alin_%d',aux)];
                disp(res);
                system(res);
                listvols = [listvols ' ' sprintf('asl_alin_%d',aux)];
                if exist(fullfile(path_work,sprintf('asl_alin_%d.nii',aux)),'file')
                    delete(fullfile(path_work,sprintf('asl_alin_%d.nii',aux)))
                    system(['gunzip ' fullfile(path_work,sprintf('asl_alin_%d.nii.gz',aux))]);
                else
                    system(['gunzip ' fullfile(path_work,sprintf('asl_alin_%d.nii.gz',aux))]);
                end
                aux = aux + 1;
            end
        end
        cmdsys = ['fslmerge -t asl_merge_alin_sm' listvols];
        disp(cmdsys);
        system(cmdsys)

        %% Perfusion

        new_str = split(path_asl,'_');
        cbf = [];

        asl_alin_files = dir(fullfile(path_work,'asl_alin_*'));
        asl_m0_zip = (['s' num2str(skernel) count_file(1).name '.gz']);
        if exist(fullfile(path_work,'mcflirt',asl_m0_zip),'file')
            delete(fullfile(path_work,'mcflirt',['s' num2str(skernel) count_file(1).name]))
            system(['gunzip ' fullfile(path_work,'mcflirt',asl_m0_zip)])
        end
        asl_m0_gunzip = (['s' num2str(skernel) count_file(1).name]);
        

        M0_vol = spm_vol(fullfile(path_work,'mcflirt',asl_m0_gunzip));
        M0 = spm_read_vols(M0_vol);
        
        if length(new_str) > 10
            tau1 = split(new_str(8),'L');
            tau = str2double(tau1(2))/1000; % seconds
            
            PLD1 = split(new_str(9),'P');
            PLD = str2double(PLD1(2))/1000; %seconds
            
        else
            
            tau1 = split(new_str(7),'L');
            tau = str2double(tau1(2))/1000; % seconds
            
            PLD1 = split(new_str(8),'P');
            PLD = str2double(PLD1(2))/1000; %seconds
        end

        for x = 1 : length(asl_alin_files)

            restado1 = spm_vol(fullfile(path_work,sprintf('asl_alin_%d.nii',x)));
            rest = spm_read_vols(restado1);

            lambda = 0.9; % mL/g, blood-brain partition coefficient
            T1_blood = 1.65; % s
            alpha = 0.6; % 0.85 labeling efficiency
            %tau = 1.5 ; % Labeling duration
            %PLD = 1.5 ;% Time post labeling
            SI_PD = M0*10; % The signal intensity of a proton density-weightes image

            cbf(:,:,:,x) = (6000*lambda*(rest)*exp(PLD/T1_blood))./(2*alpha*T1_blood*SI_PD*(1-exp(-tau/T1_blood)));

            %             V3 = M0_vol;
            %             V3.fname = fullfile(path_work,sprintf('asl_cbf_%d.nii',x));

        end

        cbf_average = mean(cbf,4);

        V3 = M0_vol;
        V3.fname = fullfile(path_work,'asl_cbf.nii');
        spm_write_vol(V3,(cbf_average));



        %% register asl_files to t1_talairach(freesurfer)

        M0_img = fullfile(path_work,count_file(1).name);
        asl_T1_matrix = fullfile(path_work,'asl_T1_matrix.dat');
        system(['bbregister --s T1-' id_freesurfer ' --mov ' M0_img ' --reg ' asl_T1_matrix ' --init-fsl --t2'])
        asl_t1_matrix_fsl = fullfile(path_work,'asl_T1_matrix.mat'); % name registration file
        commandc = ['tkregister2' ' --reg ' asl_T1_matrix ' --mov ' M0_img ' --fstarg ' ' --fslregout ' asl_t1_matrix_fsl ' --noedit'];
        disp(commandc);
        system(commandc);

        %% space talairach to space mni152

        MNI_file = fullfile('/usr','local','fsl','data','standard','MNI152_T1_2mm_brain.nii.gz');
        MNI_T1_matrix = fullfile(path_work,'MNI_T1_matrix.dat');
        % get the array mni152 to talairach and the inverse talairach to mni152
        system(['mni152reg ' '--s T1-' id_freesurfer]);
        SUBJECTS_DIR = getenv('SUBJECTS_DIR');
        FSLbbreg_out_file_inv = fullfile(SUBJECTS_DIR, sprintf('T1-%s',id_freesurfer), 'mri', 'transforms', 'reg.mni152.2mm_inv.mat'); % name of registration file;
        inmat  = fullfile(SUBJECTS_DIR, sprintf('T1-%s',id_freesurfer), 'mri', 'transforms', 'reg.mni152.2mm.dat.fsl.mat');
        commandc = ['convert_xfm ' '-omat ' FSLbbreg_out_file_inv ' -inverse ' inmat];
        disp(commandc);
        system(commandc);
        %Arrays in your diferents spaces, the space A is scanner space, the space B is talairach space and space C is MNI space.
        mat_AtoB = asl_t1_matrix_fsl;
        mat_BtoC = FSLbbreg_out_file_inv;
        outmat_AtoC = fullfile(path_work, 'asl2mni.mat');
        %Concatenate arrays to change to different spaces
        commandc = ['convert_xfm -omat ' outmat_AtoC ' -concat ' mat_BtoC ' ' mat_AtoB];
        disp(commandc);
        system(commandc);
        %apply arrays to change scanner space to MNI space
        outputvol = fullfile(path_work,'asl_cbf_mni.nii');
        commandc = ['mri_vol2vol' ' --fsl ' outmat_AtoC ' --mov ' fullfile(path_work,'asl_cbf.nii') ' --targ ' MNI_file ' --o ' outputvol]; % ' --fstarg'];
        disp(commandc);
        system(commandc);

        %% get brainmask with freesurfer

        outputvol_mask = fullfile(path_work,'asl_cbf_mni_mask.nii');
        commandc = ['mri_vol2vol' ' --fsl ' FSLbbreg_out_file_inv ' --mov ' fullfile(SUBJECTS_DIR,sprintf('T1-%s',id_freesurfer),'mri','brainmask.mgz ') ...
            ' --targ ' MNI_file ' --o ' outputvol_mask]; % ' --fstarg'];
        disp(commandc);
        system(commandc);
        %
        % brain_talairach = fullfile(path_work,'aseg_talairach.nii.gz');
        % system(['mri_convert ' fullfile(SUBJECTS_DIR,sprintf('T1-%s',id_freesurfer),'mri','aseg.mgz ') brain_talairach])

        %% asl_final to space mni
       
        asl_all_files = listdir(fullfile(path_work,'asl_alin_*'),'files');
        for k = 1 : length(asl_all_files)
            files_asl = fullfile(path_work,string(asl_all_files(k)));
            files_asl_mni = fullfile(path_work,sprintf('mni_asl_%d.nii',k));
            system(['mri_vol2vol --fsl ' outmat_AtoC ' --mov ' char(files_asl) ' --targ ' MNI_file ' --o ' char(files_asl_mni)])
        end

        %% get brainmask with spm

        
        path_dartel = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','Volumetria','DARTEL',ids);

        c1_gm = fullfile(path_dartel,sprintf('c1%s.nii',ids));
        c2_wm = fullfile(path_dartel,sprintf('c2%s.nii',ids));

        skernel_dartel = 4; %mm (puede ser 6)
        c1_gm_sm = fullfile(path_out,'c1_gm_sm.nii.gz');
        c2_wm_sm = fullfile(path_out,'c2_wm_sm.nii.gz');

        thc1 = '0.5';
        thc2 = '0.5';

        c11_gm_sm = fullfile(path_work,sprintf('c1_gm_sm_thr_%s.nii.gz',thc1));
        c21_wm_sm = fullfile(path_work,sprintf('c2_wm_sm_thr_%s.nii.gz',thc2));


        cmd=(['fslmaths ' c1_gm ' -s ' num2str(1/2.3548 * skernel_dartel) ' ' c1_gm_sm]);
        disp(cmd);
        system(cmd);

        cmd=(['fslmaths ' c2_wm ' -s ' num2str(1/2.3548 * skernel_dartel) ' ' c2_wm_sm]);
        disp(cmd);
        system(cmd);

        img_c1_gm_sm = spm_vol(c1_gm_sm);
        c1_gm_sm_img = spm_read_vols(img_c1_gm_sm);
        img_c2_wm_sm = spm_vol(c2_wm_sm);
        c2_wm_sm_img = spm_read_vols(img_c2_wm_sm);

        threshold = 0.15;
        n_pasadas = 3;
        segmented_mask_12 = double((c1_gm_sm_img+c2_wm_sm_img) >= threshold & (c1_gm_sm_img >= threshold | c2_wm_sm_img >= threshold));
        segmented_mask_12 = fill_in_holes_inside_brain(segmented_mask_12,n_pasadas);
        V3 = img_c1_gm_sm;
        V3.fname = fullfile(path_work,'img_brain_fillholes.nii');
        spm_write_vol(V3,(segmented_mask_12))

        %segmentar c1 y c2

        %         segmented_mask_12 = double(c1_gm_sm_img) >= 0.75
        % %         segmented_mask_12 = fill_in_holes_inside_brain(segmented_mask_12,n_pasadas);
        %
        %         V3 = img_c1_gm_sm;
        %         V3.fname = fullfile(path_work,'img_c1gm_fillholes.nii');
        %         spm_write_vol(V3,(segmented_mask_12))
        %
        %         segmented_mask_12 = double(c2_wm_sm_img) >= 0.5
        % %         segmented_mask_12 = fill_in_holes_inside_brain(segmented_mask_12,n_pasadas);
        %         V3 = img_c1_gm_sm;
        %         V3.fname = fullfile(path_work,'img_c2wm_fillholes.nii');
        %         spm_write_vol(V3,(segmented_mask_12))



        %

        MNI_flirt_mask = fullfile(path_work,'mni_flirt_mask_fillholes.nii');
        MNI_flirt_mask_mat = fullfile(path_work,'mni_flirt_mask_fillholes.mat');

        % Use mat_BtoC

        cmd = (['flirt -in ' V3.fname ' -ref ' MNI_file ' -out ' MNI_flirt_mask ' -omat ' MNI_flirt_mask_mat ...
            ' -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear']);
        disp(cmd);
        system(cmd);

        %%

        mask_brain_talairach = fullfile(path_work,'mask_brain_mni.nii.gz');
        mask_brain_talairach_bin = fullfile(path_work,'mask_brain_mni_bin.nii.gz');

        system(['fslmaths ' MNI_flirt_mask ' -mas ' outputvol ' ' mask_brain_talairach]);
        system(['fslmaths ' mask_brain_talairach ' -bin ' mask_brain_talairach_bin]);

        perfusion_mni = fullfile(path_work,'perfusion_mni_.nii.gz');
        system(['fslmaths ' mask_brain_talairach_bin ' -mul ' outputvol ' ' perfusion_mni]);

        threshold_mni_c1 = '0.5';
        threshold_mni_c2 = '0.5';

        MNI_c1_flirt_mask = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c1_%s.nii',threshold_mni_c1));
        MNI_c1_flirt_mask_mat = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c1_%s.mat',threshold_mni_c1));

        system(['fslmaths ' c1_gm_sm ' -thr ' threshold_mni_c1 ' -bin ' c11_gm_sm]);

        cmd = (['flirt -in ' c11_gm_sm ' -ref ' MNI_file ' -out ' MNI_c1_flirt_mask ' -omat ' MNI_c1_flirt_mask_mat ...
            ' -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear']);
        disp(cmd);
        system(cmd);

        system(['fslmaths ' MNI_c1_flirt_mask ' -mul ' perfusion_mni ' ' fullfile(path_work,sprintf('c1_gm_sm_mni_%s.nii.gz',threshold_mni_c1))]);

        MNI_c2_flirt_mask = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c2_%s.nii',threshold_mni_c2));
        MNI_c2_flirt_mask_mat = fullfile(path_work,sprintf('mni_flirt_mask_fillholes_c2_%s.mat',threshold_mni_c2));

        system(['fslmaths ' c2_wm_sm ' -thr ' threshold_mni_c2 ' -bin ' c21_wm_sm]);

        cmd = (['flirt -in ' c21_wm_sm ' -ref ' MNI_file ' -out ' MNI_c2_flirt_mask ' -omat ' MNI_c2_flirt_mask_mat ...
            ' -bins 256 -cost corratio -searchrx -90 90 -searchry -90 90 -searchrz -90 90 -dof 12  -interp trilinear']);
        disp(cmd);
        system(cmd);

        system(['fslmaths ' MNI_c2_flirt_mask ' -mul ' perfusion_mni ' ' fullfile(path_work,sprintf('c2_wm_sm_mni_%s.nii.gz',threshold_mni_c2))])

        %%
        rm_files_dir = listdir(fullfile(path_work,sprintf('MF%s*',id_freesurfer)),'files');
        for x = 2 : length(rm_files_dir)
            delete (string(fullfile(path_work,rm_files_dir(x))));
        end

        cmdsys = 'rm -f grot*';
        disp(cmdsys);
        system(cmdsys);

        cd(fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect'));
    end
end

%% Files update

% files = listdir(fullfile('/opt','dora','Dora','ELA'),'dirs');
% files_out = string(ones([length(files) 11]));
% files_name = string(ones(length(files),1));
% for i = 1 : length(files)
%     files_name(i) = files(i);
%     files_into_id = listdir(fullfile('/opt','dora','Dora','ELA',string(files(i))),'dirs');
%     for j = 1 : length(files_into_id)
%         files_out(i,j) = string(files_into_id(j));
%     end
% end
%
% final_files = [files_name files_out];

%
% files1 = listdir(fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect'),'dirs');
% files_out1 = string(ones([length(files1),1]));
% files_name1 = string(ones(length(files1),1));
% for i = 1 : length(files1)
%     files_name1(i) = files1(i)
%     files_into_id1 = listdir(fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect',string(files1(i))),'dirs');
%     for j = 1 : length(files_into_id1)
%         files_out1(i,j) = string(files_into_id1(j));
%     end
% end
%
% final_files1 = [files_name1 files_out1];

% filename = 'files.xlsx';
% writematrix(final_files1,filename,'Sheet',1)


%% Perfusion total

files1 = string(listdir(fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect','sub-*'),'dirs'))';
files_out1 = string(ones([length(files1),4]));
files_name1 = string(ones(length(files1),1));
final_files1=[]

for x = 1 : length(files1)
    files_name1(x) = files1(x);
    path_perfusion = string(fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect',files1(x))); % change for all studies
    more_files = listdir(path_perfusion,'dirs');
    if length(more_files) > 1
        for y = 1 : length(more_files)
            mni_c1_perfusion = spm_vol(char(fullfile(path_perfusion,more_files(y),sprintf('c1_gm_sm_mni_%s.nii.gz',threshold_mni_c1))));
            c1_perfusion = spm_read_vols(mni_c1_perfusion);
            mmnnz = nnz(c1_perfusion)
            cbf_c1_average = sum(c1_perfusion,"all")/mmnnz
            if y == 1
                files_out1(x,2) = cbf_c1_average;
            else
                files_out1(x,5) = cbf_c1_average;
            end
            
            mni_c2_perfusion = spm_vol(char(fullfile(path_perfusion,more_files(y),sprintf('c2_wm_sm_mni_%s.nii.gz',threshold_mni_c2))));
            c2_perfusion = spm_read_vols(mni_c2_perfusion);
            mmnnz = nnz(c2_perfusion);
            cbf_c2_average = sum(c2_perfusion,"all")/mmnnz;
            if y == 1
                files_out1(x,3) = cbf_c2_average;
            else
                files_out1(x,6) = cbf_c2_average;
            end
          
            mni_all_perfusion = spm_vol(char(fullfile(path_perfusion,more_files(y),'perfusion_mni_.nii.gz')));
            all_perfusion = spm_read_vols(mni_all_perfusion);
            mmnnz = nnz(all_perfusion);
            cbf_all_average = sum(all_perfusion,"all")/mmnnz;
            if y == 1
                files_out1(x,1) = cbf_all_average;
            else
                files_out1(x,4) = cbf_all_average;
            end
        end
    else
        mni_c1_perfusion = spm_vol(char(fullfile(path_perfusion,more_files,sprintf('c1_gm_sm_mni_%s.nii.gz',threshold_mni_c1))));
        c1_perfusion = spm_read_vols(mni_c1_perfusion);
        mmnnz = nnz(c1_perfusion);
        cbf_c1_average = sum(c1_perfusion,"all")/mmnnz;
        files_out1(x,2) = cbf_c1_average;
        
        mni_c2_perfusion = spm_vol(char(fullfile(path_perfusion,more_files,sprintf('c2_wm_sm_mni_%s.nii.gz',threshold_mni_c2))));
        c2_perfusion = spm_read_vols(mni_c2_perfusion);
        mmnnz = nnz(c2_perfusion);
        cbf_c2_average = sum(c2_perfusion,"all")/mmnnz;
        files_out1(x,3) = cbf_c2_average;

        mni_all_perfusion = spm_vol(char(fullfile(path_perfusion,more_files,'perfusion_mni_.nii.gz')));
        all_perfusion = spm_read_vols(mni_all_perfusion);
        mmnnz = nnz(all_perfusion);
        cbf_all_average = sum(all_perfusion,"all")/mmnnz;
        files_out1(x,1) = cbf_all_average;
    end
end

final_files1 = [files_name1 files_out1];

%% analiss
clear
clc

path_work = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect');
ids_ctr = listdir(fullfile(path_work,'sub-C*'),'dirs');

aux=1;
for x = 1 : length(ids_ctr)

    controls_asl = char(fullfile(path_work,ids_ctr(x)));
    ids_asl_ctr = listdir(char(fullfile(controls_asl,'wip_pcasl_conn*')),'dirs');
    if length(ids_asl_ctr) >= 1
    ctr_s = string(fullfile(path_work,ids_ctr(x),char(ids_asl_ctr),'perfusion_mni_.nii.gz'));
    gunzip(ctr_s);
    ctr_s = string(fullfile(path_work,ids_ctr(x),char(ids_asl_ctr),'perfusion_mni_.nii,1'));
    ctr(aux) = cellstr(ctr_s);
    aux = aux + 1;
    end
end

ids_pat = listdir(fullfile(path_work,'sub-P*'),'dirs');

aux2 = 1;
aux3 = 1;

for x = 1 : length(ids_pat)
    if length(char(ids_pat(x))) == 8
        patients_asl = char(fullfile(path_work,ids_pat(x)));
        ids_asl_pat = listdir(char(fullfile(patients_asl,'wip_pcasl_conn*')),'dirs');
        if length(ids_asl_pat) >= 1
            pat_s = string(fullfile(path_work,ids_pat(x),char(ids_asl_pat),'perfusion_mni_.nii.gz'));
            gunzip(pat_s);
            pat_s = string(fullfile(path_work,ids_pat(x),char(ids_asl_pat),'perfusion_mni_.nii,1'));
            pat(aux2) = cellstr(pat_s);
            aux2 = aux2 + 1;
        end
    else
        patients_asl2 = char(fullfile(path_work,ids_pat(x)));
        ids_asl_pat2 = listdir(char(fullfile(patients_asl2,'wip_pcasl_conn*')),'dirs');
        if length(ids_asl_pat2) >= 1
            pat2_s = string(fullfile(path_work,ids_pat(x),char(ids_asl_pat2),'perfusion_mni_.nii.gz'));
            gunzip(pat2_s);
            pat2_s = string(fullfile(path_work,ids_pat(x),char(ids_asl_pat2),'perfusion_mni_.nii,1'));
            pat2(aux3) = cellstr(pat2_s);
            aux3 = aux3 + 1;
        end
    end
end

results= fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect','results_all','perfusion','perfusion_conn','C-P');

S = readmatrix('controles_pacientes.txt');
age = S(:,3);

name1 = "Control";
name2 = "Patients";

two_sample_ttest(results, ctr', pat', age, name1, name2)

%%
% 
clear
clc

path_work = fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect');
ids_ctr = listdir(fullfile(path_work,'sub-C*'),'dirs');

aux=1;
for x = 1 : length(ids_ctr)

    controls_asl = char(fullfile(path_work,ids_ctr(x)));
    ids_asl_ctr = listdir(char(fullfile(controls_asl,'wip_pcasl_perf*')),'dirs');
    if length(ids_asl_ctr) >= 1
    ctr_s = string(fullfile(path_work,ids_ctr(x),char(ids_asl_ctr),'perfusion_mni_.nii.gz'));
    gunzip(ctr_s);
    ctr_s = char(fullfile(path_work,ids_ctr(x),char(ids_asl_ctr),'perfusion_mni_.nii,1'));
    ctr(aux) = cellstr(ctr_s);
    aux = aux + 1;
    end
end

ids_pat = listdir(fullfile(path_work,'sub-P*'),'dirs');

aux2 = 1;
aux3 = 1;

for x = 1 : length(ids_pat)
    if length(char(ids_pat(x))) == 8
        patients_asl = char(fullfile(path_work,ids_pat(x)));
        ids_asl_pat = listdir(char(fullfile(patients_asl,'wip_pcasl_perf*')),'dirs');
        if length(ids_asl_pat) >= 1
            pat_s = string(fullfile(path_work,ids_pat(x),char(ids_asl_pat),'perfusion_mni_.nii.gz'));
            gunzip(pat_s);
            pat_s = char(fullfile(path_work,ids_pat(x),char(ids_asl_pat),'perfusion_mni_.nii,1'));
            pat(aux2) = cellstr(pat_s);
            aux2 = aux2 + 1;
        end
    else
        patients_asl2 = char(fullfile(path_work,ids_pat(x)));
        ids_asl_pat2 = listdir(char(fullfile(patients_asl2,'wip_pcasl_perf*')),'dirs');
        if length(ids_asl_pat2) >= 1
            pat2_s = string(fullfile(path_work,ids_pat(x),char(ids_asl_pat2),'perfusion_mni_.nii.gz'));
            gunzip(pat2_s);
            pat2_s = char(fullfile(path_work,ids_pat(x),char(ids_asl_pat2),'perfusion_mni_.nii,1'));
            pat2(aux3) = cellstr(pat2_s);
            aux3 = aux3 + 1;
        end
    end
end

results=  string(fullfile('/opt','dora','Dora','Estudio_ELA','Resultados','ASL_connect','results_all','perfusion','perfusion_conn','C-P'));

S = readmatrix('controles_pacientes.txt');
age = S(:,3);

name1 = "Control"
name2 = "Patients"

two_sample_ttest(results, ctr', pat', age, name1, name2)