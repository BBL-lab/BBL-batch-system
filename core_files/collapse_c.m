function nothing = collapse_c
% collapse_c
%
% This will convert 3D nii images into 4D nii images and put them back in
% the main func folder
% 
% Version 2.0                   Jerome Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;
func_dirs = expand_path(CCN.functional_dirs);

% get functional files, with each run in a separate cell in P
func_dirs_preprocess = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');
P = cell(length(func_dirs_preprocess), 1);
nscan = [];
for i = 1:length(func_dirs_preprocess)
    P{i} = char(expand_path([func_dirs_preprocess{i} '[file_pattern]']));
    A=P{i};
    B=size(A);
    C=B(2);
    string=[A(1,1:C-9)];
    [p,f] = fileparts(string);
    cd(p);
    collapse_nii_scan([f '*'],f);
    sourcefile=[string '.nii'];
    destinationfile=[func_dirs [f '.nii']];
    copyfile(sourcefile,destinationfile);
    delete(sourcefile);

end




