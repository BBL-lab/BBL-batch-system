function nothing = motion_report_c
% motion_report_c
%
% This script pulls rp files from each subject and writes a text
% file with the mean value for each dim,ension (x, y, z, pitch, roll, yaw).
% It also reports the number of volumes that were repaired by Artrepair for
% each run/subject 
% 
% Version 1.0                   Jerome Prado
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global CCN;
% where to find the rp file
rpfolder = expand_path('[root_dir]/[subject]/func/preprocessing/[run_pattern]/');
%fprintf(['Extracting motion from ' CCN.subject]);   

func_files = expand_path(CCN.functional_files);

cd(CCN.root_dir);

% Opens file for writing (or create if it does not already exist).
if exist([CCN.root_dir '/motion_report.tsv'],'file')==0
    fid = fopen('motion_report.tsv', 'a+') ;                         
    fprintf(fid, ['Run\t X(mm)\t Y(mm)\t Z(mm)\t pitch(deg)\t roll(deg)\t yaw(deg)\t repaired_scans(percent)']);
    fprintf(fid, '\n') ;
else
    fid = fopen('motion_report.tsv', 'a+') ;                         
end


for i = 1:length(rpfolder)
    
    % get the name of the rpfile
     rpPath = [rpfolder{i} 'rp_*.txt']; 
     rpfile = dir(rpPath);

    % load rp file
    a = load([rpfile.folder '/' rpfile.name]);

    % average X
    X=nanmean(a(:,1));

    % average Y
    Y=nanmean(a(:,2));

    % average Z
    Z=nanmean(a(:,3));

    % average pitch
    pitch=nanmean(a(:,4));

    % average roll
    roll=nanmean(a(:,5));

    % average yaw
    yaw=nanmean(a(:,6));
    
    %load art_repair file
    artPath = [rpfolder{i} 'art_repaired.txt']; 
    artfile = dir(artPath);
    b = load([artfile.folder '/' artfile.name]);
    
    %get number of repaired scans
    repaired_scans=length(b);
    
    %get number of total scans
    hdr = load_nii_hdr(func_files{i});
    nscans=[];
    nscans = [ nscans hdr.dime.dim(5) ];
    
    %get percent of repaired scans
    percent_repaired_scans = (repaired_scans/nscans).*100;
 
    % summarize in a vector
    parameters= [X, Y, Z, pitch, roll, yaw, percent_repaired_scans];    

    cd(CCN.root_dir);
    
    [p,f] = fileparts(func_files{i});
    
    fprintf(fid, '%s\t %.3f\t %.3f\t %.3f\t %.3f\t %.3f\t %.3f\t %.3f', f, X,Y,Z,pitch,roll,yaw,percent_repaired_scans) ;
    fprintf(fid, '\n') ;

end

fclose(fid) ;  





