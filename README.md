# BBL-batch-system
This repository contains scripts that automatize the processing of fMRI data with SPM using Matlab wrappers. The scripts handle all of the preprocessing and processing in SPM12 and artrepair.  They intelligently pulls files off of the SAN and create a logical hierarchical directory structure.
The initial script were created by Ken Roberts. They were then adapted and modified by Daniel Weissman, Josh Carp, Jerome Prado and Chris McNorgan. The last version version was adapted for handling data organized in the BIDS format. It also uses the Artrepair toolbox.

Prerequisites for use:

1) SPM12 must be in the matlab path.
2) Artrepair scripts must be in the matlab path.
3) Nifti tools must be in the matlab path.
4) GLM Flex must be in the matlab path.
