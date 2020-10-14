# BBL-batch-system
This repository contains scripts that automatize the processing of fMRI data with SPM using Matlab wrappers. The scripts handle all of the preprocessing and processing in SPM12 and Artrepair.  They intelligently pulls files off of the SAN and create a logical hierarchical directory structure.
The initial script were created by Ken Roberts. They were then adapted and modified by Daniel Weissman, Josh Carp, Jerome Prado and Chris McNorgan. The last version version was adapted for handling data organized in the BIDS format. It also uses the Artrepair toolbox.

Prerequisites for use:

1) SPM12 must be in the matlab path (https://www.fil.ion.ucl.ac.uk/spm/software/spm12/).
2) Artrepair scripts must be in the matlab path (https://www.nitrc.org/projects/art_repair/).
3) Nifti tools must be in the matlab path (https://www.mathworks.com/matlabcentral/fileexchange/8797-tools-for-nifti-and-analyze-image).
4) GLM Flex must be in the matlab path (https://habs.mgh.harvard.edu/researchers/data-tools/?title=GLM_Flex_Fast2).
