function J = adjoint(T)
    
    if isa(T, 'se3')
        t = T.trvec;
        R = T.rotm;
    elseif ismatrix(T) && all(size(T) == [4 4])
        t = tform2trvec(T);
        R = tform2rotm(T);
    end
		
    J = [
        R                    zeros(3,3)
        (vec2skew(t)*R)      R
        ];

end