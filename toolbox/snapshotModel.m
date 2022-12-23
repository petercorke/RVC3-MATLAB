%snapshotModel Create and display a snapshot of Simulink model "model"
%   This can be useful, e.g. for including a snapshot in a LiveScript.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function snapshotModel(model)

open_system(model)
import slreportgen.report.*
r = Report(tempname, 'html');
D = Diagram(model);
D.SnapshotFormat = 'png';
add(r, D);
imshow(imread(D.Snapshot.Image.Content.Path));
close(r);
delete(r.OutputPath);
end