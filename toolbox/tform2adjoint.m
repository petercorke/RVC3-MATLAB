%TFORM2ADJOINT Adjoint of SE(3) matrix
% 
% A = TFORM2ADJOINT(T) is the adjoint matrix for the SE(n) matrix T.
%
% If T is 3x3 then A is 3x3
% If T is 4x4 then A is 6x6

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

function a = tform2adjoint(T)

    if isa(T, 'se3')
        R = T.rotm();
        t = T.trvec();
    else
        R = tform2rotm(T);
        t = tform2trvec(T);
    end
    % 
    % if all(size(T) == [3 3])
    %     a = [
    %         R    [t(2); -t(1)]
    %         0 0  1            ];
    % elseif all(size(T) == [4 4])
    %     a = [
    %         R              zeros(3)
    %         vec2skew(t)*R  R          ];
    % else
    %     error("RVC3:tform2adjoint", "T must be SE(2) or SE(3)")
    % end

     a = [
                R              zeros(3)
                vec2skew(t)*R  R          ];
end




