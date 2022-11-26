d = 45e-3;
x0 = -0.2; y0 = 4.5*d;
z0 = 0;

dx = 4*d*[-1 -1 0 1 1];
dy = 4*d*[-1 1  0 1 -1];

mdl_mico

mm = [];
for X=0:0.02:0.3
    for Z=-0.2:0.025:0.2
        for i=1:length(dx)
            T = se3(eye(3), [X+dx(i), dy(i), Z]) * se3(rotmx(pi));
            [qq,e]= mico.ikunc(T);
            if e < 0.001
            m(i) = mico.maniplty(q);
            else
                m(i) = 0;
            end
        end
        
        mm = [mm; X Z min(m)];
    end
end

