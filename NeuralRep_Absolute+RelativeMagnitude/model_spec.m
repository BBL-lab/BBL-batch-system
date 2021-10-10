function [conditions, regressors] = model_spec

% model specification

% the structures works like this:
% each run has different trial types and onsets.  For run 1 make:

% factors(1).cond(1).name = 'left_cue'; % the name of the condition
% factors(1).cond(1).ons = [1 4 25 97]; % the onsets in units
% factors(1).cond(1).dur = 0; % the duration of stimuli (zero for events)

% factors(1).cond(2).name = 'right_cue'; 
% factors(1).cond(2).ons = [29 44 65 127];
% factors(1).cond(2).dur = 0;

% and following this pattern soforth.  The covariates should be arranged
% similarly (as shown below), with the additional constraint that the value of the
% covariate must be given for each scan.  So, for the second run, the
% covariates may look like:

% factors(2).cov(1).name = 'x_trans';
% factors(2).cov(1).values = [0.01, 0.04, 0.01, 0.02, 0.015, etc... ];

global CCN;


%%%%%%%%%%%% DOT NOT EDIT THIS PART %%%%%%%%%%%%

cd([CCN.root_dir '/' CCN.subject '/func']);
files = dir('*.tsv');

for i = 1:length(files)
 
T{i} = readtable(files(i).name,'FileType','text'); 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%-------------------------------------------
% Conditions
%-------------------------------------------
%Notes: Names               : Names of your trial types as string variables
       %Onsets              : Onset times for each trial type.
       %Dur                 : Duration of each onset of the condition 
                            % (enter 0 for brief events and # of secs or scans for blocked design)
       %params_per_trialtype: Number of parametric modulations for a trial type.
       %parametric_names    : Names of parametric modulations for each trial type.
       %parametric_values   : Parametric values for a trial type (usually one for each onset of a trial type)
       %polynomial_expansion: How do you think brain activity varies with your parametric modulator?
                            %1=Linear (usual), 2=Quadratic, 3=Cubic, etc.
       %plots               :For labeling parametric modulators when you view the design matrix.
                           %Basically useless.
       
%task-fraction_run-01
conditions(1) = struct( ...
    'names',   {{'adapt', 'noadapt', 'fix'}}, ...
    'onsets',  {{T{1}(strcmp(T{1}.condition, 'adapt'),1), T{1}(strcmp(T{1}.condition, 'noadapt'),1), T{1}(strcmp(T{1}.condition, 'fix'),1) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );   


%task-line_run-01
conditions(2) = struct( ...
    'names',   {{'adapt', 'noadapt', 'fix'}}, ...
    'onsets',  {{T{2}(strcmp(T{2}.condition, 'adapt'),1), T{2}(strcmp(T{2}.condition, 'noadapt'),1), T{2}(strcmp(T{2}.condition, 'fix'),1) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   ); 

%task-lineratio_run-01
conditions(3) = struct( ...
    'names',   {{'adapt', 'noadapt', 'fix'}}, ...
    'onsets',  {{T{3}(strcmp(T{3}.condition, 'adapt'),1), T{3}(strcmp(T{3}.condition, 'noadapt'),1), T{3}(strcmp(T{3}.condition, 'fix'),1) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );  

%task-number_run-01
conditions(4) = struct( ...
    'names',   {{'adapt', 'noadapt', 'fix'}}, ...
    'onsets',  {{T{4}(strcmp(T{4}.condition, 'adapt'),1), T{4}(strcmp(T{4}.condition, 'noadapt'),1), T{4}(strcmp(T{4}.condition, 'fix'),1) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );



%%%%%%%%%%%% DOT NOT EDIT BELOW THIS LINE %%%%%%%%%%%%

for i = 1:length(conditions)
    for j = 1:length(conditions(1).onsets)
        conditions(i).onsets{j} = conditions(i).onsets{j}{:,1};
        conditions(i).onsets{j} = conditions(i).onsets{j}.';
    end
end
    
    
%-------------------------------------------
% motion parameters
%-------------------------------------------

realign_files = expand_path([CCN.functional_dirs CCN.model.rp_name]);
for i = 1:size(realign_files, 2)
    mot = load(realign_files{i});
    regressors(i) = struct( ...
        'names',   {{'x trans', 'y trans', 'z trans', 'pitch', 'roll', 'yaw'}}, ...
        'values',  mot);
end

return;