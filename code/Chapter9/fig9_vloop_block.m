bdclose all; clear;
close all; clear;

open_system("roblocks")
open_system("roblocks/Joint vloop", "force")
rvcprint("simulink", "Joint vloop");


