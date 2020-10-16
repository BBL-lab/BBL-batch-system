function aps_2X2anova_within(nn)
%%% Perform a 2X2 within subjects ANOVA using GLM_Flex

%%%
%%% Written by Jerome Prado 


IN.Scans = [];
IN.N_subs  = numel(nn{1});
com = 'IN.Scans = interleave(';
for ii = 1:length(nn)
    com = [com 'nn{' num2str(ii) '},'];
end
com(end:end+1) = ');';
eval(com);

IN.Covar_1 = {};
IN.Within = [2 2];       % Two factors
IN.WithinLabs = {{'Fac1Lev1' 'Fac1Lev2'} {'Fac1Lev1' 'Fac1Lev2'}};
IN.Interactions = {[1 2]};
IN.FactorLabs = {'Factor1' 'Factor2'};
IN.EqualVar = [0 0];       % Do variance corrections
IN.Independent = [0 0]; % Do independence correction

F = CreateDesign(IN); 
RunSPM8ana(F,IN.Scans);


