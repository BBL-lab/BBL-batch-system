# BBL batch system
This repository contains scripts that automatize the processing of fMRI data with SPM using Matlab wrappers. The scripts handle all of the preprocessing and processing using SPM12 and Artrepair.  They intelligently pull files off of the file system and create a logical hierarchical directory structure.
The initial script were created by Ken Roberts (Duke University) and modified by Daniel Weissman, Josh Carp, Jérôme Prado and Chris McNorgan (U. of Michigan and Northwestern U.). The last version version was adapted for handling data organized in the BIDS format by Jérôme Prado (CNRS).

# Dependencies:

1) SPM12 must be in the matlab path (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/).
2) Artrepair scripts must be in the matlab path (https://www.nitrc.org/projects/art_repair/).
3) Nifti tools must be in the matlab path (https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image).
4) GLM Flex must be in the matlab path (https://habs.mgh.harvard.edu/researchers/data-tools/?title=GLM_Flex_Fast2).

All of these can be found in the lab fMRI tools.

# Get started

The batch system operates on datasets organized in the BIDS format (https://bids.neuroimaging.io). So to get started you need to make sure your data is in that format. You will then need to edit 4 files (these should be in your working directory).

- batch.m: This is the main file in which you specify the different preprocessing and processing steps and well as the paths and the different variables SPM will use for running the analyses.
- create_onsets.m: This script will create vectors of onsets based on the tsv files for each subjects/task/run. So it needs to be customized depending on your data.
- model_spec.m: This script specifies your design matrix at the single-subject level. It also needs to be customized depending on your data.
- create_contrasts: This script specifies the contrasts that need to be applied to your design matrix for each subject. It also needs to be customized depending on your data.

All of the analyses can be run with the batch.m script (see comments in batch.m).
