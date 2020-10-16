# BBL batch system
This repository contains scripts that automatize the processing of fMRI data with SPM using Matlab wrappers. The scripts handle all of the preprocessing and processing using SPM12 and Artrepair.  They intelligently pull files off of the file system and create a logical hierarchical directory structure.
The initial script were created by Ken Roberts (Duke University) and modified by Daniel Weissman, Josh Carp, Jérôme Prado and Chris McNorgan (U. of Michigan and Northwestern U.). The last major update allows for handling data organized in the BIDS format.

# Dependencies:

Besides SPM12 (which can be freely downloaded here: https://www.fil.ion.ucl.ac.uk/spm/software/spm12/), the following toolboxes need to be in the matlab path for the batch to work:

1) Artrepair (https://www.nitrc.org/projects/art_repair/).
2) Nifti tools (https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image).
3) GLM Flex (https://habs.mgh.harvard.edu/researchers/data-tools/?title=GLM_Flex_Fast2).

Because some of the scripts of the aforementioned toolboxes had to be adapted to work with the batch system, the working versions of the toolboxes can be found in the dependencies folder.

# Get started

The batch system operates on datasets organized in the BIDS format (https://bids.neuroimaging.io). So to get started you need to make sure your data is in that format. You will then need to copy and paste 4 files into your working directory:

- batch.m: This is the main file in which you specify the different preprocessing and processing steps and well as the paths and the different variables SPM will use for running the analyses.
- create_onsets.m: This script will create vectors of onsets based on the tsv files for each subjects/task/run. So it needs to be customized depending on your data.
- model_spec.m: This script specifies your design matrix at the single-subject level. It also needs to be customized depending on your data.
- create_contrasts.m: This script specifies the contrasts that need to be applied to your design matrix for each subject. It also needs to be customized depending on your data.

All of these files can be found in the example_project_scripts folder. The analyses can be run with the batch.m script (see comments in batch.m).
