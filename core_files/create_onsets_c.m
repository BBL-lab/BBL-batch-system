function nothing = create_onsets_c
% createonsets_c
%
% This will create mat files with vectors of onset.
% 
% Version 1.0                   Jérôme Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

% get functional files, with each run in a separate cell in P
func_files = expand_path(CCN.functional_files);
P=char(func_files);

for i = 1:size(P,1)

        file=P(i,:);
        file=file(~isspace(file));
        [p,f] = fileparts(file);
        A=size(f);
        B=A(2);
        f=[f(1,1:B-4)];
        create_onsets([f 'events.tsv'],p);
end


