%-----------------------------------------------------------------------
% Job saved on 08-Feb-2022 22:18:38 by cfg_util (rev $Rev: 7345 $)
% spm SPM - SPM12 (7771)
% cfg_basicio BasicIO - Unknown
%-----------------------------------------------------------------------
% function two_sample_ttest(dir_out,files_group1,files_group2,age,name1,name2)
% 
% clear matlabbatch
% matlabbatch{1}.spm.stats.factorial_design.dir = cellstr(dir_out);
% 
% matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = cellstr(files_group1);
% 
% matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = cellstr(files_group2);
% 
% matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
% matlabbatch{1}.spm.stats.factorial_design.cov(1).c = age;
% matlabbatch{1}.spm.stats.factorial_design.cov(1).cname = "Age";
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCFI = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov(1).iCC = 1;
% matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
% matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
% matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
% matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = [name1 "-" name2];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = [name2 "-" name1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% 
% matlabbatch{3}.spm.stats.con.delete = 0;
% 
% spm('defaults', 'FMRI');
% spm_jobman('run',matlabbatch);
% 
% end

% matlabbatch{1}.spm.stats.factorial_design.dir = {'/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/results_all/perfusion/perfusion_conn/C-P'};
% matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = {
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C001/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C002/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C003/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C004/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C005/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C006/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C007/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C008/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C009/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C010/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C011/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C012/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C013/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C014/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C015/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C016/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C017/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C018/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C019/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C020/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C021/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C022/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C023/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C025/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C026/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C027/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C029/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C030/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C031/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C032/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-C033/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
% };
% matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = {
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P001/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1' 
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P002/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1' 
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P003/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1' 
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P004/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P005/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P006/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P007/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P008/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P009/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P010/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P011/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P012/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P013/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P014/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P015/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P016/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P017/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P018/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P019/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P020/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P021/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P022/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P023/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P024/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P025/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P026/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P027/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P029/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P030/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P031/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P032/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%     '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P033/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
%                                                            };
% matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
% matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
% matlabbatch{1}.spm.stats.factorial_design.cov.c = [48
%     56
%     54
%     52
%     62
%     64
%     60
%     59
%     71
%     66
%     64
%     59
%     43
%     74
%     47
%     44
%     72
%     59
%     51
%     54
%     55
%     63
%     52
%     79
%     71
%     65
%     67
%     45
%     74
%     74
%     79
%     48
%     55
%     57
%     53
%     67
%     67
%     66
%     75
%     74
%     63
%     60
%     61
%     45
%     75
%     69
%     74
%     76
%     76
%     49
%     55
%     59
%     64
%     54
%     62
%     85
%     83
%     65
%     68
%     47
%     68
%     75
%     68];
% matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'Age';
% matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
% matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
% matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
% matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
% matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
% matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
% matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
% matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
% matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
% matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'controles vs pacientes';
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
% matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'pacientes - controles';
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
% matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
% matlabbatch{3}.spm.stats.con.delete = 0;

% spm('defaults', 'FMRI');
% spm_jobman('run',matlabbatch);


%%Paired t-test

matlabbatch{1}.spm.stats.factorial_design.dir = {'/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/results_all/perfusion/perfusion_conn/P0-P6'};
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(1).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P001/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P001-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(2).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P002/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P002-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(3).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P003/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P003-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(4).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P004/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P004-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(5).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P005/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P005-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(6).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P006/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P006-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(7).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P007/wip_pcasl_conn_L1500_P1500_1seg/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P007-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(8).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P009/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P009-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(9).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P010/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P010-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(10).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P011/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P011-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(11).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P013/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P013-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(12).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P014/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P014-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(13).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P016/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P016-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(14).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P017/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P017-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(15).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P018/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P018-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(16).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P020/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P020-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(17).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P021/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P021-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(18).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P022/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P022-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(19).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P023/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P023-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(20).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P024/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P024-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(21).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P025/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P025-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(22).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P026/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P026-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(23).scans = {
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P029/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  '/opt/dora/Dora/Estudio_ELA/Resultados/ASL_connect/sub-P029-2/wip_pcasl_conn_L1300_P1800_1seg_p2c2/perfusion_mni_.nii,1'
                                                                  };
matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
%%
matlabbatch{1}.spm.stats.factorial_design.cov.c = [48
55
57
53
67
67
66
74
63
60
45
75
74
76
76
55
59
64
54
62
85
83
68
48
55
57
53
67
67
66
74
63
60
45
75
74
76
76
55
59
64
54
62
85
83
68];
%%
matlabbatch{1}.spm.stats.factorial_design.cov.cname = 'age';
matlabbatch{1}.spm.stats.factorial_design.cov.iCFI = 1;
matlabbatch{1}.spm.stats.factorial_design.cov.iCC = 1;
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('Model estimation: SPM.mat File', substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Pacientes0-Paciente6';
matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 -1];
matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Pacientes6-Pacientes0';
matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [-1 1];
matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
matlabbatch{3}.spm.stats.con.delete = 0;

spm('defaults', 'FMRI');
spm_jobman('run',matlabbatch);