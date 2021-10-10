%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spm contrast specification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% following the type of rules used for the old way of specifying contrasts
% in batch program for SPM99 set up by JPoline
% We simply need to indicate vectors of contrast. Vectors need to be of the
% same size as the number of columns in the design matrix (don't forget the
% run columns at the end)

%extra contrasts
 
%---------------------------------------------------------------
% user variables defined here 
%---------------------------------------------------------------


% %contrast fraction                    
contrasts.fraction_all_fix	=     [	1 1 -2 0 0 0 0 0 0 0 0 0 0 0 0 0];  
contrasts.fraction_NA_A	=         [	-1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];                      
% contrasts.fraction_NA_fix	=     [	0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 0]; 
% contrasts.fraction_A_fix	=     [	1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 0]; 
% 
% %contrast line
contrasts.line_all_fix	=     [	0 0 0 1 1 -2 0 0 0 0 0 0 0 0 0 0 ];  
contrasts.line_NA_A	=         [	0 0 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 ];                      
% contrasts.line_NA_fix	=     [	0 0 0 0 1 -1 0 0 0 0 0 0 0 0 0 0 ]; 
% contrasts.line_A_fix	=     [	0 0 0 1 0 -1 0 0 0 0 0 0 0 0 0 0 ]; 
% 
% %contrast lineratio
contrasts.lineratio_all_fix	=     [	0 0 0 0 0 0 1 1 -2 0 0 0 0 0 0 0 ];  
contrasts.lineratio_NA_A	=     [	0 0 0 0 0 0 -1 1 0 0 0 0 0 0 0 0 ];                      
% contrasts.lineratio_NA_fix	=     [	0 0 0 0 0 0 0 1 -1 0 0 0 0 0 0 0 ]; 
% contrasts.lineratio_A_fix	=     [	0 0 0 0 0 0 1 0 -1 0 0 0 0 0 0 0 ]; 
% 
% %contrast number
contrasts.number_all_fix	=     [	0 0 0 0 0 0 0 0 0 1 1 -2 0 0 0 0 ];  
contrasts.number_NA_A	=         [	0 0 0 0 0 0 0 0 0 -1 1 0 0 0 0 0 ];                      
% contrasts.number_NA_fix	=     [	0 0 0 0 0 0 0 0 0 0 1 -1 0 0 0 0 ]; 
% contrasts.number_A_fix	=     [	0 0 0 0 0 0 0 0 0 1 0 -1 0 0 0 0 ];
% 
% %interactions

contrasts.fraction_NA_A_vs_lineratio_NA_A = [-1 1 0 0 0 0 1 -1 0 0 0 0 0 0 0 0 ];

contrasts.number_NA_A_vs_line_NA_A	=  [0 0 0 1 -1 0 0 0 0 -1 1 0 0 0 0 0 ];

contrasts.line_NA_A_vs_lineratio_NA_A	=   [0 0 0 -1 1 0 1 -1 0 0 0 0 0 0 0 0 ];

contrasts.fraction_NA_A_vs_number_NA_A	=   [-1 1 0 0 0 0 0 0 0 1 -1 0 0 0 0 0 ];

contrasts.fraction_all_fix_vs_lineratio_all_fix = [1 1 -2 0 0 0 -1 -1 2 0 0 0 0 0 0 0 ];

contrasts.fraction_all_fix_vs_number_all_fix	=   [1 1 -2 0 0 0 0 0 0 -1 -1 2 0 0 0 0 ];

contrasts.number_all_fix_vs_line_all_fix	=  [0 0 0 -1 -1 2  0 0 0 -1 -1 2 0 0 0 0 ];

contrasts.line_all_fix_vs_lineratio_all_fix	=   [0 0 0 1 1 -2 -1 -1 2 0 0 0 0 0 0 0 ];

%RN vs WN
contrasts.rn_all_fix_vs_wn_all_fix = [1 1 -2 -1 -1 2 1 1 -2 -1 -1 2 0 0 0 0 ];


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