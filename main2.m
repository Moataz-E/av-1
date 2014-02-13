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
task = 1;

%DIFFERENCE THRESHOLD
diffThreshold = 40;

%MAX MARBLE CORRESPONDENCE
maxDifference =  30;

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
        image.number = 25;
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

%         for marble = 1 : size(image.marbles,2)
%            display(image.marbles(marble).ID);
%         end
%         subplot(2,2,1), imshow(image.data);
%         subplot(2,2,2), imshow(image.preprocessed);
%         subplot(2,2,3), imshow(image2.preprocessed);
        imshow(finalImage);
        pause(40);
        
        prevImage = image;
    end
end
    
%----------------------------Task 2----------------------------------------
if (task == 2)
    
    %Initialize image to contain track of each marble
    track_image = backgroundImage.data;
    
    %Array of colours
    colours = ['y'];
    
    current_colour = 1;
    
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

        %Draw line between marbles identified as having the same ID between
        %frames
        for marble = 1 : size(image.marbles,2)
            for prevMarble = 1 : size(prevImage.marbles,2)
                
                if (image.marbles(marble).ID == prevImage.marbles(prevMarble).ID)
                    
                    if isempty(prevImage.marbles(prevMarble).colour)
                        %Assign marble a coloured track
                        image.marbles(marble).colour = colours(current_colour);
                        %Increment next colour. Start again at zero if we run
                        %out of colours in the array
                        current_colour = mod(current_colour, 1) + 1;
                    end

                    track_image = drawLine(track_image, image.marbles(marble).com, ...
                        prevImage.marbles(prevMarble).com, ...
                        colours(current_colour), 1000);
                end
            end
        end
        
        prevImage = image;
    end
    imshow(track_image);
end