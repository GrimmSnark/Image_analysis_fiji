// Michael Savage 11/01/2015
// This macro runs preanaylsis for a tracing picture
// Includes Gaussian blur and split&separation of colour channels and saving

filename = getTitle();
output = getDirectory("image");
run("Set Scale...", "distance=617 known=200 pixel=1 unit=um"); // You may or may not want to properly set the scales for the images (distance in pixels, known distance in real life, pixel aspect ratio (1), unit of length (see macro website for ImageJ)
run("Gaussian Blur...", "sigma=1.5"); // may need to change sigma size to get the right level of filtering of artefacts 
run("Split Channels"); // Splits channels into red, green, blue and grayscales them 

selectImage("C1-"+filename);
close(); // deletes red channel
selectImage("C3-"+filename);
close(); // deletes blue channel, may need to personalise for dataset
run("8-bit");
run("8-bit");

if (endsWith(filename, "TIF")==1 || endsWith(filename, "tif") == 1 ) // if filename ends in 'TIF' or 'tif' savers files as .tif. otherwise saves as .jpeg
{
saveAs("tiff", output +filename +"_gray");
}
else
{
saveAs("jpeg", output +filename +"_gray");
}
print(filename +" has been processed and saved"); // outputs current image name and that is has been processed succesfully