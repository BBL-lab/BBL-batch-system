function nothing = ROI_c
% ROI_c
%
% This script averages betas within a given ROI and writes a text
% file with the mean value for each subject/condition. The file is saved in
% the same directory as the ROI file.
% 
% Version 1.0                   Jerome Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

ncontrasts=length(CCN.ROI.contrasts);
contrasts=CCN.ROI.contrasts;
SPM_path=expand_path(CCN.model.model_dir);
cd(SPM_path);
load SPM

if isstr(CCN.ROI.contrasts)
    if strcmp(CCN.ROI.contrasts, 'all')
        contrasts = [1 : size(SPM.xCon, 2)];
    else
        error('Wrong string in the CCN.ROI.contrasts');
    end
else
    contrasts = CCN.ROI.contrasts;      % contrast images - change according to conditions
end

n_con = length(contrasts);          % number of contrasts

for i=contrasts %-
    conimagename(i)= {SPM.xCon(i).name};
end
    

clear SPM

ROI_path=expand_path(CCN.ROI.dir);
cd(ROI_path);

% Opens file for writing (or create if it does not already exist).
if exist([ROI_path '/ROI_analysis_' CCN.ROI.file '.tsv'],'file')==0
    fid = fopen(['ROI_analysis_' CCN.ROI.file '.tsv'], 'a+') ;                        
    fprintf(fid, 'subject\t');
    fprintf(fid, strjoin(conimagename,'\t'));
    fprintf(fid, '\n') ;
else
    fid = fopen(['ROI_analysis_' CCN.ROI.file '.tsv'], 'a+') ;                         
end

for con = 1 : n_con
         
    
    roi_path = [expand_path(CCN.ROI.dir) '/' CCN.ROI.file '.nii']; % ROI path
    contrast_path = [expand_path(CCN.model.model_dir) filesep sprintf('con_%04d.nii', contrasts(con))]; % contrast path

    
     if exist(roi_path) ~= 2
        disp(sprintf('Missing ROI file'));
        break
    end   
    
    
 % clear variables   
  t_mask=[];
  V_mask=[];
  tmp_mask=[];
  t_mask_contrast_select=[];
  V_mask_contrast_select=[];
  img_mask_contrast_select=[];
  t_mask_contrast=[];
  V_mask_contrast=[];
  img_mask_contrast=[];
  A=[];
  B=[];
  x=0;
  i=0;
  Voxels=[];
  XYZ_mask=[];
  
 
 %load mask of the ROI
   t_mask = strvcat(roi_path);
   V_mask = spm_vol(t_mask);
   img_mask = spm_read_vols(V_mask);
   tmp_mask = find(img_mask(:) > 0);
   size(tmp_mask);
   
  
 % apply this mask to the contrast image
  
   t_mask_contrast = strvcat(contrast_path);
   V_mask_contrast = spm_vol(t_mask_contrast);
   img_mask_contrast = spm_read_vols(V_mask_contrast);
   Voxels = img_mask_contrast(tmp_mask);
   
% average the beta values
   average(con)=nanmean(Voxels);
   
end
   
  

    
    fprintf(fid, CCN.subject) ;
    fprintf(fid, '\t %g', average) ;

    fprintf(fid, '\n') ;


fclose(fid) ;  
end





