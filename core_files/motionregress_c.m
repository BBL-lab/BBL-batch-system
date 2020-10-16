function nothing = motionregress_c
% slice_c
%
% This will run motionregress.m from the ArtRepair toolbox
% 
% Version 1.0                   Jerome Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

% get functional files, with each run in a separate cell in P
func_dirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');
for i = 1:length(func_dirs)
    art_motionregress( func_dirs{i}, '^srasub-.*\.nii$', func_dirs{i}, '^asub-.*\.nii$');
end;




