function nothing = clean_c
% clean_c
%
% This will remove all preprocessing files.
% 
% Version 2.0                   Jérôme Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

func_dirs = expand_path(CCN.functional_dirs);
anat_dirs = expand_path(CCN.anatomical_dirs);

cd(func_dirs);
  
delete sub*.mat;

if exist([pwd '/preprocessing'],'dir')>0
   rmdir([pwd '/preprocessing'],'s');
end
  
cd(anat_dirs);

delete c*.nii;
delete y_*.nii;
delete m*.nii;
delete *.mat;

cd ..;

if exist([pwd '/analysis'],'dir')>0
   rmdir([pwd '/analysis'],'s');
end

cd(CCN.root_dir);


