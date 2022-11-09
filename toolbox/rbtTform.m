function rbtTransformed = rbtTform(rbt, T)
%rbtTform Add a base transform to a rididBodyTree 
%  T is assumed to be an SE3 object

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

rbtTransformed = rigidBodyTree(DataFormat=rbt.DataFormat);
rb = rigidBody("base_tform");
rb.Joint.setFixedTransform(T.tform);
rbtTransformed.addBody(rb, "base");
rbtTransformed.addSubtree("base_tform", rbt);

end