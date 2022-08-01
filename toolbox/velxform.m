function J = velxform(T)
    
    if isa(T, 'se3')
        R = T.rotm;
    elseif ismatrix(T) && all(size(T) == [4 4])
        R = tform2rotm(T);
    end
		
    J = [
        R              zeros(3,3)
        zeros(3,3)     R
        ];
end