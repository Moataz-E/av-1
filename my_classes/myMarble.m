classdef myMarble
    %MYMARBLE Class representing an individual marble
%-------------------------------------------------------------------------- 
    properties
        
        %Identification number of marble
        ID;
        
        %Center of mass of the marble
        centerOfMass;
        
        %2D histogram of the r/g components from normalised RGB values
        histogram;

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
        
        function obj = assignCOM(obj, centerOfMass)
        %Assign a center of mass linear coordinate to this marble
            
            obj.centerOfMass = centerOfMass;
        end
        
        function obj = generateHistogram(obj, image)
        %Given an RGB image and this marble with an assigned center of
        %mass, generate a histogram that identifies this marble.
        
        end
    end
    
end

