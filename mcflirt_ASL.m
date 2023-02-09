function mcflirt_ASL(session_dir)

%MV
%% Find bold run directories
d = listdir(fullfile(session_dir,'ASL'),'dirs');
if isempty(d) %MV
    d = listdir(fullfile(session_dir,'asl/*'),'dirs');
end
nruns = length(d);

if nruns == 0
    fprintf('No ASL directories found in %s.\n',session_dir);
    return;
else
    fprintf('The following ASL directories were found in %s:\n',session_dir);
    d
end

%% Run MCFLIRT
for r = 1:nruns    
    fprintf('\nMotion correction for run %s:\n',d{r});    
    infile  = 'raw_f.nii.gz';
    %Find or create raw_f file
    if ~exist(fullfile(session_dir,d{r},infile))
        niifiles = listdir(fullfile(session_dir,d{r},'f*.nii'),'files');
        if ~isempty(niifiles)
            fprintf('raw_f file not found in %s. Creating from individual .nii files\n', d{r});
            listvols = '';
            for ifile = 1:length(niifiles)
                listvols = [listvols niifiles{ifile} ' ' ];
            end        
            savecurpath=pwd;
            cd(fullfile(session_dir,d{r}));
            commandc = ['fslmerge -t raw_f ' listvols];
            disp(commandc);
            system(commandc);
            cd(savecurpath);
        else
            fprintf('WARNING. Dir %s appears to be empty. Skipping.\n',d{r});
            continue;
        end
    end
    savecurpath=pwd;
    cd(fullfile(session_dir,d{r}));
    outfile = 'raw_f_mcf.nii.gz';
    prevdir = dir([outfile '.mat*']);
    if ~isempty(prevdir)
        for ifile = 1:length(prevdir)
            rmdir(prevdir(ifile).name,'s');
        end
    end
    
    refvol  = 0;
    commandc = ['mcflirt -in ' infile ' -out ' outfile ' -refvol ' num2str(refvol) ' -mats -plots -rmsrel -rmsabs'];
    disp(commandc);
    system(commandc);
    if isdir('mc')
        rmdir('mc','s');
    end
    mkdir('mc');
%     commandc = ['mkdir -p mc'];
%     disp(commandc);
%     system(commandc);
    commandc = ['mv -f raw_f_mcf.nii.gz_abs.rms raw_f_mcf.nii.gz_abs_mean.rms raw_f_mcf.nii.gz_rel.rms raw_f_mcf.nii.gz_rel_mean.rms raw_f_mcf.nii.gz mc'];
    disp(commandc);
    system(commandc);
    movefile('raw_f_mcf.nii.gz.par', fullfile('mc','motionparams.par'),'f');
    movefile('raw_f_mcf.nii.gz.mat', fullfile('mc','MATS'),'f');
    cd(savecurpath);
end


