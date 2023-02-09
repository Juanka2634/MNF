%-----------------------------------------------------------------------
% Job saved on 21-Oct-2021 12:49:43 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
function dcmnii_job(in,out,dcm)

ch_chstr = convertStringsToChars(in+dcm);
matlabbatch{1}.spm.util.import.dicom.data = {ch_chstr};
matlabbatch{1}.spm.util.import.dicom.root = 'flat';
matlabbatch{1}.spm.util.import.dicom.outdir = {convertStringsToChars(out)};
matlabbatch{1}.spm.util.import.dicom.protfilter = '.*';
matlabbatch{1}.spm.util.import.dicom.convopts.format = 'nii';
matlabbatch{1}.spm.util.import.dicom.convopts.meta = 0;
matlabbatch{1}.spm.util.import.dicom.convopts.icedims = 0;

spm('defaults', 'FMRI');
spm_jobman('run', matlabbatch);

end
