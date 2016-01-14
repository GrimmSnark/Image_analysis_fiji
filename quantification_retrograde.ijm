// Michael Savage 11/1/15
// Macro for tracer quantification of retrograde pictures 
// Thresholded image must have undergone threholding step
// ROI image must be counterstained image which will contain ROI demarcations of areas

waitForUser("Select Thresholded window");
thresholdTitle = getTitle();
run("Set Scale...", "distance=617 known=200 pixel=1 unit=um"); // sets scale for image if you already have not, will need to be personalised
waitForUser("Select ROI window"); // selects counterstained image with ROIs for each area of anaylsis/comparison
ROITitle = getTitle();
run("Set Scale...", "distance=617 known=200 pixel=1 unit=um"); // sets scale for image if you already have not, will need to be personalised

setTool("polygon");
waitForUser("Set ROIs for analysis then press ctrl + t to add to manager, or cancel to exit macro");
numROI = roiManager("count");

// creates areas for values needed later to the size of number of ROIs
Area= newArray(numROI);
SD= newArray(numROI);
blackCoverage= newArray(numROI);
TracerPecentageCover= newArray(numROI);

selectWindow(thresholdTitle);
run("Invert LUT"); // may need to invert LUT depending on image type ( the analysis only counts black pixels, NOT white)
run("8-bit");

if (numROI == 1)
	{
		j = 0;
		selectWindow(thresholdTitle);
		roiManager("select", j)
		run("Restore Selection");
		run("Set Measurements...", "area mean standard redirect=None decimal=0");
		run("Measure");
		Area[j] = getResult("Area",0);
		SD[j] =getResult("StdDev",0);
		run("8-bit");
		run("Analyze Particles...", "size=[20-Infinity]  circularity=[0.00-1.00] show=[Overlay Outlines] display include summarize add"); // runs the actual anaylsis of the tracer (size= [xxx-Infinity] xxx = minimum pixel area to be counted

		//retrieves information from the summary window
		selectWindow("Summary"); 
		lines = split(getInfo(), "\n"); 
		headings = split(lines[0], "\t"); 
		values = split(lines[lengthOf(lines)-1], "\t");
		// prints out all of the values into an array form
		/*
		for (i=0; i<headings.length; i++) 
		{
		print(headings[i]+": "+values[i]);
		}
		*/
		//write(values[1]); // prints the cell counted value
		blackCoverage[j]= values[1]; //values[1] is the number of counted cells blackCoverage
	}
else
	{
		
	for (i = 0; i <numROI; i++)
	
		{
			
			roiManager("select", i);
			selectWindow(thresholdTitle);
			roiManager("select", i);
			run("Set Measurements...", "area mean standard redirect=None decimal=0");
			selectWindow(thresholdTitle);
			roiManager("select", i);
			run("Measure");
			
			Area[i] = getResult("Area",0);
			SD[i] =getResult("StdDev",0);
			
			
			//write(Area[i]);
			//waitForUser("Summary");
			
			roiManager("select", i);
			run("8-bit");
			run("8-bit");
			
			run("Analyze Particles...", "size=[20-Infinity]  circularity=[0.00-1.00] show=[Overlay Masks] display include summarize add"); // runs the actual anaylsis of the tracer (size= [xxx-Infinity] xxx = minimum pixel area to be counted
			
			//retrieves information from the summary window
			selectWindow("Summary");
			lines = split(getInfo(), "\n"); 
			headings = split(lines[0], "\t"); 
			values = split(lines[lengthOf(lines)-1], "\t");
			selectWindow("Summary"); 
			
			blackCoverage[i]= values[1]; //values[1] is the number of counted cells blackCoverage
			selectWindow(thresholdTitle);
			roiManager("deselect");
			run("Clear Results");
		}
	}
	
	Array.show(blackCoverage);
	
	for (jk = 0; jk <numROI; jk++)
	{
		//jj = jk + 1; // as ROI displayed numbers are 1 indexed not zero, this corrects for that
		write("TracerCoverage("+jk+")=" +TracerPecentageCover[jk]);
		write("Cells counted in ROI("+jk+")=" +blackCoverage[jk]);
	
	}
	
selectWindow(thresholdTitle);
run("Invert LUT");

//creates stack image of the thresholded image, with what is detected in the analysis 
run("Images to Stack", "name=Stack title=[] use");
roiManager("Show All with labels");

waitForUser("If happy with ROI detection, press OK to save");

dir = getDirectory(thresholdTitle);
fullpath = dir+"Stack_"+ROITitle;
save(fullpath);

waitForUser("Press OK to close all windows");

//closes all images
while (nImages>0) 
 { 
    selectImage(nImages); 
    close(); 
 }
 // closes all non-image windows
 list = getList("window.titles");
 
     for (i=0; i<list.length; i++)
	{ 
     winame = list[i]; 
     	selectWindow(winame); 
     run("Close"); 
    } 
 
 
