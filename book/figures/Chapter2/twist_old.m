% 'R', dir, point
% 'R', dir, point, pitch (shift per revolution
% 'P', dir
% T -> twist
% 4x4 -> twist
% twist -> 4x4
function tw = twist(T, dir, point, pitch)
    if ishomog(T)
        if T(4,4) == 1
            % its a homog matrix, take the logarithm
            S = trlog(T);
            tw = twist(S);
        else
            % its a 4x4 augmented skew matrix
            [skw,v] = tr2rt(T);
            tw = [v; vex(skw)]';
        end
    elseif isvec(T, 6)
        % its a 6-vector, make a 4x4 augmented skew matrix
        v = T(1:3); w = T(4:6);
        tw = [skew(w) v'; 0 0 0 0];
    elseif ischar(T)
        switch upper(T)
            case 'R'
                
                w = unit(dir(:));
                v = -cross(w, point(:));
                if nargin >= 4
                    v = v + pitch * w;
                end
            case 'P'
                w = [0 0 0]';
                v = unit(dir(:));
                
        end
        
        tw = [v; w]';
    end
end
