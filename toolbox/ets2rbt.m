function rbt = ets2rbt(ets)
% Works for both ETS2 and ETS3 

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

%TODO
% - Error checking
% - Combine ETS3 fixed and revolute joints

rbt = rigidBodyTree(DataFormat="row");

% Iterate through object array and create links and joints
linkIdx = 1;
fixedIdx = 1;
numLinks = length(ets);
links = cell(1,numLinks);

for i = 1:numLinks
    e = ets(i);

    links{i} = rigidBody("link" + string(linkIdx));

    if e.isjoint
        % This is an articulated joint.
        jointName = "q" + string(e.qvar);
        if e.isprismatic
            % This is a prismatic joint
            links{i}.Joint = rigidBodyJoint(jointName, "prismatic");
            switch string(e.what)
                case "Tx"
                    links{i}.Joint.JointAxis = [1 0 0];
                case "Ty"
                    links{i}.Joint.JointAxis = [0 1 0];
                case "Tz"
                    links{i}.Joint.JointAxis = [0 0 1];
            end            
        else
            % This is a revolute joint
            links{i}.Joint = rigidBodyJoint(jointName, "revolute");
            switch string(e.what)
                % Add collision bodies for visualization purposes
                case "Rx"
                    links{i}.Joint.JointAxis = [1 0 0];
                    links{i}.addCollision("cylinder", [0.03, 0.06], ...
                        se3(eul2tform([0 pi/2 0], "xyz")).tform);
                case "Ry"
                    links{i}.Joint.JointAxis = [0 1 0];
                    links{i}.addCollision("cylinder", [0.03, 0.06], ...
                        se3(eul2tform([pi/2 0 0], "xyz")).tform);
                case "Rz"
                    links{i}.Joint.JointAxis = [0 0 1];
                    links{i}.addCollision("cylinder", [0.03, 0.06]);
            end                 
        end                
    else
        % This is a fixed translation.
        % Use a fixed joint by default.
        jointName = "fixed" + string(fixedIdx);
        links{i}.Joint = rigidBodyJoint(jointName, "fixed");
        switch string(e.what)
            case "Tx"
                links{i}.Joint.setFixedTransform(...
                    se3(trvec2tform([e.param 0 0])).tform);
                links{i}.addCollision("cylinder", [0.025, abs(e.param)]);
            case "Ty"
                links{i}.Joint.setFixedTransform(...
                    se3(trvec2tform([0 e.param 0])).tform)
                links{i}.addCollision("cylinder", [0.025, abs(e.param)], ...
                     trvec2tform([0,-e.param/2,0]) * ...
                     se3(eul2tform([pi/2 0 0], "xyz")).tform);
            case "Tz"
                links{i}.Joint.setFixedTransform(...
                    se3(trvec2tform([0 0 e.param])).tform);
                links{i}.addCollision("cylinder", [0.025, abs(e.param)], ...
                    trvec2tform([0,0,-e.param/2]));
        end
        fixedIdx = fixedIdx + 1;
    end

    linkIdx = linkIdx + 1;
end

for i = 1:numLinks
    if i == 1
        parentName = rbt.BaseName;
    else
        parentName = links{i-1}.Name;
    end
    rbt.addBody(links{i}, parentName);
end

end