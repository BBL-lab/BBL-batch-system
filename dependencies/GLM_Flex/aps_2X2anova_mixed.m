function aps_2X2anova_mixed(nn)
%%% Perform a 2X2 mixed ANOVA using GLM_Flex

%%%
%%% Written by Jerome Prado 


IN.Scans = [];
com1 = 'IN.Scans1 = interleave(';
for ii = 1:(length(nn))/2
    com1 = [com1 'nn{' num2str(ii) '},'];
end
com1(end:end+1) = ');';
eval(com1);

com2 = 'IN.Scans2 = interleave(';
for ii = 3:(length(nn))
    com2 = [com2 'nn{' num2str(ii) '},'];
end
com2(end:end+1) = ');';
eval(com2);

IN.Covar_1 = {};
IN.Scans = [IN.Scans1;IN.Scans2];



IN.N_subs  = [size(nn{1},2) size(nn{3},2)];


IN.Between = [2];  
IN.BetweenLabs = {{'Group1', 'Group2'}};
IN.Within = [2];
IN.WithinLabs = {{'Condition1' 'Condition2'}};
IN.FactorLabs = {'Factor1' 'Factor2'};
IN.Interactions = {[1 2]};
IN.EqualVar = [0 0];
IN.Independent = [1 0];


F = CreateDesign(IN); 
RunSPM8ana(F,IN.Scans);


