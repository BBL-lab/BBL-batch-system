function nothing = fmri_model_b
% fmri_model_b
%
% This will specify the design of a model, the data associated,
% and estimate the model.
%
% Version 1.0                   Ken Roberts
% Version 1.1                   Jerome Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spm fMRI design
%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

% get functional files, with each run in a separate cell in run_files
% and number of scans for each in n_scans
func_dirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');
run_files = cell(length(func_dirs), 1);
nscan = [];
for i = 1:length(func_dirs)
    run_files{i} = char(expand_path([func_dirs{i} '[file_pattern]']));
    if size(run_files{i},1)==1
    hdr = load_nii_hdr( run_files{i} );
    nscan = [ nscan hdr.dime.dim(5) ];
    else
    nscan(i)=size(run_files{i},1);
    end
end

%Compute the number of timepoints to model for an FIR model
%If not an FIR model, this variable will be changed correctly later by SPM2.
CCN.model.order=round(CCN.model.length/CCN.TR);

% enter in appropriate info
SPM.xY.RT = CCN.TR;
SPM.nscan = nscan;
SPM.xBF.UNITS = CCN.model.units;
SPM.xBF.name = CCN.model.basis;
SPM.xBF.Volterra = CCN.model.volterra;
SPM.xBF.order      = CCN.model.order;
SPM.xBF.length     = CCN.model.length;
SPM.xBF.T=CCN.model.fmri_T;
SPM.xBF.T0=CCN.model.fmri_T0;




% now load the model specification from a model_spec file
fprintf('Loading the model ...\r\n');
[m_path, m_name] = fileparts( expand_path(CCN.model.spec_file) )
addpath(m_path);

if (CCN.model.motion==1)
 [condition, regressors] = feval(m_name);
 
elseif (CCN.model.motion==0)
    
[condition] = feval(m_name);
end

fprintf('Adding regressors ...\r\n');
% for each session
for i = 1:length(nscan)
    fprintf('\t Conditions ... ');
    % for the regressors, all of the information for one run is in conditions(i)


   % For the parametric modulations, we need to keep track of how many we've entered in this session
    ParametricModulationsSoFar=0;

    for j = 1:length(condition(i).names)
        fprintf(' %d', j);
        SPM.Sess(i).U(j).name = condition(i).names(j);
        SPM.Sess(i).U(j).ons = condition(i).onsets{j}; % watch the braces!
        SPM.Sess(i).U(j).dur = condition(i).dur{j};
        SPM.Sess(i).U(j).P.name = 'none';

    
            
      
        %Check how many parametric modulations there are for this trial type    
        NumParamsThisTrialType=condition(i).params_per_trialtype{j};

               

            %Cycle through all the paramtric modulations requested for this trial type
            for k=1:NumParamsThisTrialType

                %Add the appropriate info to the structs below
                SPM.Sess(i).U(j).P(k).name = char(condition(i).parametric_names(ParametricModulationsSoFar + k));
                SPM.Sess(i).U(j).P(k).P    = (condition(i).parametric_values{ParametricModulationsSoFar + k})';
                SPM.Sess(i).U(j).P(k).h    = condition(i).polynomial_expansion{ParametricModulationsSoFar + k};
                SPM.Sess(i).U(j).P(k).i    = condition(i).plots{ParametricModulationsSoFar + k};


            end %k

            %Increment ParametricModulationsSoFar
            ParametricModulationsSoFar=ParametricModulationsSoFar + k;


        
    end;

    
   if (CCN.model.motion==1) 
    fprintf('\r\n\t Covariates ... \r\n');
    % also get covariates (these most often include the regression coefs.)
    SPM.Sess(i).C.name = regressors(i).names;   % [1 x c cell]   names
    SPM.Sess(i).C.C    = regressors(i).values;  % [n x c double] covariates
    
   elseif (CCN.model.motion==0) 
    SPM.Sess(i).C.name = {};   % [1 x c cell]   names
    SPM.Sess(i).C.C    = [];  % [n x c double] covariates
   end
   
end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% spm fMRI data
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('Loading the data ...\r\n');
func_files = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/[file_pattern]');
SPM.xY.P = strvcat(func_files);
SPM.xGX.iGXcalc = CCN.model.global_sc;
SPM.xX.K(1).HParam = CCN.model.hpf;
SPM.xVi.form = CCN.model.ser_corr;

% generate SPM, display the design, and save the printed result

% now fill out the rest of the SPM structure corresponding to the design
% and save the SPM
%-End: Save SPM.mat
%-----------------------------------------------------------------------

% Create model dir if necessary
if exist(expand_path(CCN.model.model_dir), 'dir') ~= 7
    expand_path(CCN.model.model_dir)
    mkdir(expand_path(CCN.model.model_dir))
end

cd(expand_path(CCN.model.model_dir));
fprintf('\t%-32s:\n ','Saving fMRI design');
spm_fmri_spm_ui(SPM);


% Estimate parameters (added 2-20-05: DW)
%===========================================================================
fprintf('\t%-32s:\n ','Estimating betas');
%clear;
spm('FMRI');
load SPM;

if find(ismember(fieldnames(CCN.model), 'thresh_factor'))
  SPM.xM.TH = SPM.xM.TH * CCN.model.thresh_factor;
else
  warning('CCN.model.thresh_factor not specified')
end

SPM = spm_spm(SPM);
