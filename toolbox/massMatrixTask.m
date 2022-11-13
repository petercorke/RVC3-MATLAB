% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function Mx = massMatrixTask(robot, q)
	J = robot.geometricJacobian(q, robot.Bodies{end}.Name);
	Ji = inv(J);                %#ok<*MINV>
	M = robot.massMatrix(q);
	Mx = Ji' * M * Ji;
end