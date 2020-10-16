function nothing = smooth_c
% smooth_c
%
% This will normalise in parallel the functional
% and anatomical images.
% 
% Version 1.0                   Ken Roberts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global CCN;

% get functional files
P = char(expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/[file_pattern]'));

% implement the convolution [copied from spm_smooth_ui]
%---------------------------------------------------------------------------
SPMid = spm('FnBanner',mfilename,'1.00');
[Finter,Fgraph,CmdLine] = spm('FnUIsetup','Smooth');
n     = size(P,1);
spm('Pointer','Watch');
spm('FigName','Smooth: working',Finter,CmdLine);
spm_progress_bar('Init',n,'Smoothing','Volumes Complete');

for i = 1:n
    %%% Works with NII
	Q = deblank(P(i,:));
	%[pth,nm,xt,vr] = fileparts(deblank(Q));
    [pth,nm,xt] = fileparts(deblank(Q));
	%U = fullfile(pth,['s' nm xt vr]);
    U = fullfile(pth,['s' nm xt]);
    Q = spm_vol(Q);
    temp=size(Q);
    CCN.timepoints =temp(1);
    for j = 1:CCN.timepoints 
        spm_smooth(Q(j), U, CCN.smooth_kernel);
    end
    %%% Works with IMG
% 	Q = deblank(P(i,:));
% 	[pth,nm,xt,vr] = fileparts(deblank(Q));
%U = fullfile(pth,['s' nm xt vr]);
% 	spm_smooth(Q, U, CCN.smooth_kernel);
	spm_progress_bar('Set',i);
end

%spm_progress_bar('Clear',i);
spm('FigName','Smooth: done',Finter,CmdLine);
spm('Pointer');
