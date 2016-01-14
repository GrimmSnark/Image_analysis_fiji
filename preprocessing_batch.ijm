// Michael Savage 11/01/2015
//This macro runs batch preanaylsis for tracing pictures
// Includes Gaussian blur and split&separation of colour channels and saving

macro "Preprocessing FITC... " {

// These options need personalised for individual data sets
fileIdentifier = "(FITC).TIF";
fileIdentifier_2 = "(FITC).tif"); // ImageJ treats capitalised and non-capitalised letters differently
 
dir = getDirectory("Choose a Directory for Preprocessing");
//dir_2 = getDirectory("Choose a Directory for Saving Files");

setBatchMode(true);
 
list = getFileList(dir); // Gets a file list from directory
for (i = 0; i < list.length; i++)
	{
		batchPreproccessing(dir, dir, list[i]);	 // Runs through the file list
		//batchPreproccessing(dir, dir_2, list[i]); // Uncomment this and comment out the above statement if input and output directories are different
    }
setBatchMode(false);


function batchPreproccessing(input, output, filename) 
{
	
	if (endsWith(filename, fileIdentifier)==1 || endsWith(filename, fileIdentifier_2)==1  ) // Filtering options, in this case only processes images with the 'fileIdentifier' string at the end of the filename
	{
		open(input + filename);
		if (bitDepth() != 8) // does not process grayscaled images
		{
			run("Set Scale...", "distance=617 known=200 pixel=1 unit=um"); // You may or may not want to properly set the scales for the images (distance in pixels, known distance in real life, pixel aspect ratio (1), unit of length (see macro website for ImageJ)
			run("Gaussian Blur...", "sigma=3.5"); // may need to change sigma size to get the right level of filtering of artefacts 
			run("Split Channels"); // Splits channels into red, green, blue and grayscales them 

			selectImage(filename+" (red)");
			close(); // deletes red channel
			selectImage(filename+" (blue)");
			close(); // deletes blue channel, may need to personalise for dataset
			
			if (endsWith(filename, "TIF")==1 || endsWith(filename, "tif") == 1 ) // if filename ends in 'TIF' or 'tif' savers files as .tif. otherwise saves as .jpeg
				{
				saveAs("tiff", output +filename +"_gray");
				}
			else
				{
				saveAs("jpeg", output +filename +"_gray");
				}
			print(filename +"has been processed and saved"); // outputs current image name and that is has been processed succesfully
				
			call("java.lang.System.gc"); // cleans up memory used, this script may fail if ImageJ uses all the RAM in computer. ImageJ is not very efficient at releasing unused RAM 
		}
		else
		{
		print(filename +"has NOT been processed as has already been grayscaled");
		close();
		}
	}
	
}
