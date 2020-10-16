function nothing = fmri_contrasts_b
% fmri_contrasts_b
%
% This will specify contrasts to be calculated.
% 
% Version 1.0                   Ken Roberts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%We moved load spm down to line 26 from line 15 because the program couldn't find the spm.mat file

global CCN;

global SPM;

% get the contrasts
%First, save the current directory we're in now.
CurrentDir=pwd;
%Second, get the directory and name of the contrast_spec_file

%*************DW - Added an expand_path call here so we could get into the subject directory**********
% [filepath name]=fileparts(expand_path(CCN.model.contrast_spec_file));

[contrast_def_path, contrast_def_file] = fileparts(expand_path(CCN.model.contrast_spec_file));
contrast_spm_path = expand_path(CCN.model.model_dir);

%Third, cd to that directory
cd (contrast_def_path)
%Fourth, evaluate the contrast_spec_file
% eval(name);
eval(contrast_def_file);
cd(contrast_spm_path);
%Fifth, load the spm.mat file
load SPM;

% SPM.xCon = {};
% SPM.xCon = struct('name','','STAT','','c','','X0','','iX0','','X1o','','eidf','','Vcon','','Vspm','');

% what is the range of this batch of contrasts? 
% we want to skip all of the built-in F contrasts
% if isfield(SPM, 'xCon') 
%     num_existing_cons = length(SPM.xCon);
% else
%     num_existing_cons = 0;
% end;
% SPM.xCon = struct();

%If the user specifies CCN.startover in the batchscript, 
%allow the option to overwrite all previous contrasts (startover=1) or not (startover=0)
%Default is to add new contrasts without erasing old ones
if (isfield(CCN,'OverwriteContrasts'))
    OverwriteContrasts=CCN.OverwriteContrasts;
    if (OverwriteContrasts==1)%if overwrite of prior contrasts is desired, then leave only the effects of interest F-contrast intact
        num_existing_cons = 1;
        else
    num_existing_cons = 5;
    end
end



num_cons_tocalc = length(contrasts(1).names);

fprintf('Number of already defined regressors: %d \r\n Number of specified contrasts: %d\r\n', ...
    num_existing_cons, num_cons_tocalc);

SPM.xCon = spm_FcUtil('Set', contrasts(1).names{1}, ...
            contrasts(1).types{1}, 'c', transpose(contrasts(1).values{1}), SPM.xX.xKXs);
% put the contrasts defined in contrast_spec file into xCon one at a time
for i = 2:num_cons_tocalc
    try
        SPM.xCon(i) = spm_FcUtil('Set', contrasts(1).names{i}, ...
            contrasts(1).types{i}, 'c', transpose(contrasts(1).values{i}), SPM.xX.xKXs);
    catch
        lasterr
    end;
end;

% choose Ci to be the indices to compute the contrasts for in the xCon struct
% Ci = num_existing_cons+1:(num_existing_cons + num_cons_tocalc);
Ci = 1:length(SPM.xCon);
spm_contrasts(SPM, Ci);

%Finally, come back to the directory we were in before.
%cd (CurrentDir)
