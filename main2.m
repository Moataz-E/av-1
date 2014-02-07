%--------------------------------------------------------------------------
%Workspace clean-up

clc;    %Clear the command window.
close all;  %Close all figures (except those of imtool).
clear;  %Erase all existing variables from workspace.
clearvars; %Remove all stored variables from memory.
clear classes; %Remove all stored class objects.
%--------------------------------------------------------------------------

%DATASET SELECTOR
dataset = 'dataset';

%NUMBER OF IMAGES
num_images = 71;

%TASK SELECTOR
%Select which task you want the code to accomplish:
% 1 --> Marble Detection
% 2 --> Tracking
% 3 --> Evaluation
task = 1;

%DIFFERENCE THRESHOLD
diffThreshold = 40;

%BACKGROUND IMAGE
backgroundImage = myImage(dataset,'1');
%Read background image
backgroundImage = backgroundImage.readImage();

%----------------------------Task 1----------------------------------------
if (task == 1)
    % Pre-process images and then attempt to find the difference between
    %images and the background.
    
    backgroundImage.normalized = rgbnormalize(backgroundImage.data);
    
    %Initialize target image
    image = myImage(dataset,'11');
    image = image.readImage();
    image.normalized = rgbnormalize(image.data);

    %Perform background subtraction on image
    [diffImage, binaryDiffImage] = sub_background(backgroundImage.data, ...
                                    image.data, diffThreshold);
    
    %Create disk image structuring with radius 3
    se = strel('disk',4)';
    %Image opening to remove small noisy circles
    resultImage = imopen(binaryDiff, se);

	CC = bwconncomp(resultImage);
    display(CC.PixelIdxList);
    
    imshow(resultImage);
end
    
%----------------------------Task 2----------------------------------------
if (task == 2)
end
    
%----------------------------Task 3----------------------------------------
if (task == 3)
end