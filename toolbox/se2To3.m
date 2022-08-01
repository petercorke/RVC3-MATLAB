function s3 = se2To3(s2)
%se2To3 Convert se2 to se3 object

s3 = se3(blkdiag(s2.rotm, 1), [s2.trvec 0]);

end

