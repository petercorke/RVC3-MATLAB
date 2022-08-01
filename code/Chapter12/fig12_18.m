clf
surfl(318:408, 550:622, m(318:408,550:622)')
colormap(bone)
shading interp
xlabel('u')
ylabel('v')

xaxis(318,408)
yaxis(550,622)
zlabel('edge magnitude')
view(104, 61)
rvcprint('opengl')