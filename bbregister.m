function bbregister(subject_name,filefor_reg,bbreg_out_file,acq_type)

% Performs within-subject, cross-modal registration to a subject's 
%   corresponding Freesurfer anatomical file 
%   ($SUBJECTS_DIR/<subject_name>/mri/orig.mgz) using Freesurfer's 
%   bbregister, which uses a boundary-based cost function.
%
% Usage:
%   bbregister(subject_name,filefor_reg,bbreg_out_file,acq_type)
%
% Defaults:
%   bbreg_out_file = 'bbreg.dat'; % in the same directory as filefor_reg
%   acq_type = 't2'; % options are 't1' or 't2' ('bold' and 'dti' are also valid, but are the same as 't2')
%
% Written by Andrew S Bock Dec 2014

%% Set default parameters
% get file path
[file_path] = fileparts(filefor_reg);
% set defaults
if ~exist('subject_name','var')
    error('"subject_name" not defined');% must define a freesurfer subject name
end
if ~exist('filefor_reg','var')
    error('"filefor_reg" not defined');% must define a file for registration
end
if ~exist('bbreg_out_file','var')
    bbreg_out_file = fullfile(file_path,'bbreg.dat');
end
if ~exist('acq_type','var')
    acq_type = 't2'; % options are 't1','t2' ('bold' and 'dti' are also valid, but are the same as 't2')
end

%% Run bbregister 
system(['bbregister --s T1-' subject_name ' --mov ' filefor_reg ...
    ' --reg ' bbreg_out_file ' --init-fsl --' acq_type]);
%% Check the registration
mincost = load([bbreg_out_file '.mincost']);
mincost = mincost(1);
disp(['The min cost value of registration for ' filefor_reg ':'])
disp(num2str(mincost));
%% If registration is poor (mincost > 0.6), manually inspect and update the registration
if mincost > 0.9 || isnan(mincost)
    system(['tkregister2 --mov ' filefor_reg ' --reg ' bbreg_out_file ' --surf']);
    system(['tkregisterfv --mov ' filefor_reg ' --reg ' bbreg_out_file ' --surf']);
acq_type = 'bold';
    system(['bbregister --s ' subject_name ' --mov ' filefor_reg ...
        ' --reg ' bbreg_out_file ' --init-reg ' ...
        bbreg_out_file ' --' acq_type]);
    mincost = load([bbreg_out_file '.mincost']);
    mincost = mincost(1);
    disp(['The min cost value of registration for ' filefor_reg ':'])
    disp(num2str(mincost));
    if mincost > 0.6
        input('Registration is still poor, proceed anyway?');
    end
end

end