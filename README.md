# Image_analysis_fiji
Analysis scripts utilised for mouse connectivity paper

This package of ImageJ/Fiji macros is designed to allow the user to quantify fluorescent tracing photomicrographs and compare
the connectivity between multiple regions in the brain

Lines in the startupmacro_addendum.txt should be added to the local startup macro file in your ImageJ/Fiji macro folder
.ijm files numbered 1-5 should be copied into that folder as well

Workflow should proceed with:

1. Preprocessing/Preprocessing batch-Grayscales colour images and filters for acquisition artefacts
2. Background Subtraction- Preforms average background luminance subtraction based on user input ROI and thresholds image
3. Quantification- Run either anterograde (which measures fibre percentage area coverage) or retrograde (measures cell counts per ROI)
  with thresholded images and counterstained images with ROIs for the demarcated brain regions
4. Modulation index-Place quantification results for each region into array and run this matlab script to get a modulation index for
  preference between two regions (To Do)
  
  
  
  
For any more information regarding other macros and building your own macro scripts for ImageJ/Fiji visit:
http://rsb.info.nih.gov/ij/developer/macro/macros.html

Any questions regarding this code can be directed to michael.savage1@me.com
