function nothing = uncompress_c
% uncompress_c
%
% This will replace the original compressed nii.gz files into nii files.
% 
% Version 1.0                   Jérôme Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

func_dirs = expand_path(CCN.functional_dirs);
cd(func_dirs);
if isfile('*.gz')
    gunzip('*.gz');
    delete('*.gz')
end



anat_dirs = expand_path(CCN.anatomical_dirs);
cd(anat_dirs);
if isfile('*.gz')
gunzip('*.gz');
delete('*.gz')
end

cd(CCN.root_dir);


