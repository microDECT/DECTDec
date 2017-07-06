# DECTDec

DECTDec (Dual Energy Computed Tomography Decomposition) is a MATLAB-based tool for three-material decomposition based on dual energy microCT scanning. It is a supplement to the publication _"Microscopic dual-energy CT (microDECT): a flexible tool for multichannel ex vivo 3D imaging of biological specimens"_.


Requirements:
1. MATLAB 2012b or higher
2. Two 16bit *.tif sequences in two separate folders, representing the two respective scan energies. They can be in 16 bit signed or 16 bit unsigned format. The two image sequences must have the same X-Y-Z dimensions, and should have been accurately registered using some volume image registration algorithm.


Contents:
1. MATLAB program
2. Test Data
3. Manual

If you use this code, please cite as:  
Handschuh, S., Beisser, C.J., Ruthensteiner, B., and B.D. Metscher (2017): Microscopic dual-energy CT (microDECT): a flexible tool for multichannel ex vivo 3D imaging of biological specimens. Journal of Microscopy 267 (1), 3-26. DOI: 10.1111/jmi.12543
