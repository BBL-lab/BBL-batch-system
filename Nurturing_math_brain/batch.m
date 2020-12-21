function nothing = pre_batch
% pre_batch.m 
%
% this is a script that handles all of the 
% preprocessing and processing in SPM12 and artrepair.  It 
% intelligently pulls files off of the SAN and create a logical
% hierarchical directory structure.
% 
% Initial script from Ken Roberts
% Adapted and modified by Daniel Weissman, Josh Carp, Jerome Prado and Chris McNorgan
% This last updated version is adapted for handling data organized in the BIDS
% format. It also uses Artrepair
%

% Prerequisites for use:

% 1) SPM12 must be in the matlab path.
% 2) Artrepair scripts must be in the matlab path.
% 3) Nifti tools must be in the matlab path.
% 4) GLM Flex must be in the matlab path.

global CCN;

% load the defaults first, and then do 'load_vars' to allow the
% defaults to be overwritten as specified below.

spm('defaults','fmri');
load_vars;

This is the script that was used to preprocess data and analyze main effects from the manuscript "Nurturing the mathematical brain: 
Home numeracy practices are associated with children’s neural responses to Arabic numerals" by Cléa Girard, Thomas Bastelica, Jessica Léone, Justine Epinat-Duclos, Léa Longo & Jérôme Prado 



%%%%%%%%%%%%%%%%%User-Defined Variables%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Here is a list of the possible procedures to perform.  These should be specified in c_names in the order they should be performed.

