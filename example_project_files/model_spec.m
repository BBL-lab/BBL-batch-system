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
       
%task-Digits_run-01
conditions(1) = struct( ...
    'names',   {{'A', 'NA', 'R'}}, ...
    'onsets',  {{T{1}(T{1}.CONDITION==1,2), T{1}(T{1}.CONDITION==2,2), T{1}(T{1}.CONDITION==3,2) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );   

%task-Digits_run-02
conditions(2) = struct( ...
    'names',   {{'A', 'NA', 'R'}}, ...
    'onsets',  {{T{2}(T{2}.CONDITION==1,2), T{2}(T{2}.CONDITION==2,2), T{2}(T{2}.CONDITION==3,2) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   ); 

%task-Dots_run-01
conditions(3) = struct( ...
    'names',   {{'A', 'NA', 'R'}}, ...
    'onsets',  {{T{3}(T{3}.CONDITION==1,2), T{3}(T{3}.CONDITION==2,2), T{3}(T{3}.CONDITION==3,2) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );  

%task-Dots_run-01
conditions(4) = struct( ...
    'names',   {{'A', 'NA', 'R'}}, ...
    'onsets',  {{T{4}(T{4}.CONDITION==1,2), T{4}(T{4}.CONDITION==2,2), T{4}(T{4}.CONDITION==3,2) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );


%task-Words_run-01
conditions(5) = struct( ...
    'names',   {{'A', 'NA', 'R'}}, ...
    'onsets',  {{T{5}(T{5}.CONDITION==1,2), T{5}(T{5}.CONDITION==2,2), T{5}(T{5}.CONDITION==3,2) }}, ...
    'dur', {{[9.6],[9.6],[9.6]}}, ...
    'params_per_trialtype', {{[0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );

%task-Words_run-01
conditions(6) = struct( ...
    'names',   {{'A', 'NA', 'R'}}, ...
    'onsets',  {{T{6}(T{6}.CONDITION==1,2), T{6}(T{6}.CONDITION==2,2), T{6}(T{6}.CONDITION==3,2) }}, ...
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