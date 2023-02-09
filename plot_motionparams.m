function plot_motionparams(scaleTra,scaleRot)

if ~exist('scaleTra','var')
    scaleTra = 1;
    scaleRot = 1;    

elseif ~exist('scaleRot','var')
    scaleRot = scaleTra;    
end


curdir = pwd;
txtfiles = listdir(fullfile(curdir, 'rp_*.txt'),'files');
if iscell(txtfiles)
    ;
else
    aux = cell(1);
    aux{1} = txtfiles;
    txtfiles = aux;
end

if isempty(txtfiles)
    fprintf('No rp*.txt files found in %s', curdir);
else
    for ifile = 1:length(txtfiles)
        fid = fopen(fullfile(curdir, txtfiles{ifile}),'r');
        Amotion = (fscanf(fid, '%g %g %g %g %g %g', [6 Inf]))';
        fclose(fid);
        
        hfig=figure;%(ifile);
        set(hfig,'Name', txtfiles{ifile});
        subplot(211),
        plot(Amotion(:,1:3))
        legend({'x','y','z'},'Location','Best')
        ylabel('mm')
        ylim([-1 1]*scaleTra)
        title('Motion parameters')
        subplot(212),
        plot(Amotion(:,4:6) * 180 / pi)
        legend({'pitch','roll','yaw'},'Location','Best')
        %ylabel('rad')
        ylabel('deg')
        ylim([-1 1]*scaleRot)
    end
end