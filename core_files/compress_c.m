function nothing = compress_c
% compress_c
%
% This will replace the original nii files into nii.gz files.
% 
% Version 1.0                   Jérôme Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

% get functional files, with each run in a separate cell in P
func_files = expand_path(CCN.functional_files);
anat_files = expand_path(CCN.anatomical_files);

for i = 1:size(func_files,2)
    
    gzip(func_files{i});
    delete(func_files{i});
    
end

for i = 1:size(anat_files,2)
    
    gzip(anat_files{i});
    delete(anat_files{i});

end

cd(CCN.root_dir);


