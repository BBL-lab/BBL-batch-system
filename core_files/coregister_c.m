function M = coregister_c
% coregister_c
%
% This will make a matrix transform from the
% anatomical to the functional images.
% 
% Version 1.0                   Ken Roberts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

SPMid = spm('FnBanner', mfilename, '1.00');
[Finter,Fgraph,CmdLine] = spm('FnUIsetup', 'Coregistration');

% get the first functional image
firstfunc=expand_path(CCN.first_func);
temp=size(firstfunc);
if temp(2)==1
funcvol = spm_vol_nifti(firstfunc{1});
else
funcvol = spm_vol_nifti(firstfunc);
end

% get the first anatomical image
firstanat=expand_path(CCN.first_anat);
temp=size(firstanat);
if temp(2)==1
anatvol = spm_vol_nifti(firstanat{1});
else
anatvol = spm_vol_nifti(firstanat);
end

% this x has the transformation from the anat
% to the functional.
x = spm_coreg(funcvol, anatvol,CCN.coreg_flags);
M = inv(spm_matrix(x));
MM = spm_get_space(anatvol.fname);
spm_get_space(anatvol.fname, M * MM);


fname = expand_path('[root_dir]/[subject]/anat/coreg.mat');
save(fname, 'M');

% now what to do with matrix?
% VF.mat\spm_matrix(x(:)')*VG.mat, or a mapping from vox(VG) to vox(VF)
% VG.mat            = vox(VG)->mm(VG)
% spm_matrix(x(:)') = mm(VG)->mm(VF)
% VF.mat            = vox(VF)->mm(VF)
 

return;
