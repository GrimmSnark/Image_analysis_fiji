// Michael Savage 11/1/15
// Macro for background luminance subtraction of tracing photos
// Image must be grayscaled 8 bit and open before macro starts

happy = 0; // sets initial state for recurring process

while(!happy)
{
	setTool("polygon");
	currentTitle = getTitle();
	run("Duplicate...", currentTitle); // duplicates images for reference
	selectImage(currentTitle);
	waitForUser("select the background ROI and press YES, or cancel to exit macro");
	run("Set Measurements...", " mean standard redirect=None decimal=0");
	run("Measure"); 
	selectImage(currentTitle);
	//run("Invert LUT"); // may need to invert LUT depending on image type
	bgmean=getResult("Mean",(nResults-1));
	bgStdev=getResult("StdDev",(nResults-1));
	bgTotal=bgmean+(bgStdev*bgStdev);
	run("Select All");
	setThreshold(0, bgTotal , "Black & White"); // This is for white on black images
	thresholdImage = "Threshold_"+currentTitle;
	rename(thresholdImage);
	thresholdImageID = getImageID();
	run("Select None");		 
	selectWindow("Results");
	run("Close");

	selectImage(thresholdImageID);
	//run("Invert LUT"); // may need to re-invert LUT depending on image type

	response = getBoolean("If happy with thresholding, press YES to save");

	if (response == 1) // if happy with image thresholding, saves and closes everything
	{
		dir = getDirectory(currentTitle);
		fullpath = dir+thresholdImage;

		run("Flatten");
		run("8-bit");
		save(fullpath);
			
		 while (nImages>0) 
		 { 
			selectImage(nImages); 
			close(); 
		 }
		 happy = 1;
	}

	else
	{
		run("Close");
	}	 
}