classdef classbug
    methods
        function b = bob(a, b)
            disp('in bob')
        end
    end
        methods(Static)
            function b = factory(a);
                disp('in classbug.factory')
                if nargin > 0
                    disp(a)
                end
                b=classbug(); % call the constructor
            end
        end
end