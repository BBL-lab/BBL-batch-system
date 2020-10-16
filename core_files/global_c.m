function nothing = global_c
% global_c
%
% This will run art_global.m from the ArtRepair toolbox
% 
% Version 1.0                   Jerome Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

% get functional files, with each run in a separate cell in P
func_dirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');
P = cell(length(func_dirs), 1);
nscan = [];
realign_files = expand_path(['[root_dir]/[subject]/func/preprocessing/[run_pattern]/' CCN.model.rp_name]);
for i = 1:length(func_dirs)
    P{i} = char(expand_path([func_dirs{i} '[file_pattern]']));
    art_global(P{i}, realign_files{i}, 4, 1);
end;