%uncompress_c : Converts original nii.gz files into nii images (necessary for the batch system to work
%clean_c    : Removes all preprocessing files
%deface_c    : Defaces anatomical images
%expand_c : Converts 4D nii images into 3D nii images and put them in preprocessing folder (necessary for artrepair to work)
%slice_c     : implements slice-timing
%realign_c   : implememts realignment
%resample_c : Reslices the functional images.
%smooth_c    : Spatially smooths the functional images with a Gaussian
%motionregress_c : Removes residual interpolation errors after the realign and reslice operations (from the ArtRepair toolbox)
%global_c : Removes outlier scans (see art_global.m from the Artrepair toolbox)
%coregister_c: coregisters an anatomical and a functional image (not necessary if normalizing functionals independent of the anatomical)
%normalise_c : Normalizes the functionals to the functional or anatomical tenmplate
%fmri_model_c: Estimates brain activity for different conditions/trial types using the general linear model
%fmri_contrasts_c : Generates contrasts between linear combinations of betas within each subject.
%spm_rfx_bch_c : Performs Random-Effects across subjects
%compress_c : Converts original nii images into nii.gz files
%motion_report_c : Generates a text file (motion_report.tsv) that contains information about the amount of movement in each subject/task/run
%ROI_c : Average beta values within Regions of Interest

%c_names = {'uncompress_c' 'clean_c' 'expand_c' 'slice_c' 'realign_c' 'resample_c' 'smooth_c' 'motionregress_c' 'global_c' 'coregister_c' 'normalise_c' 'motion_report_c'}; % preprocessing pipeline with Artrepair
%c_names = {'fmri_model_c' 'fmri_contrasts_c'}; % single-subject analysis pipeline
c_names = {'spm_rfx_bch_c'}; % RFX analysis
%c_names = {'ROI_c'}; % ROI analysis
%c_names = {'clean_c'};
%c_names = {'compress_c'};


    %%%%%%%%%%%%%%%%%% DO NOT EDIT THIS SECTION %%%%%%%%%%%%%%%%%%%%%%%%%

    
        for i = 1:length(CCN.all_subjects)
        %Load the defaults for this subject with load_vars and then specify any exceptions for this subject
        load_vars;
        CCN.subject = sprintf('%s', CCN.all_subjects{i});
        
        cd(CCN.work_dir);
        
        %Do each step of preprocessing
        for j = 1:length(c_names)
            feval(c_names{j})
            if find(ismember(c_names, 'spm_rfx_bch_c')), 'quitting', return, end
            if find(ismember(c_names, 'spm_rfx_bch_LOSO_c')), 'quitting', return, end            
        end;
            
        
    end; % for each subject
    
    return;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
 
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This is where all of the options are defined.  There are three main
    % classes of option.  
    %   - ones that define the directory hierarchy
    %   - ones that define the preprocessing options
    %   - ones that define the operation of the preprocessing script
    %       eg, where to log the results, and where to email if something 
    %       goes wrong
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function load_vars
    global CCN;
    
    %%%%%%%%%
    % Directory Hierarchy
    %%%%%%%%
    
    % root local directory for the experiment.
    CCN.root_dir = '/crnldata/bbl/NTR/PRE_MATHS_BIDS';
    
    
%50 subjects for digits
CCN.all_subjects =  {'sub-01'	'sub-02'	'sub-03'	'sub-04'	'sub-05'	'sub-06'	'sub-07'	'sub-09'	'sub-10'	'sub-11'	'sub-12'	'sub-13'	'sub-14'	'sub-15'	'sub-17'	'sub-18'	'sub-19'	'sub-20'	'sub-24'	'sub-25'	'sub-27'	'sub-28'	'sub-29'	'sub-30'	'sub-31'	'sub-32'	'sub-36'	'sub-37'	'sub-38'	'sub-40'	'sub-41'	'sub-43'	'sub-44'	'sub-45'	'sub-46'	'sub-48'	'sub-50'	'sub-54'	'sub-55'	'sub-58'	'sub-59'	'sub-60'    'sub-61'	'sub-64'	'sub-65'    'sub-67'	'sub-68'	'sub-69'    'sub-70'	'sub-72'}; 

%44 subjects for digits
%CCN.all_subjects =  {'sub-01'	'sub-03'	'sub-04'	'sub-05'	'sub-06'	'sub-07'	'sub-09'	'sub-10'	'sub-11'	'sub-12'	'sub-13'	'sub-14'	'sub-17'	'sub-18'	'sub-19'	'sub-20'	'sub-25'	'sub-28'	'sub-29'	'sub-30'	'sub-31'	'sub-32'	'sub-36'	'sub-37'	'sub-38'	'sub-40'	'sub-41'	'sub-43'	'sub-44'	'sub-45'	'sub-46'	'sub-48'	'sub-50'	'sub-55'	'sub-58'	'sub-59'	'sub-60'	'sub-61'	'sub-64'	'sub-65'	'sub-67'	'sub-68'	'sub-69'	'sub-72'}; 

 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    %%%%%%%%%%%%%%%%%% DO NOT EDIT THIS SECTION %%%%%%%%%%%%%%%%%%%%%%%%%

   
    % file pattern - describes the name of the files for each step
    % contains different values depending on which m file calls it.
    
CCN.work_dir = CCN.root_dir; 

% run pattern - describes the name of the run folders that will be in the preprocessing directory
    CCN.run_pattern = 'sub*';
    
CCN.file_pattern = struct( ...
        'default',           'sub-*.nii', ... 
        'slice_c',           'sub-*.nii', ...
        'realign_c',         'asub-*.nii', ...
        'resample_c',        'asub-*.nii', ...
        'normalise_c',       'vmsrasub-*.nii', ...
        'smooth_c',          'rasub-*.nii', ... 
        'expand_c',          'sub-*.nii', ... 
        'global_c',          'msrasub-*.nii', ... 
        'fmri_model_c',      'wvmsrasub-*.nii', ...
        'spm_rfx_bch_c',     'swasub-*.nii');


    %
    % functional and anatomical codes
    
    % The way these work is that each describes the location of a large number
    % of files in changing places.  When the code runs, the paths will be formed
    % by doing a number of substitutions.  Any quantity in square brackets will 
    % be replaced with the contents of that field in the variable CCN.  
    % Any regular expression will also be expanded.
    CCN.functional_dirs  = '[root_dir]/[subject]/func/';
    CCN.anatomical_dirs  = '[root_dir]/[subject]/anat/';
    CCN.functional_files = '[root_dir]/[subject]/func/[file_pattern]';
    CCN.anatomical_files = '[root_dir]/[subject]/anat/[file_pattern]';
    CCN.first_anat = '[root_dir]/[subject]/anat/sub-*.nii';
    CCN.def_anat = '[root_dir]/[subject]/anat/y_sub-*.nii';
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%
    % Preprocessing options
    %%%%%%%%
    
    
    % slice timing, assumes reference slice of 1.
    CCN.TR = 2;
    CCN.nslices = 32;
  
    %Specify the order in which the slices were acquired
    %1=ascending (1...nslices)
    %2=descending (nslices.jp...1)
    %3=interleaved odd (1 3 5 7 9.....2 4 6 8 10)   
    %4=interleaved even (2 4 6 8 10.....1 3 5 7 9)  
    CCN.seq=4;
    
    % realignment options.
    CCN.realign_flags = struct( ...
        'quality', 0.9, ... % between 0 and 1, this is the default
        'fwhm', 5, ...       % in mm, this is the default
        'rtm', 0);           % use 1 for fMRI registration to mean
    CCN.first_func = '[root_dir]/[subject]/func/[subject]_task-Digits_run-01_bold.nii'; % image to use as reference for realignement

    
   % reslice options.
    CCN.reslice_flags = struct( ...
        'mask', 1, ... 
        'mean', 0, ...       
        'interp', 1, ...       
        'which', 2);  
    
    % coregistration options
    CCN.coreg_flags = struct( ...
        'sep', [4 2], ...               % optimisation sampling steps (mm)
        'params', [0 0 0  0 0 0], ...   % starting estimates (6 elements)
        'cost_fun', 'nmi', ...          % cost function string
        'tol', [0.02 0.02 0.02 0.001 0.001 0.001], ... % tolerences for accuracy of each param
        'fwhm', [7 7] ...              % smoothing to apply to 256x256 joint histogram
        );
    
    % normalization options (if 3 or 4 chosen, only CCN.normalise_wr_flags is read)
    CCN.norm=4;  % Determine normalisation parameters from: 1= first functional; 2= anatomital; 3= unified segmentation (SPM8 style); 4= unified segmentation (SPM12 style)
    
     
    CCN.normalise_est_flags = struct( ...
        'smosrc', 8, ...        % smoothing of source image (FWHM of Gaussian in mm)
        'smoref', 0, ...        % smoothing of template image (defaults to 0).
        'regtype', 'mni', ...   % regularisation type for affine registration
        ...                     %   See spm_affreg.m (default = 'mni').
        'weight', '', ...
        'cutoff', 30, ...       % Cutoff of the DCT bases.  Lower values mean more
        ...                     %   basis functions are used (default = 30mm).
        'nits', 16, ...         % number of nonlinear iterations (default=16).
        'reg', 0.1, ...         % amount of regularisation, higher val = less warping,
        ...                     %   (default=0.1)
        'wtsrc', 0);                
    
    CCN.normalise_wr_flags = struct( ...
        'preserve', 0, ...          %
        'bb', [-78 -112 -50; 78 76 85], ...     % bounding box
        'vox', [2 2 3.5], ... % voxel size
        'interp', 7, ...            % 2nd order bspline interpolation
        'wrap', [0 0 0]);           % wrap around edges in x y or z dimensions
    
    % smoothing options
    CCN.smooth_kernel = [4 4 7]; % FWHM of Gaussian kernel in mm
    
    
    %% ArtRepair options
    CCN.z_thresh = 3; % global mean intensity outliers in std (see art_global.m line 110 for explanations)
    CCN.mv_thresh = 2; % allowable motion within a TR (see art_global.m line 116 for explanations) 
    CCN.MVMTTHRESHOLD = 4; % motion threshold (see function art_clipmvmt)
    
    %%%%%%%%%
    % Model specification options
    %%%%%%%%
    
    % is the onset vector specified in scans or seconds? ('scans' or 'secs')
    %the first scan (TR) is always numbered 0.
    CCN.model.units = 'secs';
    
    % specify the basis set- the choices are the strings below:
    %     'hrf', 'hrf (with time derivative)', 'hrf (with time and dispersion derivatives)',
    %     'Fourier set', 'Fourier set (Hanning)', 'Gamma functions', 'Finite Impulse Response'
    CCN.model.basis = 'hrf';
    
    %Specify the number of seconds or scans to be modeled
    %This variable applies when modeling with a canonical HRF or a Finite
    %Impulse Response Model
    CCN.model.length = 24; 
    
    %Specify the the number of time points to be modeled if FIR
    %This variable is automatically set and overwritten when NOT using an FIR
    CCN.model.order = 12;
    
    %Specify fMRI_T --how many bins to subdivide each TR into
    %DEFAULT=16;
    CCN.model.fmri_T = 16;
    
    %Specify fMRI_TO --reference slice
    %DEFAULT=1;
    CCN.model.fmri_T0 = 1;
    
    %Specify if you want to orthogonalize the regressors in the design matrix
    %1=yes
    %0=no
    CCN.model.orthogonalize = 1;
    
    %Specify if you want to include the motion regressors in the design matrix
    %1=yes
    %0=no
    CCN.model.motion = 0;
    
    
    % Model Volterra interactions? (2=yes, 1=no)
    % the number actually corresponds as the order of the Volterra
    % interactions, with 1 and 2 being the only options.
    %Entering 2 would allow you to model interactions between trial types
    CCN.model.volterra = 1;
    
    % Global intensity normalisation ('Scaling' or 'None')
    CCN.model.global_sc = 'None';
    
    % specify the hi-pass cutoff in seconds (number or 'inf', vector for
    % sessions, default = 128 sec)
    CCN.model.hpf = 128;
    
    % Correct for serial correlations? ('none' | 'AR(1)')
    CCN.model.ser_corr = 'AR(1)';
    
    % name of realignment parameters file?
    % (one of these should be in every run folder)
    CCN.model.rp_name = 'rp_*';
    
    
    % specify the file that has all of the onsets and covariates
    % (expandable)

    CCN.model.spec_file = '[root_dir]/model_spec.m';
  
    
    % Scale factor for NaN thresholding applied in fmri_model_c
    % A value of 1 has no effect
    CCN.model.thresh_factor = 1;
    
    % specify the place to construct the model (to put the SPM.mat and so
    % forth) (expandable)
    CCN.model.model_dir = '[root_dir]/[subject]/analysis'; 
  
    
    % if you want to do contrasts for each subject, this variable should contain the filename
    % of a valid contrast_spec file.
    
    CCN.model.contrast_spec_file = '[root_dir]/create_contrasts.m';
       
    %Specify whether you want to add new contrasts or overwrite old contrasts so that new ones are
    %numbered starting with 2 (the F-contrast for effects of interest -
    %con0001 - won't be overwritten)
    %0=add new contrasts to existing ones
    %1=overwrite existing contrasts with new ones
    CCN.OverwriteContrasts = 1;
    
    
    %%%%%%%%%
    % Random Effects Analyses 
    %%%%%%%%
    
    % RFX parameters 
    
    CCN.dept = 0;  %% Assume Dependence?       0=no or 1=yes
    CCN.var = 1;   %% Assume Unequal Variance?   0=no or 1=yes
    CCN.tm.tm_none = 1;    %% No Threshold Masking
    CCN.im = 0;    %% Implicit Masking   1 = yes, 0 = no
    CCN.em = {''}; %% Explicit Masks     list mask files e.g. {'/autofs/space/plato_002/users/APS_MATLAB/spm8/templates/epi.nii,1'};
    CCN.g_omit = 1;    %% Global Calculation:   1 is the default setting
    CCN.gmsca.gmsca_no = 1;  %% No Grand Mean Scaling.
    CCN.glonorm = 1;   %% Global Normalization.  1 = No. 2 = Proportional 3 = ANCOVA
    
    
    % which test to perform?  
    % 1=one-sample t-test (one group)
    % 2=two-sample t-test (two groups)
    % 3=paired t-test (two sessions)
    % 4=one-way between subjects ANOVA (up to 6 groups)
    % 5=one-way repeated measures ANOVA (up to 6 sessions)
    % 6=2X2 between subjects ANOVA
    % 7=2X2 within subjects ANOVA
    % 8=2X2 mixed subjects ANOVA
    % 9=Multiple regression
    
    CCN.rfx.ttest = 1 ;
    
    % GROUP VECTOR IF TEST 2 to 5
    % This is ignored if one-sample t-test is selected above. Otherwise, the
    % vector should specify which subject belongs to which group (the subject list is in CCN.all_subjects). 
    % Two-sample and paired t-tests require a vector in which each subject can have two values (1 or 2 depending on the group) 
    % one-way between subjects and repeated measures ANOVA can have up to 6 levels
    % The subject order does not matter for two-sample t-test and between subject ANOVA  
    % For paired t-test and repeated measures ANOVA, the order matters: the first subject in each group is considered the same repeated measure, and so on
     
    CCN.rfx.groups = [1 	1	1	1	1	1	1	1	1	1  1   1  1  1  1  1  2  2   2  2  2  2  2  2  2  2  2  2  2  2  2  2  2  2 ]; %ELEMENTARY vs COLLEGE
   
    
    % GROUP VECTOR IF TEST 6 to 8. 
    % Each vector represents one factor
    % (between-subject factor for tests 6 and 8 and within-subject factor
    % for test 7). Withing each vector, each level (1 or 2) needs to be specified. Fill the rest with 0s.  
    CCN.rfx.groups_1 = [1 1 1 1 1 1 1 2 2 2 2 2 2 2 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    CCN.rfx.groups_2 = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 1 1 1 1 1 1 2 2 2 2 2 2 2];
    
    % COVARIATE VECTORS IF TEST 9. 
    % Each vector represents one covariate (up
    % to 6). If there is less than 6 covariates, leave an empty vector
    % (e.g., CCN.rfx.covar_6 = [])
   
            
   
    CCN.rfx.covar_1 = [];
    
    CCN.rfx.covar_2 = [];
   
    CCN.rfx.covar_3 = [];
    
    CCN.rfx.covar_4 = [];
    
    CCN.rfx.covar_5 = [];
    
    CCN.rfx.covar_6 = [];

 
    
    % which contrasts to analyze? Either indicate a vector of contrats
    % (e.g.CCN.rfx.contrasts = [9];) or that you want to run all of the
    % contrasts (i.e., CCN.rfx.contrasts = 'all';)

    CCN.rfx.contrasts = [1];
   
    % where to do the analysis
    CCN.rfx.rfx_dir = '[root_dir]/RFX/digits';
    
    
    %%%%%%%%%%%%%%%%%%% ROI ANALYSES %%%%%%%%%%%%%%%%%%%%%%
    
    CCN.ROI.dir = '[root_dir]/ROIs_analysis'; % directory where the ROI can be found and where the results will be stored 
    CCN.ROI.file = 'IPS'; % name of the ROI (this should be a nifti file located in the CCN.ROI.dir directory)
    
    
    %%%%%%%%%%%%%%%%%DO NOT EDIT BELOW THIS LINE%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %
    % Deletes files specified by a certain string.
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function delete_many_files(file_spec)
    global CCN;
    
    my_files = expand_path(file_spec);
    
    fprintf('Deleting %d files for subject %s \r\n   %s\r\n', length(my_files), CCN.subject, file_spec)
    
    for i = 1:length(my_files)
        delete(my_files{i});
        if mod(i,100) == 0
            fprintf('\r\n   %d ', i);
        elseif mod(i,10) == 0
            fprintf(' %d', i);
        else
            %nothing
        end;
    end;
    
    return;
