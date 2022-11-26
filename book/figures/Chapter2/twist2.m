% 'R', point
% 'P', dir

function tw = twist2(T, arg)
    if ishomog2(T)
        if T(3,3) == 1
            % its a homog matrix, take the logarithm
            S = logm(T);
            tw = twist2(S);
        else
            % its a 3x3 augmented skew matrix
            [skw,v] = tr2rt(T);
            tw = [v; vex2(skw)]';
        end
    elseif ischar(T)
        switch upper(T)
            case 'R'
                point = [arg(:); 1];
                v = -cross([0 0 1]', point);
                v = v(1:2);
                w = 1;
            case 'P'
                dir = arg(1:2);
                w = 0;
                v = unit(dir(:));
                
        end
            tw = [v; w]';
    end
    

end