function aps_2X2anova_between(nn)
%%% Perform a 2X2 between subjects ANOVA using GLM_Flex

%%%
%%% Written by Jerome Prado 


IN.N_subs  = [];
IN.Scans = [];
for ii = 1:length(nn)
    IN.N_subs = [IN.N_subs numel(nn{ii})];
    IN.Scans = [IN.Scans, nn{ii}];
end
IN.Covar_1 = {};
IN.Between = [2 2];       % Two factor
IN.BetweenLabs = {{'Fac1Lev1' 'Fac1Lev2'} {'Fac1Lev1' 'Fac1Lev2'}};
IN.Interactions = {[1 2]};
IN.FactorLabs = {'Factor1' 'Factor2'};
IN.EqualVar = [0 0];
IN.Independent = [1 1];


F = CreateDesign(IN);
RunSPM8ana(F,IN.Scans);



