close all
clear

abb = loadrobot("abbIrb1600", DataFormat="row");
waypts = [...
   -0.6856    0.9498; ...
    1.0453    1.0696; ...
    0.1603    0.2984; ...
   -0.3843   -0.5796; ...
    0.2956    1.3092; ...
    2.8201    4.5907];

t = 0:0.02:2;

[q,qd,qdd] = quinticpolytraj(waypts, [0 2], t);

figure
r = rateControl(50);
for i = 1:15:size(q,2)
   % Plot every 15th trajectory configuration, preserving each one in plot
   abb.show(q(:,i)', PreservePlot=true);
   hold on

   % Also label each configuration
   eePose = abb.getTransform(q(:,i)', "tool0");
   eeT = se3(eePose).trvec;
   if i == 1 || i == 91
       yScale = 1.2;
   else
       yScale = 1.0;
   end
   text(eeT(1) + 0.1, eeT(2)*yScale, eeT(3) - 0.1, "q_{" + num2str(i) + "}", "FontSize", 16, "Interpreter","tex")
   r.waitfor;
end

% Adjust axes limits and view
xlim([-0.5 1])
ylim([-0.75 0.75])
zlim([-0.1 1])

view(105,11.7)
set(gcf, "Position", [1000 829 718 509])
set(gca, "CameraViewAngle", 7.2022)

camlight

rvcprint("opengl")