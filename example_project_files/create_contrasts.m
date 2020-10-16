%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spm contrast specification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% following the type of rules used for the old way of specifying contrasts
% in batch program for SPM99 set up by JPoline
% We simply need to indicate vectors of contrast. Vectors need to be of the
% same size as the number of columns in the design matrix (don't forget the
% run columns at the end)


%---------------------------------------------------------------
% user variables defined here 
%---------------------------------------------------------------



% contrasts.Num_all	=             [	1	1	1	1	1	1	0	 ];  
% contrasts.Num_distance_effect	= [	2.5	1.5	0.5	-0.5	-1.5	-2.5	0	 ];  

                    
contrasts.Num_all	=             [	1	1	1	1	1	1	0	0	0	0	0	0	0	0 ];  
contrasts.Num_distance_effect	= [	2.5	1.5	0.5	-0.5	-1.5	-2.5	0	0	0	0	0	0	0	0 ];  
contrasts.Tran_all	=             [	0   0   0   0   0   0   1	1	1	1	1	1	0	0 ];  
contrasts.Tran_distance_effect	= [	0   0   0   0   0   0   2.5	1.5	0.5	-0.5	-1.5	-2.5	0	0 ];  
                     
                     
contrast_names = fieldnames(contrasts);

contrast_types = {};
contrast_values = {};
for i = 1 : length(contrast_names)
    contrast_types = {contrast_types{:} 'T'};
    contrast_values = {contrast_values{:} contrasts.(contrast_names{i})};
end

contrasts = struct(...
   'names',     {contrast_names}, ...
   'types',     {contrast_types}, ...
   'values',    {contrast_values} ...
);