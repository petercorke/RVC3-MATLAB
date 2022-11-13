%RVCTOOLBOXROOT returns the root folder name for the RVC Toolbox

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function rootdir = rvctoolboxroot

  rootdir = fileparts(which("rvctoolboxroot"));
  
