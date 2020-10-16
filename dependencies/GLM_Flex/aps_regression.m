function aps_regression(nn,covar1,covar2,covar3,covar4,covar5,covar6)
%%% Perform a simple regression using GLM_Flex.

%%%
%%% Written by Jerome Prado 





IN.N_subs = [numel(nn)];
IN.Between = [1];
IN.EqualVar = [1];
IN.Independent = [1];
IN.Centering = 1; % mean centering of the covariates (1=yes, 5=no)
IN.Intercept = 1; % intercept (1=yes, 0=no)
IN.Covar_1 = {covar1'};
IN.Covar_2 = {covar2'};
IN.Covar_3 = {covar3'};
IN.Covar_4 = {covar4'};
IN.Covar_5 = {covar5'};
IN.Covar_6 = {covar6'};
if ~isempty(IN.Covar_1{1}) && isempty(IN.Covar_2{1});
IN.CovarLabs = {'Covariate1'};
IN.Covar = {covar1'};
end
if ~isempty(IN.Covar_2{1}) && isempty(IN.Covar_3{1});
IN.CovarLabs = {'Covariate1' 'Covariate2'};
IN.Covar = {covar1' covar2'};
end
if ~isempty(IN.Covar_3{1}) && isempty(IN.Covar_4{1});
IN.CovarLabs = {'Covariate1' 'Covariate2' 'Covariate3'};
IN.Covar = {covar1' covar2' covar3'};
end
if ~isempty(IN.Covar_4{1}) && isempty(IN.Covar_5{1});
IN.CovarLabs = {'Covariate1' 'Covariate2' 'Covariate3' 'Covariate4'};
IN.Covar = {covar1' covar2' covar3' covar4'};
end
if ~isempty(IN.Covar_5{1}) && isempty(IN.Covar_6{1});
IN.CovarLabs = {'Covariate1' 'Covariate2' 'Covariate3' 'Covariate4' 'Covariate5'};
IN.Covar = {covar1' covar2' covar3' covar4' covar5'};
end
if ~isempty(IN.Covar_6{1});
IN.CovarLabs = {'Covariate1' 'Covariate2' 'Covariate3' 'Covariate4' 'Covariate5' 'Covariate6'};
IN.Covar = {covar1' covar2' covar3' covar4' covar5' covar6'};
end

IN.Scans = nn;
F = CreateDesign(IN);

RunSPM8ana(F,IN.Scans);

