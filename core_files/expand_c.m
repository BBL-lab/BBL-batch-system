function nothing = expand_c
% expand_c
%
% This will convert 4D nii images into 3D nii images and place them in a
% new subfolder called "preprocessing". Each run will be placed in a
% separate directory (named for the the run)
% 
% Version 1.0                   Jerome Prado
% Version 1.1                   Chris McNorgan
% Version 2                   Jerome Prado
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;

% get functional files, with each run in a separate cell in P
func_dirs = expand_path(CCN.functional_dirs);
P = char(expand_path([func_dirs '[file_pattern]']));
nscan = [];
prepross_dir=[func_dirs 'preprocessing'];

%Create preprocessing directory if it does not exist
if ~exist(prepross_dir)
    mkdir(prepross_dir);
end

for i = 1:size(P,1)

        sourcefile=P(i,:);
        sourcefile=sourcefile(~isspace(sourcefile));
        [p,f,e] = fileparts(sourcefile);
        run_dir=[prepross_dir '/' f];
        mkdir(run_dir);
        destinationfile=[run_dir '/' f e];
        copyfile(sourcefile,destinationfile);
        hdr = load_nii_hdr(destinationfile);
        nscan = [ nscan hdr.dime.dim(5) ];
        expand_nii_scan_b(destinationfile,[1:nscan(i)]);
        delete(destinationfile);


end;




