function nothing = normalise_c
% normalise_c
%
% This will normalise in parallel the functional
% and anatomical images.
% 
% Version 1.0                   Ken Roberts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

SPMid = spm('FnBanner',mfilename,'1.00');
[Finter,Fgraph,CmdLine] = spm('FnUIsetup','Normalisation');

% make anatomical mask for normalisation
% (this should be a box in the space of the template that corresponds to
% the volume acquired in the anatomical, see spm_normalise_mask)
%VG = spm_vol_nifti( fullfile(spm('Dir'), 'templates', 'T1.nii') );
%VF = spm_vol_nifti(expand_path(CCN.first_anat));
% VG = spm_vol( fullfile(spm('Dir'), 'templates', 'T1.nii') );
% VF = spm_vol(expand_path(CCN.first_anat));
%matname = [expand_path(CCN.anatomical_dirs), 'mask.img'];
%spm_normalise_mask(VG, VF, matname, CCN.normalise_est_flags);

% now actually do the normalisation, using the mask
%VGW = matname;
%matname = [expand_path(CCN.anatomical_dirs), 'norm_sn.mat'];
%spm_normalise(VG, VF, matname, VGW, '', CCN.normalise_est_flags);

% write the normalized images for the anatomical
%m = load(matname, '-mat');
%flags = CCN.normalise_wr_flags;
%flags.vox = flags.vox .* [0.25 0.25 1];      % compared to functionals, increase resolution in plane
%spm_write_sn(expand_path(CCN.first_anat), m, flags);

firstfunc=expand_path(CCN.first_func);
temp1=size(firstfunc);
firstanat=expand_path(CCN.first_anat);
temp2=size(firstanat);


if (CCN.norm==1)

% get the template, and the first functional image
VG = spm_vol_nifti( fullfile(spm('Dir'), 'templates', 'EPI.nii') );
if temp1(2)==1
VF = spm_vol_nifti(firstfunc{1});
else
   VF = spm_vol_nifti(firstfunc);
end
fdirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');

% estimate the functional normalisation parameters
matname = [fdirs{1}, 'norm_sn.mat'];
spm_normalise(VG, VF, matname, '', '', CCN.normalise_est_flags);

% get functional files for normalisation
P = char(expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/[file_pattern]' ));
m = load(matname, '-mat');
spm_write_sn(P, m, CCN.normalise_wr_flags);

elseif  (CCN.norm==2)
    
    % get the template, and the anatomical image
VG = spm_vol_nifti(fullfile(spm('Dir'), 'templates', 'T1.nii') );
if temp2(2)==1
VF = spm_vol_nifti(firstanat{1});
else
 VF = spm_vol_nifti(firstanat);
end
fdirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');

% estimate the functional normalisation parameters
matname = [expand_path(CCN.anatomical_dirs), 'norm_sn.mat'];
spm_normalise(VG, VF, matname, '', '', CCN.normalise_est_flags);

% get functional files for normalisation
P = char(expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/[file_pattern]' ));
m = load(matname, '-mat');
spm_write_sn(P, m, CCN.normalise_wr_flags);

elseif  (CCN.norm==3)
  if temp2(2)==1  
VF = spm_vol_nifti(firstanat{1});
  else
 VF = spm_vol_nifti(firstanat);
  end
     estopts.regtype = 'mni';		% turn on affine
  out = spm_preproc(VF,estopts);

  [matname,isn]   = spm_prep2sn(out);

  writeopts.biascor = 1;
  writeopts.GM  = [0 0 1];	% assume GM(2) means unmod
  writeopts.WM  = [0 0 1];
  writeopts.CSF = [0 0 0];
  writeopts.cleanup = 0;
  spm_preproc_write(matname,writeopts);

  save(sprintf('%s_seg_sn.mat',spm_str_manip(VF.fname,'sd')),'matname')
  save(sprintf('%s_seg_inv_sn.mat',spm_str_manip(VF.fname,'sd')),'isn')

  %[pth,nam,ext,num] = spm_fileparts(VF);
  %VF = fullfile(pth,['m' nam ext]);
   
  % get functional files for normalisation
P = char(expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/[file_pattern]' ));
spm_write_sn(P, matname, CCN.normalise_wr_flags);

elseif  (CCN.norm==4)

%specify parameters for segmentation of the anatomical
job.channel.vols=firstanat;
job.channel.biasreg=1.0000e-03;
job.channel.biasfwhm=60;
job.channel.write=[0 1];
job.tissue(1).tpm=fullfile(spm('Dir'), 'tpm', 'TPM.nii,1');
job.tissue(2).tpm=fullfile(spm('Dir'), 'tpm', 'TPM.nii,2');
job.tissue(3).tpm=fullfile(spm('Dir'), 'tpm', 'TPM.nii,3');
job.tissue(4).tpm=fullfile(spm('Dir'), 'tpm', 'TPM.nii,4');
job.tissue(5).tpm=fullfile(spm('Dir'), 'tpm', 'TPM.nii,5');
job.tissue(6).tpm=fullfile(spm('Dir'), 'tpm', 'TPM.nii,6');

job.tissue(1).ngaus=1;
job.tissue(2).ngaus=1;
job.tissue(3).ngaus=2;
job.tissue(4).ngaus=3;
job.tissue(5).ngaus=4;
job.tissue(6).ngaus=2;

job.tissue(1).native=[1 0];
job.tissue(2).native=[1 0];
job.tissue(3).native=[1 0];
job.tissue(4).native=[1 0];
job.tissue(5).native=[1 0];
job.tissue(6).native=[0 0];

job.tissue(1).warped=[0 0];
job.tissue(2).warped=[0 0];
job.tissue(3).warped=[0 0];
job.tissue(4).warped=[0 0];
job.tissue(5).warped=[0 0];
job.tissue(6).warped=[0 0];
    
job.warp.mrf= 1;
job.warp.cleanup= 1;
job.warp.reg= [0 1.0000e-03 0.5000 0.0500 0.2000];
job.warp.affreg= 'mni';
job.warp.fwhm= 0;
job.warp. samp= 3;
job.warp.write= [0 1];

% segmentation of the anatomical
spm_preproc_run(job);
clear job;

% specify parameters for normalization using deformation image
defanat=expand_path(CCN.def_anat);
func_dirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');

%4Dimages
if temp1(2)==1

P = cell(length(func_dirs), 1);
for i = 1:length(func_dirs)
    P{i} = char(expand_path([func_dirs{i} '[file_pattern]']));
end;
%3Dimages
else
   P = char(expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/[file_pattern]' ));
   P=cellstr(P);
end
job.subj.def=defanat;
job.subj.resample=P;
job.woptions.bb=CCN.normalise_wr_flags.bb;
job.woptions.vox=CCN.normalise_wr_flags.vox;
job.woptions.interp=CCN.normalise_wr_flags.interp;
job.woptions.prefix='w';

% run normalization
spm_run_norm(job);
clear job;


end



