classdef PoseGraphAccess < nav.algs.internal.InternalAccess
    %POSEGRAPHACCESS Internal class to get access to internal poseGraph functionality
    
    properties (Access=private)
        PoseGraph
    end
    
    methods
        function obj = PoseGraphAccess(pg)
            obj.PoseGraph = pg;
        end
        
        function updateNodeEstimates(obj, estimates)
            obj.PoseGraph.updateNodeEstimates(estimates);
        end
    end
end

