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

%-------------------------------------------
% Onsets of each condition for each run
%-------------------------------------------
P = expand_path('[root_dir]/[subject]/func/sub*.mat');

for i = 1:length(P)
    load(P{i});
end

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
       
%task-Num_run-01
conditions(1) = struct( ...
    'names',   {{'dist1', 'dist2', 'dist3', 'dist4', 'dist5', 'dist6'}}, ...
    'onsets',  {{[ons_task_Num_run_01_dist1], [ons_task_Num_run_01_dist2], [ons_task_Num_run_01_dist3], [ons_task_Num_run_01_dist4], [ons_task_Num_run_01_dist5], [ons_task_Num_run_01_dist6]}}, ...
    'dur', {{0, 0, 0, 0, 0, 0}}, ...   
    'params_per_trialtype', {{[0], [0], [0], [0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );  

%task-Tran_run-01
conditions(2) = struct( ...
    'names',   {{'dist1', 'dist2', 'dist3', 'dist4', 'dist5', 'dist6'}}, ...
    'onsets',  {{[ons_task_Tran_run_01_dist1], [ons_task_Tran_run_01_dist2], [ons_task_Tran_run_01_dist3], [ons_task_Tran_run_01_dist4], [ons_task_Tran_run_01_dist5], [ons_task_Tran_run_01_dist6]}}, ...
    'dur', {{0, 0, 0, 0, 0, 0}}, ...   
    'params_per_trialtype', {{[0], [0], [0], [0], [0], [0]}}, ...   
    'parametric_names', {{}}, ...  
    'parametric_values', {{}}, ...  
    'polynomial_expansion', {{}}, ...  
    'plots', {{}}   );  



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