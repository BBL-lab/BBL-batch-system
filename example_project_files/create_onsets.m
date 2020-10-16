%  Create a mat file containing onset vectors for a given tab delimited
%  spreadsheet
%
%  Usage: create_onsets(filename, path)
%
%  
%
%  - Version 1          Jérôme Prado 
%

%%%%%%%%%%%%%%%%%%%%% DO NOT EDIT THIS SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%
function create_onsets(filename, path)

%load the file
cd(path);
behav_dat = importdata(fullfile(filename));


%initiate a bunch of counters
a=1; b=1; c=1; d=1; e=1; f=1; g=1; h=1; i=1; j=1; k=1; l=1; m=1; n=1; o=1; p=1; q=1; r=1; s=1; t=1; u=1; v=1; w=1; x=1; y=1; z=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%% EDIT THIS SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%


if regexp(filename,'task-Num_run-01')>0 % You should have a loop for each of your run/Task. The name of the run/Task needs to be indicated here

 for line=1:length(behav_dat.data) % this should not be edited
        
    if behav_dat.data(line,5)==1 && behav_dat.data(line,8)==1 % This should be customized depending on your file. You need to indicate the line to select in your table (e.g., trials of a certain type that are correctly reponded)
             ons_task_Num_run_01_dist1(a) = behav_dat.data(line,10); % Here you should give a specific name to this vector depending on the condition/run/task
             a=a+1;                                                  % This shoudl end with a counter that is incremented
    end
    
    if behav_dat.data(line,5)==2 && behav_dat.data(line,8)==1
             ons_task_Num_run_01_dist2(b) = behav_dat.data(line,10);
             b=b+1;
    end
                    	
    if behav_dat.data(line,5)==3 && behav_dat.data(line,8)==1
             ons_task_Num_run_01_dist3(c) = behav_dat.data(line,10);
             c=c+1;
    end             
             
    if behav_dat.data(line,5)==4 && behav_dat.data(line,8)==1
             ons_task_Num_run_01_dist4(d) = behav_dat.data(line,10);
             d=d+1;
    end               
             
    if behav_dat.data(line,5)==5 && behav_dat.data(line,8)==1
             ons_task_Num_run_01_dist5(e) = behav_dat.data(line,10);
             e=e+1;
    end               
             
    if behav_dat.data(line,5)==6 && behav_dat.data(line,8)==1
             ons_task_Num_run_01_dist6(f) = behav_dat.data(line,10);
             f=f+1;
    end
    
 end
 
end


if regexp(filename,'task-Tran_run-01')>0  % same thing for the next run/task
    
 for line=1:length(behav_dat.data)

    if behav_dat.data(line,3)==1 && behav_dat.data(line,5)==1
             ons_task_Tran_run_01_dist1(a) = behav_dat.data(line,7);
             a=a+1;
    end
    
    if behav_dat.data(line,3)==2 && behav_dat.data(line,5)==1
             ons_task_Tran_run_01_dist2(b) = behav_dat.data(line,7);
             b=b+1;
    end
                    	
    if behav_dat.data(line,3)==3 && behav_dat.data(line,5)==1
             ons_task_Tran_run_01_dist3(c) = behav_dat.data(line,7);
             c=c+1;
    end             
             
    if behav_dat.data(line,3)==4 && behav_dat.data(line,5)==1
             ons_task_Tran_run_01_dist4(d) = behav_dat.data(line,7);
             d=d+1;
    end               
             
    if behav_dat.data(line,3)==5 && behav_dat.data(line,5)==1
             ons_task_Tran_run_01_dist5(e) = behav_dat.data(line,7);
             e=e+1;
    end               
             
    if behav_dat.data(line,3)==6 && behav_dat.data(line,5)==1
             ons_task_Tran_run_01_dist6(f) = behav_dat.data(line,7);
             f=f+1;
    end
 end
end
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

%%%%%%%%%%%%%%%%%%%%% DO NOT EDIT THIS SECTION %%%%%%%%%%%%%%%%%%%%%%%%%%

 
 A=size(filename);
 B=A(2);
 newfilename=[filename(1,1:B-4)];
       
    save(newfilename,'ons_*');


return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%