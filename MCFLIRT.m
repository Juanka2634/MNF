function mcflirt(direction,in,vol_out,ref)

cd(direction)
refvol = ref;
if ~exist(fullfile(direction,'mcflirt'))
    cmdsys = ['mcflirt -in ' in ' -out ' vol_out ' -refvol ' num2str(refvol) ' -mats -plots -rmsrel -rmsabs'];
    disp(cmdsys);
    system(cmdsys);
    mkdir('mcflirt');
    cmdsys = ['mv -f asl_merge_mcf.nii.gz_abs.rms asl_merge_mcf.nii.gz_abs_mean.rms asl_merge_mcf.nii.gz_rel.rms asl_merge_mcf.nii.gz_rel_mean.rms asl_merge_mcf.nii.gz mcflirt'];
    disp(cmdsys);
    system(cmdsys);
    movefile('asl_merge_mcf.nii.gz.par', fullfile('mcflirt','motionparams.par'));
    movefile('asl_merge_mcf.nii.gz.mat', fullfile('mcflirt','MATS'));
else
    warning("mcflirt already exist in this path")
    warning("fsl mcflirt operation no performed")
end
%Read parameters

par_files = fullfile('mcflirt','motionparams.par');
fid = fopen(par_files,'r');
Amotion = (fscanf(fid, '%g %g %g %g %g %g\r\n',[6 inf])');
fclose(fid);
rotations_mcf = Amotion(:,1:3);

dir_mcflirt=fullfile('mcflirt','MATS');
files_mat=dir(fullfile(dir_mcflirt,'MAT*'));
n_scans = length(files_mat);
translations_mcf = zeros(n_scans,3);

for iscan = 1:n_scans
    fid=fopen(fullfile(dir_mcflirt,files_mat(iscan).name),'r');
    MAT=fscanf(fid,'%g %g %g %g\r\n',[4 inf])';
    fclose(fid);
    translations_mcf(iscan,1:3) = (MAT(1:3,4))';
end

%% Plotear
    fig = figure;
    set(fig,'Name','Before MC');
    subplot(211),
    plot(translations_mcf)
    legend({'x','y','z'}, 'Location','Best')
    ylabel('mm')
    title('Motion parameters')
    subplot(212)
    plot(rotations_mcf*180/pi)
    legend({'pitch','roll','yaw'},'Location','Best')
    ylabel('deg')
    
    mcparam = [rotations_mcf translations_mcf];
    
    parfile_reg = fullfile('mcflirt','motionparams_conn.par');
    fid = fopen(parfile_reg,'w');
    fprintf(fid,' % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f\r\n',mcparam(1:2:end,:)');
    fclose(fid);

     %% Regresion
    
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

     fig = figure;
    set(fig,'Name','After MC');
    subplot(211),
    plot(mcparam_reg(:,4:6))
    legend({'x','y','z'}, 'Location','Best')
    ylabel('mm')
    title('Motion parameters')
    subplot(212)
    rot = mcparam_reg(:,1:3);
    plot(rot*180/pi);
    legend({'pitch','roll','yaw'},'Location','Best')
    ylabel('deg')
    
    %Create new MAT files with regressed mc parameters
    mcf_dir_reg = fullfile('mcflirt','MATS_reg');
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
        fid=fopen(fullfile(mcf_dir_reg,files_mat(iscan).name),'w');
        fprintf(fid,'%1.6f %1.6f %1.6f %1.6f\r\n',M');
        fclose(fid);

    end   

    parfile_reg = fullfile('mcflirt','motionparams_reg.par');
    fid = fopen(parfile_reg,'w');
    fprintf(fid,' % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f\r\n',mcparam_reg');
    fclose(fid);
    
    parfile_reg = fullfile('mcflirt','motionparams_reg_conn.par');
    fid = fopen(parfile_reg,'w');
    fprintf(fid,' % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f % 1.9f\r\n',mcparam_reg(1:2:end,:)');
    fclose(fid);
    

end