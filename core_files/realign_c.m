function nothing = realign_c
% realign_c
%
% This will realign the functional images.
% 
% Version 1.0                   Ken Roberts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

SPMid = spm('FnBanner', mfilename, '1.00');
[Finter,Fgraph,CmdLine] = spm('FnUIsetup', 'Realignment');

% get functional files, with each run in a separate cell in P
func_dirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');
P = cell(length(func_dirs), 1);
for i = 1:length(func_dirs)
    P{i} = char(expand_path([func_dirs{i} '[file_pattern]']));
end

spm_realign(P, CCN.realign_flags);

