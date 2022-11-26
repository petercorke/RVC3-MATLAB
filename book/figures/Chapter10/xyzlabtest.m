for lambda = [400:50:700]*1e-9
    XYZ = cmfxyz(lambda);
    %XYZ = unit(XYZ);
    
    a = xyz2lab(XYZ);
            b = xyz2lab(XYZ .* [1 0.25 1]);

    c = colorspace('XYZ->Lab', XYZ);
        d = colorspace('XYZ->Lab', XYZ.* [1 0.25 1]);

        XYZ
    [a;c;b;d]
    fprintf('\n')
end