classdef myMarble
    %MYMARBLE Class representing an individual marble
%-------------------------------------------------------------------------- 
    properties
        
        %Identification number of marble
        ID;
        
        %Center of mass of the marble
        com;
        
        %2D histogram of the r/g components from normalised RGB values
        histogram;
        
        %Sum of red and blue values in this marble's center
        sumRB;
        
        %Colour used to track marble
        colour;
        
        %Speed at which marble is travelling. This is basically the
        %distance travelled per frame
        speed;

    end
%--------------------------------------------------------------------------    
    methods
        
        
        function obj = myMarble()
        %Class constructor.
        end
        
        function obj = assignID(obj, ID)
        %Assign an ID to this marble
        
            obj.ID = ID;
        end
        
        function obj = assignCOM(obj, com)
        %Assign a center of mass linear coordinate to this marble
            
            obj.com = com;
        end
        
        function obj = calculateSumRB(obj, image)
        %Given an RGB image and this marble with an assigned center of mass
        %calculate the sum of red and green values
        
            marbleX = round(obj.com(1));
            marbleY = round(obj.com(2));
            obj.sumRB = double(image(marbleY, marbleX, 1)) + ...
                            double(image(marbleY, marbleX, 3));
        end
    end
    
end

