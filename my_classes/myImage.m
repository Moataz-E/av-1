classdef myImage
    %IMAGEHANDLE Class representing individual image frames
%--------------------------------------------------------------------------
    properties
        
        %Dataset to which image belongs
        dataset
        
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
        
        %Stores normalized image pixel values
        normalized; 
    end 
%--------------------------------------------------------------------------    
    methods
        
        function obj = myImage(img_dataset, img_number)
        %Class construtor, initialized with the name of the dataset to
        %which it belongs and its number in that dataset. It uses those
        %parameters to generate the path.
        
            if (nargin > 0)
                obj.dataset = img_dataset;
                obj.number = img_number;
                obj = obj.generatePath;
            end    
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
    end  
end

