%--------------------------------------------------------------------------
%Workspace clean-up

clc;    %Clear the command window.
close all;  %Close all figures (except those of imtool).
clear;  %Erase all existing variables from workspace.
clearvars; %Remove all stored variables from memory.
clear classes;
%--------------------------------------------------------------------------

%DATASET SELECTOR
dataset = 'dataset';
num_images = 71;

%TASK SELECTOR
%Select which task you want the code to accomplish:
% 1 --> Marble Detection
% 2 --> Tracking
% 3 --> Evaluation
task = 1;

%DIFFERENCE THRESHOLD
diffThreshold = 4;

%BACKGROUND IMAGE
backgroundImage = myImage(dataset,'1');
%Read background image
backgroundImage = backgroundImage.readImage();

%----------------------------Task 1----------------------------------------
if (task == 1)
    % Pre-process images and then attempt to find the difference between
    %images and the background.
    
    backgroundImage.normalized = rgbnormalize(backgroundImage.data);
    
    %Initialize target iamge
    image = myImage(dataset,'17');
    image = image.readImage();
    image.normalized = rgbnormalize(image.data);
    
    %Find the difference in values between the two images
    diffValues = sum(abs(backgroundImage.normalized - image.normalized), 3);
    
    %Matrix to hold resulting background subtracted image
    diffImage = uint8(zeros(image.height, image.width, 3));
    binaryDiff = zeros(image.height, image.width);
    
    %Populate difference matrices
    for iColumn = 1 : image.width
        for iRow = 1 : image.height
            
            %If value greater than threshold, that means a non-background
            %object was detected.
            if diffValues(iRow, iColumn) >= diffThreshold
               %Store results in both unit8 format and binary format
               diffImage(iRow, iColumn, :) = ...
                    image.normalized(iRow, iColumn, :);
               binaryDiff(iRow, iColumn) = 1;
            end
        end
    end
    
    imshow(binaryDiff);
end
    
%----------------------------Task 2----------------------------------------
if (task == 2)
end
    
%----------------------------Task 3----------------------------------------
if (task == 3)
end