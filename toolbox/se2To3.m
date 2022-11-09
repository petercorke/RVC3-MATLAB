function s3 = se2To3(s2)
%se2To3 Convert se2 to se3 object

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

s3 = se3(blkdiag(s2.rotm, 1), [s2.trvec 0]);

end

