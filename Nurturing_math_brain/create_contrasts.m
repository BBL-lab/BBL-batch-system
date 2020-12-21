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

nruns=6;

contrasts.NAvsA_Digits =  [-1 1 0 -1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 repmat([0], 1, nruns)] ;                
contrasts.NAvsR_Digits =  [0 1 -1 0 1 -1 0 0 0 0 0 0 0 0 0 0 0 0 repmat([0], 1, nruns)] ; 
contrasts.AvsR_Digits =   [1 0 -1 1 0 -1 0 0 0 0 0 0 0 0 0 0 0 0 repmat([0], 1, nruns)] ; 
contrasts.NAvsA_Dots =    [0 0 0 0 0 0 -1 1 0 -1 1 0 0 0 0 0 0 0 repmat([0], 1, nruns)] ;                
contrasts.NAvsR_Dots =    [0 0 0 0 0 0 0 1 -1 0 1 -1 0 0 0 0 0 0 repmat([0], 1, nruns)] ; 
contrasts.AvsR_Dots =     [0 0 0 0 0 0 1 0 -1 1 0 -1 0 0 0 0 0 0 repmat([0], 1, nruns)] ;
contrasts.NAvsA_Words =   [0 0 0 0 0 0 0 0 0 0 0 0 -1 1 0 -1 1 0 repmat([0], 1, nruns)] ;                
contrasts.NAvsR_Words =   [0 0 0 0 0 0 0 0 0 0 0 0 0 1 -1 0 1 -1 repmat([0], 1, nruns)] ; 
contrasts.AvsR_Words =    [0 0 0 0 0 0 0 0 0 0 0 0 1 0 -1 1 0 -1 repmat([0], 1, nruns)] ;                     




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