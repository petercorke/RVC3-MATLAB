function qj = ikineTraj(ikFcn, Ts)

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

qsol = ikFcn(Ts(1).tform);
qj = zeros(length(Ts), size(qsol,2));
qj(1,:) = qsol(1,:);
for i = 2:length(Ts)
    qsol = ikFcn(Ts(i).tform,true,true, qj(i-1,:));
    qj(i,:) = qsol(1,:);
end

end