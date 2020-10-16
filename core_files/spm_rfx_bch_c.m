function nothing = spm_rfx_bch_c

global CCN;




n_sub = length(CCN.all_subjects);   % number of subjects
root_dir = expand_path(CCN.rfx.rfx_dir);
n_path=expand_path(CCN.model.model_dir);
cd(n_path);
load SPM

if isstr(CCN.rfx.contrasts)
    if strcmp(CCN.rfx.contrasts, 'all')
        contrasts = [1 : size(SPM.xCon, 2)];
    else
        error('Wrong string in the CCN.rfx.contrasts');
    end
else
    contrasts = CCN.rfx.contrasts;      % contrast images - change according to conditions
end

n_con = length(contrasts);          % number of contrasts

for i=contrasts %-
    conimagename(i)= {SPM.xCon(i).name};
end
    

clear SPM


%Create the working directory if it does not exist
if ~exist(root_dir)
    mkdir(root_dir);
end


nsph_corr = 0;              % non-spericity correction, 0 = yes , 1 = no

cd(root_dir);
% for con = 1:length(conimagename)
for con = 1:n_con
    %     foldname=sprintf('04d_%s', con, conimagename{con});
    foldname=sprintf('%04d_%s', contrasts(con), conimagename{contrasts(con)});
    %Create a subdirectory named for the contrast being performed if one does not already exist
    if (exist([pwd filesep foldname])~=7) %if the directory does not exist
        
        mkdir(foldname); %create it
        
        cd(foldname); %cd inside
        
    else %if this subdirectory does exist
        cd(foldname); %cd into it
        delete *.* %delete all the files
    end
    
    
    % get image files names
    P={};
    for s = 1:n_sub
        
        %Changed from %05d to %s in line below (DW)
        CCN.subject = sprintf('%s', CCN.all_subjects{s});
        
        
        P{s} = [expand_path(CCN.model.model_dir) filesep sprintf('con_%04d.img', contrasts(con))];
    end

 if exist(P{1})==0
     P={};
    for s = 1:n_sub
        
        %Changed from %05d to %s in line below (DW)
        CCN.subject = sprintf('%s', CCN.all_subjects{s});
        
        
        P{s} = [expand_path(CCN.model.model_dir) filesep sprintf('con_%04d.nii', contrasts(con))];
    end
 end
       
    
    if (CCN.rfx.ttest==1)  % one-sample t-test
    aps_onesampt(P);
    
    load SPM
    
    % do the contrasts
    c1               = conimagename{contrasts(con)};
    c2               = strcat(conimagename{contrasts(con)},'_reverse');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',1,SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',-1,SPM.xX.xKXs);
    spm_contrasts(SPM);
    
    %cd back up to the root directory
    cd (root_dir);
    end
    
    if (CCN.rfx.ttest==2)  % two-sample t-test
    
    % indices of images - needed for creation of design matrix (assignment of
    % images)
    
    A=CCN.rfx.groups==1;
    B=CCN.rfx.groups==2;
    
    P1=P(A);
    P2=P(B);
    aps_twosampt(P1,P2);
    
    load SPM
    
    % do the contrasts
    c1               = strcat(conimagename{contrasts(con)},'_group1>group2');
    c2               = strcat(conimagename{contrasts(con)},'_group2>group1');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[1 -1]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[-1 1]',SPM.xX.xKXs);
    spm_contrasts(SPM);
    
    %cd back up to the root directory
    cd (root_dir);
    
    end
    
    if (CCN.rfx.ttest==3)  %paired t-test
    
    % indices of images - needed for creation of design matrix (assignment of
    % images)
    
    A=CCN.rfx.groups==1;
    B=CCN.rfx.groups==2;
    
    P1=P(A);
    P2=P(B);
    aps_pairedt(P1,P2);
    
    load SPM
    
    % do the contrasts
    c1               = strcat(conimagename{contrasts(con)},'_session1>session2');
    c2               = strcat(conimagename{contrasts(con)},'_session2>session1');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[1 -1 zeros(1,size(P1,2))]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[-1 1 zeros(1,size(P1,2))]',SPM.xX.xKXs);
    spm_contrasts(SPM);
    
    %cd back up to the root directory
    cd (root_dir);
    
    end
    
    if (CCN.rfx.ttest==4)  % one-way between subjects ANOVA
    


    % Get the number of levels 

    number_of_levels = max(CCN.rfx.groups);
    
    % indices of images - needed for creation of design matrix (assignment of
    % images) (up to 6 levels)

    for ii = 1:number_of_levels
        A(ii,:)=CCN.rfx.groups==ii;
    end
    

    if number_of_levels==2
        P={P(A(1,:)) P(A(2,:))};
    end
    
    if number_of_levels==3
        P={P(A(1,:)) P(A(2,:)) P(A(3,:))};
    end
    
    if number_of_levels==4
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))};
    end
    
    if number_of_levels==5
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))  P(A(5,:))};
    end   
    
    if number_of_levels==6
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))  P(A(5,:))  P(A(6,:))};
    end
    
    
    aps_onewayanova_between(P);
    load SPM
    
    % do the contrasts
    c1               = strcat(conimagename{contrasts(con)},'_positive main effect');
    c2               = strcat(conimagename{contrasts(con)},'_negative main effect');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    
    if number_of_levels==2
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1 1]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1 -1]',SPM.xX.xKXs);
    end   

    if number_of_levels==3
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1 0 1]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1 0 -1]',SPM.xX.xKXs);
    end
    
    if number_of_levels==4
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1.5 -0.5 0.5 1.5]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1.5 0.5 -0.5 -1.5]',SPM.xX.xKXs);
    end
    
    if number_of_levels==5
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-2 -1 0 1 2]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[2 1 0 -1 -2]',SPM.xX.xKXs);
    end   
    
    if number_of_levels==6
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-2.5 -1.5 -0.5 0.5 1.5 2.5]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[2.5 1.5 0.5 -0.5 -1.5 -2.5]',SPM.xX.xKXs);
    end
    
    spm_contrasts(SPM);
   
    
    %cd back up to the root directory
    cd (root_dir);
    
    end
    
    if (CCN.rfx.ttest==5)  % one-way repeated measures ANOVA
    


    % Get the number of levels 

    number_of_levels = max(CCN.rfx.groups);
    
    % indices of images - needed for creation of design matrix (assignment of
    % images) (up to 6 levels)

    for ii = 1:number_of_levels
        A(ii,:)=CCN.rfx.groups==ii;
    end
    

    if number_of_levels==2
        P={P(A(1,:)) P(A(2,:))};
    end
    
    if number_of_levels==3
        P={P(A(1,:)) P(A(2,:)) P(A(3,:))};
    end
    
    if number_of_levels==4
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))};
    end
    
    if number_of_levels==5
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))  P(A(5,:))};
    end   
    
    if number_of_levels==6
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))  P(A(5,:))  P(A(6,:))};
    end
    
    
    aps_onewayanova_repeated(P);
    load SPM
    
    % do the contrasts
    c1               = strcat(conimagename{contrasts(con)},'_positive main effect');
    c2               = strcat(conimagename{contrasts(con)},'_negative main effect');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    
    if number_of_levels==2
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1 1 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1 -1 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    end   

    if number_of_levels==3
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1 0 1 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1 0 -1 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    end
    
    if number_of_levels==4
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1.5 -0.5 0.5 1.5 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1.5 0.5 -0.5 -1.5 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    end
    
    if number_of_levels==5
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-2 -1 0 1 2 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[2 1 0 -1 -2 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    end   
    
    if number_of_levels==6
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-2.5 -1.5 -0.5 0.5 1.5 2.5 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[2.5 1.5 0.5 -0.5 -1.5 -2.5 zeros(1,size(P{1},2))]',SPM.xX.xKXs);
    end
    
    spm_contrasts(SPM);
   
    
    %cd back up to the root directory
    cd (root_dir);
    
    end 
  
     if (CCN.rfx.ttest==6)  % 2X2 between subjects ANOVA
    
    
    % indices of images - needed for creation of design matrix (assignment of
    % images) 
        

        A(1,:)=CCN.rfx.groups_1==1;
        A(2,:)=CCN.rfx.groups_1==2;
        A(3,:)=CCN.rfx.groups_2==1;
        A(4,:)=CCN.rfx.groups_2==2;
    
    
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))};
    

    
    aps_2X2anova_between(P);
    load SPM
    
    % do the contrasts
    c1               = strcat(conimagename{contrasts(con)},'_positive main effect Factor 1');
    c2               = strcat(conimagename{contrasts(con)},'_negative main effect Factor 1');
    c3               = strcat(conimagename{contrasts(con)},'_positive main effect Factor 2');
    c4               = strcat(conimagename{contrasts(con)},'_negative main effect Factor 2');
    c5               = strcat(conimagename{contrasts(con)},'_positive interaction Factor 1 X Factor 2');
    c6               = strcat(conimagename{contrasts(con)},'_negative interaction Factor 1 X Factor 2');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1 1 0 0 -0.5 -0.5 0.5 0.5]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1 -1 0 0 0.5 0.5 -0.5 -0.5]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[0 0 -1 1 -0.5 0.5 -0.5 0.5]',SPM.xX.xKXs);
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[0 0 1 -1 0.5 -0.5 0.5 -0.5]',SPM.xX.xKXs);  
    SPM.xCon(5)   = spm_FcUtil('Set',c5,'T','c',[0 0 0 0 -1 1 1 -1]',SPM.xX.xKXs);
    SPM.xCon(6)   = spm_FcUtil('Set',c6,'T','c',[0 0 0 0 1 -1 -1 1]',SPM.xX.xKXs);
    
    
    spm_contrasts(SPM);
   
    
    %cd back up to the root directory
    cd (root_dir);
    
     end   
     
     if (CCN.rfx.ttest==7)  % 2X2 within ANOVA
    
    
    % indices of images - needed for creation of design matrix (assignment of
    % images) 
        

        A(1,:)=CCN.rfx.groups_1==1;
        A(2,:)=CCN.rfx.groups_1==2;
        A(3,:)=CCN.rfx.groups_2==1;
        A(4,:)=CCN.rfx.groups_2==2;
    
    
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))};
    

    
    aps_2X2anova_within(P);
    load SPM
    
    % do the contrasts
    c1               = strcat(conimagename{contrasts(con)},'_positive main effect Factor 1');
    c2               = strcat(conimagename{contrasts(con)},'_negative main effect Factor 1');
    c3               = strcat(conimagename{contrasts(con)},'_positive main effect Factor 2');
    c4               = strcat(conimagename{contrasts(con)},'_negative main effect Factor 2');
    c5               = strcat(conimagename{contrasts(con)},'_positive interaction Factor 1 X Factor 2');
    c6               = strcat(conimagename{contrasts(con)},'_negative interaction Factor 1 X Factor 2');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[-1 1 0 0 zeros(1,size(P{1},2)) -0.5 -0.5 0.5 0.5]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[1 -1 0 0 zeros(1,size(P{1},2)) 0.5 0.5 -0.5 -0.5]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[0 0 -1 1 zeros(1,size(P{1},2)) -0.5 0.5 -0.5 0.5]',SPM.xX.xKXs);
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[0 0 1 -1 zeros(1,size(P{1},2)) 0.5 -0.5 0.5 -0.5]',SPM.xX.xKXs);  
    SPM.xCon(5)   = spm_FcUtil('Set',c5,'T','c',[0 0 0 0 zeros(1,size(P{1},2)) -1 1 1 -1]',SPM.xX.xKXs);
    SPM.xCon(6)   = spm_FcUtil('Set',c6,'T','c',[0 0 0 0 zeros(1,size(P{1},2)) 1 -1 -1 1]',SPM.xX.xKXs);
    
    
    spm_contrasts(SPM);
   
    
    %cd back up to the root directory
    cd (root_dir);
    
     end  

     if (CCN.rfx.ttest==8)  % 2X2 mixed ANOVA
    
    
    % indices of images - needed for creation of design matrix (assignment of
    % images) 
        

        A(1,:)=CCN.rfx.groups_1==1;
        A(2,:)=CCN.rfx.groups_1==2;
        A(3,:)=CCN.rfx.groups_2==1;
        A(4,:)=CCN.rfx.groups_2==2;
    
    
        P={P(A(1,:)) P(A(2,:)) P(A(3,:)) P(A(4,:))};

    

    
    aps_2X2anova_mixed(P);
    load SPM
    
    % do the contrasts
    c1               = strcat(conimagename{contrasts(con)},'_positive main effect Group');
    c2               = strcat(conimagename{contrasts(con)},'_negative main effect Group');
    c3               = strcat(conimagename{contrasts(con)},'_positive main effect Condition');
    c4               = strcat(conimagename{contrasts(con)},'_negative main effect Condition');
    c5               = strcat(conimagename{contrasts(con)},'_positive interaction Group X Condition');
    c6               = strcat(conimagename{contrasts(con)},'_negative interaction Group X Condition');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    
    n1 = size(P{1},2); % number of subjects in group 1
    n2 = size(P{1},2); % number of subjects in group 2
    nc = 2; % number of levels in condition factor
    ng = 2; % number of groups
    
    MEc = [1:nc]-mean(1:nc); %main effect of condition
    MEg = [1 -1]; % main effect of group


    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[MEg zeros(1,nc) ones(1,n1)/n1 -ones(1,n2)/n2 ones(1,nc)/nc -ones(1,nc)/nc]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[-MEg zeros(1,nc) -ones(1,n1)/n1 ones(1,n2)/n2 -ones(1,nc)/nc ones(1,nc)/nc]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[zeros(1,ng) MEc zeros(1,n1+n2) MEc*[n1/(n1+n2)] MEc*[n2/(n1+n2)]]',SPM.xX.xKXs);   
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[zeros(1,ng) -MEc zeros(1,n1+n2) -MEc*[n1/(n1+n2)] -MEc*[n2/(n1+n2)]]',SPM.xX.xKXs);   
    SPM.xCon(5)   = spm_FcUtil('Set',c5,'T','c',[zeros(1,ng) zeros(1,nc) zeros(1,n1+n2) MEc -MEc]',SPM.xX.xKXs);
    SPM.xCon(6)   = spm_FcUtil('Set',c5,'T','c',[zeros(1,ng) zeros(1,nc) zeros(1,n1+n2) -MEc MEc]',SPM.xX.xKXs);
    
    spm_contrasts(SPM);
   
    
    %cd back up to the root directory
    cd (root_dir);
    
     end  
     
    if (CCN.rfx.ttest==9)  % simple regression
    aps_regression(P,CCN.rfx.covar_1,CCN.rfx.covar_2,CCN.rfx.covar_3,CCN.rfx.covar_4,CCN.rfx.covar_5,CCN.rfx.covar_6);
   
    load SPM
    
    % do the contrasts (assumes that there is an intercept)
    if size(SPM.xX.xKXs.X,2)==2
    c1               = strcat(conimagename{contrasts(con)},'_regression');
    c2               = strcat(conimagename{contrasts(con)},'_regression reverse');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[0 1]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[0 -1]',SPM.xX.xKXs);
    spm_contrasts(SPM);
    end
    
    if size(SPM.xX.xKXs.X,2)==3
    c1               = strcat(conimagename{contrasts(con)},'_regression1');
    c2               = strcat(conimagename{contrasts(con)},'_regression1 reverse');
    c3               = strcat(conimagename{contrasts(con)},'_regression2');
    c4               = strcat(conimagename{contrasts(con)},'_regression2 reverse');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[0 1 0]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[0 -1 0]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[0 0 1]',SPM.xX.xKXs);
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[0 0 -1]',SPM.xX.xKXs);    
    spm_contrasts(SPM);
    end

    if size(SPM.xX.xKXs.X,2)==4
    c1               = strcat(conimagename{contrasts(con)},'_regression1');
    c2               = strcat(conimagename{contrasts(con)},'_regression1 reverse');
    c3               = strcat(conimagename{contrasts(con)},'_regression2');
    c4               = strcat(conimagename{contrasts(con)},'_regression2 reverse');
    c5               = strcat(conimagename{contrasts(con)},'_regression3');
    c6               = strcat(conimagename{contrasts(con)},'_regression3 reverse');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[0 1 0 0]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[0 -1 0 0]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[0 0 1 0]',SPM.xX.xKXs);
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[0 0 -1 0]',SPM.xX.xKXs);   
    SPM.xCon(5)   = spm_FcUtil('Set',c5,'T','c',[0 0 0 1]',SPM.xX.xKXs);
    SPM.xCon(6)   = spm_FcUtil('Set',c6,'T','c',[0 0 0 -1]',SPM.xX.xKXs); 
    spm_contrasts(SPM);
    end

    if size(SPM.xX.xKXs.X,2)==5
    c1               = strcat(conimagename{contrasts(con)},'_regression1');
    c2               = strcat(conimagename{contrasts(con)},'_regression1 reverse');
    c3               = strcat(conimagename{contrasts(con)},'_regression2');
    c4               = strcat(conimagename{contrasts(con)},'_regression2 reverse');
    c5               = strcat(conimagename{contrasts(con)},'_regression3');
    c6               = strcat(conimagename{contrasts(con)},'_regression3 reverse');
    c7               = strcat(conimagename{contrasts(con)},'_regression4');
    c8               = strcat(conimagename{contrasts(con)},'_regression4 reverse');    
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );

    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[0 1 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[0 -1 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[0 0 1 0 0]',SPM.xX.xKXs);
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[0 0 -1 0 0]',SPM.xX.xKXs);   
    SPM.xCon(5)   = spm_FcUtil('Set',c5,'T','c',[0 0 0 1 0]',SPM.xX.xKXs);
    SPM.xCon(6)   = spm_FcUtil('Set',c6,'T','c',[0 0 0 -1 0]',SPM.xX.xKXs); 
    SPM.xCon(7)   = spm_FcUtil('Set',c7,'T','c',[0 0 0 0 1]',SPM.xX.xKXs);
    SPM.xCon(8)   = spm_FcUtil('Set',c8,'T','c',[0 0 0 0 -1]',SPM.xX.xKXs);    
    spm_contrasts(SPM);
    end

    if size(SPM.xX.xKXs.X,2)==6
    c1               = strcat(conimagename{contrasts(con)},'_regression1');
    c2               = strcat(conimagename{contrasts(con)},'_regression1 reverse');
    c3               = strcat(conimagename{contrasts(con)},'_regression2');
    c4               = strcat(conimagename{contrasts(con)},'_regression2 reverse');
    c5               = strcat(conimagename{contrasts(con)},'_regression3');
    c6               = strcat(conimagename{contrasts(con)},'_regression3 reverse');
    c7               = strcat(conimagename{contrasts(con)},'_regression4');
    c8               = strcat(conimagename{contrasts(con)},'_regression4 reverse');
    c9               = strcat(conimagename{contrasts(con)},'_regression5');
    c10               = strcat(conimagename{contrasts(con)},'_regression5 reverse');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );

    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[0 1 0 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[0 -1 0 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[0 0 1 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[0 0 -1 0 0 0]',SPM.xX.xKXs);   
    SPM.xCon(5)   = spm_FcUtil('Set',c5,'T','c',[0 0 0 1 0 0]',SPM.xX.xKXs);
    SPM.xCon(6)   = spm_FcUtil('Set',c6,'T','c',[0 0 0 -1 0 0]',SPM.xX.xKXs); 
    SPM.xCon(7)   = spm_FcUtil('Set',c7,'T','c',[0 0 0 0 1 0]',SPM.xX.xKXs);
    SPM.xCon(8)   = spm_FcUtil('Set',c8,'T','c',[0 0 0 0 -1 0]',SPM.xX.xKXs);
    SPM.xCon(9)   = spm_FcUtil('Set',c9,'T','c',[0 0 0 0 0 1]',SPM.xX.xKXs);
    SPM.xCon(10)   = spm_FcUtil('Set',c10,'T','c',[0 0 0 0 0 -1]',SPM.xX.xKXs);    
    spm_contrasts(SPM);
    end  

    if size(SPM.xX.xKXs.X,2)==7
    c1               = strcat(conimagename{contrasts(con)},'_regression1');
    c2               = strcat(conimagename{contrasts(con)},'_regression1 reverse');
    c3               = strcat(conimagename{contrasts(con)},'_regression2');
    c4               = strcat(conimagename{contrasts(con)},'_regression2 reverse');
    c5               = strcat(conimagename{contrasts(con)},'_regression3');
    c6               = strcat(conimagename{contrasts(con)},'_regression3 reverse');
    c7               = strcat(conimagename{contrasts(con)},'_regression4');
    c8               = strcat(conimagename{contrasts(con)},'_regression4 reverse');
    c9               = strcat(conimagename{contrasts(con)},'_regression5');
    c10               = strcat(conimagename{contrasts(con)},'_regression5 reverse');
    c11               = strcat(conimagename{contrasts(con)},'_regression6');
    c12               = strcat(conimagename{contrasts(con)},'_regression6 reverse');
    
    SPM.xCon = struct( 'name',{{'init'}}, 'STAT', [1], 'c', [1], 'X0', [1], ...
             'iX0', {{'init'}}, 'X1o', [1], 'eidf', [], 'Vcon', [],   ...
'Vspm', [] );
    
    SPM.xCon(1)   = spm_FcUtil('Set',c1,'T','c',[0 1 0 0 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(2)   = spm_FcUtil('Set',c2,'T','c',[0 -1 0 0 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(3)   = spm_FcUtil('Set',c3,'T','c',[0 0 1 0 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(4)   = spm_FcUtil('Set',c4,'T','c',[0 0 -1 0 0 0 0]',SPM.xX.xKXs);   
    SPM.xCon(5)   = spm_FcUtil('Set',c5,'T','c',[0 0 0 1 0 0 0]',SPM.xX.xKXs);
    SPM.xCon(6)   = spm_FcUtil('Set',c6,'T','c',[0 0 0 -1 0 0 0]',SPM.xX.xKXs); 
    SPM.xCon(7)   = spm_FcUtil('Set',c7,'T','c',[0 0 0 0 1 0 0]',SPM.xX.xKXs);
    SPM.xCon(8)   = spm_FcUtil('Set',c8,'T','c',[0 0 0 0 -1 0 0]',SPM.xX.xKXs);
    SPM.xCon(9)   = spm_FcUtil('Set',c9,'T','c',[0 0 0 0 0 1 0]',SPM.xX.xKXs);
    SPM.xCon(10)   = spm_FcUtil('Set',c10,'T','c',[0 0 0 0 0 -1 0]',SPM.xX.xKXs);
    SPM.xCon(11)   = spm_FcUtil('Set',c11,'T','c',[0 0 0 0 0 0 1]',SPM.xX.xKXs);
    SPM.xCon(12)   = spm_FcUtil('Set',c12,'T','c',[0 0 0 0 0 0 -1]',SPM.xX.xKXs);    
    spm_contrasts(SPM);
    end    
    %cd back up to the root directory
    cd (root_dir);
    end
     
end




    
    