%% Read MC parameters & filter them
figct = 0;
for r = 1:nruns
    if strfind(d{r},'M0')
        fprintf('Run %02d - %s: M0 scan. No MC filtering.\n',r,d{r});
        continue;
    else
        fprintf('Run %02d - %s: L-C scan. Performing MC filtering.\n',r,d{r});
    end
    %Read parfile for rotations
    parfile = fullfile(session_dir,d{r},'mc','motionparams.par');
    fid = fopen(parfile,'r');
    Amotion = (fscanf(fid, '%g %g %g %g %g %g\r\n',[6 inf]))';
    fclose(fid);
    mc_rotations = Amotion(:,1:3);
    %Read MAT files for translations
    mcf_dir = fullfile(session_dir, d{r},'mc','MATS');
    matfiles = listdir(fullfile(mcf_dir,'MAT*'),'files');
    n_scans = length(matfiles);
    mc_translations = zeros(n_scans,3);
    for iscan = 1:n_scans
        fid=fopen(fullfile(mcf_dir,matfiles{iscan}),'r');
        MAT = fscanf(fid,'%g %g %g %g\r\n',[4 inf])';
        fclose(fid);
        mc_translations(iscan,1:3) = (MAT(1:3,4))';
    end
    mcparam = [mc_rotations mc_translations];
    
    %
    figct = figct+1;
    hmc = figure(figct);
    set(figure(hmc),'Name',sprintf('MC %s',d{r}));
    subplot(211),plot(mcparam(:,1:3)),subplot(212),plot(mcparam(:,4:6))
    %
    
    %regression
    mcparam_reg = zeros(size(mcparam));    
    n_param = size(mcparam,2);
    regressor = zeros(n_scans,1);
    regressor(2:2:end,1) = 1;

    for i_param = 1:n_param
        y = mcparam(:,i_param);
        stats = regstats(y,regressor,'linear',{'r','beta'});
        mcparam_reg(:,i_param) = stats.r + stats.beta(1);
    end
    
    %
    figure(hmc); hold on,
    subplot(211),hold on,plot(mcparam_reg(:,1:3),'--','LineWidth',2.5),subplot(212),hold on,plot(mcparam_reg(:,4:6),'--','LineWidth',2.5)
    %
    
    %Create new MAT files with regressed mc parameters
    mcf_dir_reg = fullfile(session_dir, d{r},'mc','MATS_reg');
    if isdir(mcf_dir_reg)
       fprintf('Directory %s already exists. Deleting.\n',mcf_dir_reg);
       rmdir(mcf_dir_reg,'s'); 
    end
    mkdir(mcf_dir_reg);
    for iscan = 1:n_scans        
        xalpha = mcparam_reg(iscan,1);
        yalpha = mcparam_reg(iscan,2);
        zalpha = mcparam_reg(iscan,3);
        tx     = mcparam_reg(iscan,4) ;
        ty     = mcparam_reg(iscan,5) ;
        tz     = mcparam_reg(iscan,6) ;
        Rx = [  1             0           0           0 ; 
                0         cos(xalpha)  sin(xalpha)    0 ; 
                0        -sin(xalpha)  cos(xalpha)    0 ;
                0             0           0           1];
            
        Ry = [ cos(yalpha)    0       -sin(yalpha)    0 ; 
                0             1           0           0 ; 
               sin(yalpha)    0        cos(yalpha)    0 ;
                0             0           0           1];
            
        Rz = [ cos(zalpha) sin(zalpha)    0           0 ; 
              -sin(zalpha) cos(zalpha)    0           0 ; 
                0             0           1           0 ;
                0             0           0           1];

        T = [0 0 0 tx;
             0 0 0 ty;
             0 0 0 tz;
             0 0 0 0];

        M = Rx * Ry * Rz + T;
        fid=fopen(fullfile(mcf_dir_reg,matfiles{iscan}),'w');
        fprintf(fid,'%1.6f %1.6f %1.6f %1.6f\r\n',M');
        fclose(fid);

    end   

    parfile_reg = fullfile(session_dir,d{r},'mc','motionparams_reg.par');
    fid = fopen(parfile_reg,'w');
    fprintf(fid,' % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f\r\n',mcparam_reg');
    fclose(fid);
        
    %Apply warps
    savecurpath = pwd;
    cd(fullfile(session_dir,d{r}));
    commandc = ['fslsplit raw_f grot'];
    system(commandc);
    listvols = '';
    for iscan = 1:n_scans
        commandc = sprintf('applywarp -i grot%04d -o grot%04d --premat=mc/MATS_reg/MAT_%04d -r grot0000 --rel',iscan-1, iscan-1, iscan-1);
        disp(commandc);
        system(commandc);
        listvols = [listvols ' ' sprintf('grot%04d', iscan-1)];
    end
    commandc = ['fslmerge -t raw_f_mcf_reg ' listvols];
    disp(commandc);
    system(commandc);
    commandc = 'rm -f grot*';
    disp(commandc);
    system(commandc);
    commandc = ['mv -f raw_f_mcf_reg.nii.gz mc'];
    disp(commandc);
    system(commandc);
    cd(savecurpath);
    close(hmc);

end

end
