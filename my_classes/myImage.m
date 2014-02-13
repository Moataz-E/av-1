classdef myImage
    %IMAGEHANDLE Class representing individual image frames
%--------------------------------------------------------------------------
    properties
        
        %Dataset to which image belongs
        dataset;
        
        %Image number in the dataset
        number;
        
        %Path to image
        path;
        
        %Pre-defined image height and width
        height = 480;
        width = 640;
        
        %Stores image pixel information in a heightxwidthx3 variable,
        %values are in uint8 format
        data;
        
        %Stores preprocessed version of the image
        preprocessed;
        
        %Background subtracted version of this image
        diff;
        
        %Binary version of the background subtracted image
        binaryDiff;
        
        %Connected components object of this image
        CC;
        
        %Array containing marble objects currently in the image.
        %Initialized to a pre-defined maximum marbles per image.
        marbles;
    end 
%--------------------------------------------------------------------------    
    methods
        
        function obj = myImage()
        %Class construtor. Avoid requiring initialization parameters for
        %greater flexibility
        
             obj.marbles = myMarble.empty(18, 0);
        end
              
        function obj = generatePath(obj)
        %Given a number, this function returns the corrosponding image
        %name. dataset should be the name of the dataset's directory

        
                %Convert image number to string in preperation for
                %concatination.
                str_number = num2str(obj.number);

                %Generate name for image path
                obj.path = strcat(obj.dataset,'/',str_number,'.jpg');
        end
        
        function obj = readImage(obj)
        %Reads image information and stores it in this object, returns
        %error if image path not generated yet.

                obj.data = imread(obj.path);
        end
        
        function obj = removeBackground(obj, background, threshold)
        %Given a background and a threshold, perform background subtraction
        %on this image to obtain the resulting rgb and binary versions.
        
        [obj.diff, obj.binaryDiff] = sub_background(background, ...
                                        obj.data, threshold);
        end

        function obj = identifyMarbles(obj)
        %Attempts to identify all marbles in this image. Image must have
        %background subtracted versions removed first. Stores list of
        %marble objects in this image. Marbles are given an ID starting
        %with the frame's number as the prefix.
        
        %for each conencted component, find the center of mass,inialize
        %a marble component, add it to the array marbles.
        
            %Make sure background subtracted versions of image exist
            if (isempty(obj.diff) || isempty(obj.binaryDiff))
                error('Remove background from image first!');
            else
                
                %Create disk image structuring with radius 3
                se = strel('disk',3);
                
                %Apply image open and store in this image's preprocess 
                %variable
                obj.preprocessed = imopen(obj.binaryDiff, se);
                
                %Find connected components
                obj.CC = bwconncomp(obj.preprocessed);

                %Find center of mass of all marbles
                com = regionprops(obj.CC,'Centroid', 'Area', 'PixelList');

                %Loop through each connected components, identifying and
                %initializing marble objects
                id = 1; 
                for cc = 1 : size(obj.CC.PixelIdxList, 2)
                    % If the area is too big, assume the connected
                    % component might represent two/more collidin balls.
                    area = com(cc).Area;
                    if area > 400
                       % Do histogram.
                       pixel_list = com(cc).PixelList;
                       [a,~] = size(pixel_list);
                       bw_img = zeros(obj.height, obj.width);
                       
                       for iter = 1 : a
                           bw_img(pixel_list(iter, 2), pixel_list(iter, 1)) = ...
                                sum(obj.data(pixel_list(iter, 2), pixel_list(iter, 1), :)) / 3;
                       end
                       
                       bw_array = reshape(bw_img, obj.height*obj.width, 1);
                       bw_array(bw_array==0) = [];
                       first_hist = hist(bw_array, 50);
                       
                       filter = gausswin(50, 6);
                       filter = filter/sum(filter);
                       smooth_hist = conv(filter,first_hist);
                       
                       % Find the valley between the two highest peaks.
                       inv_hist = 1.01*max(smooth_hist) - smooth_hist;
                       [~, locsmin] = findpeaks(inv_hist);
                       
                       % Distribute points between the peaks.
                       if (length(locsmin) == 1)
                           tresh = locsmin;
                           bin1x = 0;
                           bin1y = 0;
                           bin2x = 0;
                           bin2y = 0;
                           sum1num = 0;
                           sum2num = 0;
                           for iter = 1 : a
                               aux = sum(obj.data(pixel_list(iter, 2), pixel_list(iter, 1), :)) / 3;
                               if (aux > tresh)
                                   sum1num = sum1num + 1;
                                   bin1x = bin1x  +pixel_list(iter, 2);
                                   bin1y = bin1y  +pixel_list(iter, 1);
                               else
                                   sum2num = sum2num + 1;
                                   bin2x = bin2x  +pixel_list(iter, 2);
                                   bin2y = bin2y  +pixel_list(iter, 1);
                               end 
                           end
                           
                           if (sum1num > 0)
                                bin1x = bin1x / sum1num
                                bin1y = bin1y / sum1num
                           end
                           
                           if (sum2num > 0)
                                bin2x = bin2x / sum2num
                                bin2y = bin2y / sum2num
                           end
                          
                           dist = ((bin2x - bin1x)^2 + (bin2y - bin1y)^2)^0.5;
                           
                           if (dist > 8 && sum2num > 0 && sum1num)
                               marble = myMarble();
                               marble = marble.assignID((obj.number*100) + id);
                               marble = marble.assignCOM([bin1y, bin1x]);
                               obj.marbles(id) = marble;
                               id = id + 1;

                               marble = myMarble();
                               marble = marble.assignID((obj.number*100) + id);
                               marble = marble.assignCOM([bin2y, bin2x]);
                               obj.marbles(id) = marble;
                               id = id + 1;   
                           else
                               marble = myMarble();
                               marble = marble.assignID((obj.number*100) + id);
                               marble = marble.assignCOM([(bin1y+bin2y)/2, (bin1x+bin2x)/2]);
                               obj.marbles(id) = marble;
                               id = id + 1;
                           end
                       end
                    else
                        %Marble id is the number of the image at which it was
                        %identified concatenated to the order at which it is
                        %identified in a given image
                        marble = myMarble();
                        marble = marble.assignID(obj.number*100 + id);


                        %Assign the center of mass of marble
                        marble = marble.assignCOM(com(cc).Centroid);

                        %Loop through each existant marble object and check for
                        %duplicate ID.
                        for marbleNum = 1 : size(obj.marbles,2)

                            if (marble.ID == obj.marbles(marbleNum).ID)
                                error('Marble with that ID already exists!');
                            end
                        end
                        %Add this marble to our list of detected marbles
                        obj.marbles(id) = marble;
                        id = id + 1;
                    end
                    
                end
                
            end
        
        end
    end  
end

