%--------------------------------------------------------------------------
%Workspace clean-up

clc;    %Clear the command window.
close all;  %Close all figures (except those of imtool).
clear;  %Erase all existing variables from workspace.
clearvars; %Remove all stored variables from memory.
clear classes; %Remove all stored class objects.
%--------------------------------------------------------------------------
%Add classes and functions to path
addpath('my_classes', 'my_functions', 'saved_variables');
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

%MAX MARBLE CORRESPONDENCE
maxDifference =  25;

%BACKGROUND IMAGE
backgroundImage = myImage();
backgroundImage.dataset = dataset;
backgroundImage.number = 1;
backgroundImage = backgroundImage.generatePath();
backgroundImage = backgroundImage.readImage();

%----------------------------Task 1----------------------------------------
if (task == 1)
    
    track_image = backgroundImage.data;
    
    for imageNum = 1 : num_images
        
        %Initialize target image
        image = myImage();
        image.dataset = dataset;
        image.number = imageNum;
        image = image.generatePath();
        image = image.readImage();

        %Perform background subtraction on image
        image = image.removeBackground(backgroundImage.data, diffThreshold);
        
        %If this is the first image, use it as the previous image in
        %marble tracking
        if (imageNum == 1)
            prevImage = myImage();
            prevImage.dataset = dataset;
            prevImage.number = imageNum;
            prevImage = prevImage.generatePath();
            prevImage = prevImage.readImage();
            prevImage = prevImage.removeBackground(backgroundImage.data, ...
                diffThreshold);
            prevImage = prevImage.identifyMarbles();
        end 
        
        %Identify location of marbles in image
        image = image.identifyMarbles();
        image = image.locateClosestMarble(prevImage, maxDifference);
        
        %Initialize target image
        image2 = myImage();
        image2.dataset = dataset;
        image2.number = imageNum;
        image2 = image2.generatePath();
        image2 = image2.readImage();

        %Perform background subtraction on image
        image2 = image2.removeBackground(backgroundImage.data, diffThreshold);

        %Identify location of marbles in image
        image2 = image2.identifyMarbles();

        %Initialize final image to be 30labeled and displayed
        finalImage = image.data;
        finalImage2 = image2.data;

        %Radius of circles to draw around identified marbles
        radius = 10;

        %Draw circles around each of the detected marbles. Radius of each 
        %circle is 10 pixels
        for marble = 1 : size(image.marbles,2)
            finalImage = drawCircle(finalImage,image.marbles(marble).com, ...
                radius,'r',1000);
            
            for prevMarble = 1 : size(prevImage.marbles,2)
                
                if (image.marbles(marble).ID == prevImage.marbles(prevMarble).ID)
                    track_image = drawLine(track_image, image.marbles(marble).com, ...
                        prevImage.marbles(prevMarble).com, 'r', 1000);
                end
            end
        end
        for marble = 1 : size(image2.marbles,2)
            finalImage2 = drawCircle(finalImage2,image2.marbles(marble).com, ...
                radius,'r',1000);
        end

%         for marble = 1 : size(image.marbles,2)
%            display(image.marbles(marble).ID);
%         end
        %Plot results
%         subplot(2,2,1), imshow(image.data);
%         subplot(2,2,2), imshow(image.preprocessed);
%         subplot(2,2,3), imshow(image2.preprocessed);
%         imshow(finalImage);
%         pause(1);
        
%         subplot(2,3,6), imshow(finalImage2);
        
        prevImage = image;
    end
    imshow(track_image);
    
end
    
%----------------------------Task 2----------------------------------------
if (task == 2)
end
    
%----------------------------Task 3----------------------------------------
if (task == 3)
end