function nothing = slice_c
% slice_c
%
% This will slice-time correct the functional images.
% 
% Version 1.0                   Ken Roberts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

% get functional files, with each run in a separate cell in P
func_dirs = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');
P = cell(length(func_dirs), 1);
for i = 1:length(func_dirs)
    P{i} = char(expand_path([func_dirs{i} '[file_pattern]']));
end

% set sliceorder - this is the order the slices are acquired in.
% choices are 'asc' = 1, 'desc' = 2, 'interl' = 3, or specify with the order of slices.
% Note: in the vector, 1 corresponds to the first slice in the file
% and will not depend on the orientation of the files at all.
if (CCN.seq==1)
    
    seq = [1:CCN.nslices];
    
elseif (CCN.seq==2)
    
    seq = [CCN.nslices:-1:1];
    
elseif (CCN.seq==3)
    
    seq=[1:2:CCN.nslices 2:2:CCN.nslices];
    
 elseif (CCN.seq==4)
    
    seq=[2:2:CCN.nslices 1:2:CCN.nslices];
        
end

% this is the reference slice- all of the other slices will be time-shifted
% to match this one.  Best to pick a slice in the middle, but only if the 
% onset times in modelling are adjusted appropriately.  Easiest to pick #1.
ref = 1;

% timing -see SPM mailing list 006545 or
% http://www.jiscmail.ac.uk/cgi-bin/wa.exe?A2=ind0106&L=spm&P=R16123&I=-1

% TA = 1.2054; % time of acquisition, = TR*(nslices-1)/nslices) in the case of continuous acq.
% timing(1) = TA / (nslices -1);
% timing(2) = TR-TA
timing = [CCN.TR/CCN.nslices CCN.TR/CCN.nslices];

% call it
spm_slice_timing(P, seq, ref, timing);
