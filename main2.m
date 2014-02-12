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
backgroundImage = myImage();
backgroundImage.dataset = dataset;
backgroundImage.number = 1;
backgroundImage = backgroundImage.generatePath();
backgroundImage = backgroundImage.readImage();

%----------------------------Task 1----------------------------------------
if (task == 1)
    
    %Initialize target image
    image = myImage();
    image.dataset = dataset;
    image.number = 60;
    image = image.generatePath();
    image = image.readImage();

    %Perform background subtraction on image
    image = image.removeBackground(backgroundImage.data, diffThreshold);
    
    %Identify location of marbles in image
    image = image.identifyMarbles();
    
    %Initialize final image to be labeled and displayed
    finalImage = image.data;
    
    %Radius of circles to draw around identified marbles
    radius = 10;

    %Draw circles around each of the detected marbles. Radius of each 
    %circle is 10 pixels
    for marble = 1 : size(image.marbles,2)
        finalImage = drawCircle(finalImage,image.marbles(marble).com, ...
            radius,'r',1000);
    end
    
    %Plot results
    subplot(2,2,1), imshow(image.data);
    subplot(2,2,2), imshow(image.preprocessed);
    subplot(2,2,3), imshow(finalImage);
    
end
    
%----------------------------Task 2----------------------------------------
if (task == 2)
end
    
%----------------------------Task 3----------------------------------------
if (task == 3)
end