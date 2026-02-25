classdef tChapter10 < RunMLX & RVCTest
    %tChapter10 Unit tests for chapter 10 book code
    %   The RunMLX base class will automatically run the MLX code in the
    %   "MLXFile" property and ensure there are no errors.
    %
    %   The RVCTest base class ensures that all the RVC Toolbox code is
    %   available.
    % 
    %   Add additional unit tests for this chapter in the methods(Test) 
    %   section.

    % Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

    properties
        %MLXFile - Name of MLX file to test
        %   This property is declared in the RunMLX base class.
        MLXFile = "chapter10.mlx"
    end

    % Additional test points for the chapter

    % Unit test for Chapter 10 code. How was it made?
    % 1. Run tex2m on the chapter
    % 2. Turn it into the test by encoding expected results and proverbially
    % casting them in stone
   
    methods (Test)
        function fixToBugInCh11(testCase)
            %fixToBugInCh11 Lock down spectral representation of light
            me = [];
            try
                lambda = [300:10:1000]*1e-9;
                for T=3000:1000:6000
                    plot(lambda,blackbody(lambda,T)), hold on
                end
                hold off
                close all
            catch me
                % do nothing
            end

            testCase.assertEmpty(me);
        end

        function blackbodyLampSun(testCase)
            %blackbodyLampSun Lock down blackbody outputs
            lambda = [300:10:1000]*1e-9;

            % lamp = blackbody(lambda,2600);
             actLamp = blackbody(lambda,2600);
             expLamp = [477966081.705934;735549302.085631;1096317170.506;1587447912.43067;2239084275.44528;...
                 3083762274.88966;4155707059.23218;5490034474.93983;7121900045.97594;9085636710.2543;...
                 11413919440.0936;14136989605.048;17281965407.5651;20872257651.4941;24927103081.8081;...
                 29461221007.1008;34484593186.5125;40002362202.5814;46014839816.7857;52517614098.5621;...
                 59501742356.2466;66954015967.5586;74857282976.3537;83190814654.1369;91930702986.1902;...
                 101050277110.929;110520528009.877;120310532123.66;130387865982.838;140719005333.381;...
                 151269703562.155;162005345457.381;172891273453.31;183893084496.484;194976896529.292;...
                 206109584316.705;217258984949.7;228394073852.183;239485112507.25;250503769414.321;...
                 261423216002.228;272218199365.949;282865093776.898;293341932948.491;303628425029.204;...
                 313705952252.702;323557557106.095;333167916789.318;342523307636.47;351611561058.292;...
                 360422012447.736;368945444370.882;377174025246.006;385101244596.224;392721845847.727;...
                 400031757537.026;407028023687.991;413708734023.207;420072954584.631;426120659255.987;...
                 431852662603.605;437270554383.568;442376636000.683;447173859148.852;451665766812.359;...
                 455856436763.237;459750427650.737;463352727744.609;466668706364.152;469704067999.208;...
                 472464809107.345]; % I used mat2str to store this baseline
             
             testCase.verifyEqual(actLamp, expLamp, "AbsTol", 1e-3, ...
                 "Incorrect black body computation for lamp");

            
            % sun = blackbody(lambda,5778);
            actSun = blackbody(lambda,5778);
            expSun = [12180126466300.9;13513438558408.4;14821089835859.3;16088553465516.5;17303484983782.5;...
                18455737632957.3;19537293046955.4;20542131443994.5;21466061918110.7;22306529653559.2;...
                23062413278452.8;23733822331509.1;24321902033407.8;24828650254211.8;25256749728193.7;...
                25609417140400.8;25890269637727.3;26103208541362;26252319500622.8;26341787979615.8;...
                26375828764202.8;26358628080966.6;26294296902583.9;26186834051661.3;26040097789297.3;...
                25857784671397.9;25643414564646;25400320827417.1;25131644773485;24840333644442.6;...
                24529141418071.9;24200631873073.8;23857183415009.4;23500995243865.9;23134094510576.3;...
                22758344168539.8;22375451277291.3;21986975559615.8;21594338051280.1;21198829714836.7;...
                20801619916295.4;20403764686464.5;20006214707999.6;19609822985171.3;19215352166530.7;...
                18823481501420.2;18434813420007.1;18049879733516.1;17669147456885.7;17293024260400.8;...
                16921863560166.1;16555969259758.7;16195600157176.1;15840974032408.2;15492271431716.2;...
                15149639165084.2;14813193533395.1;14483023301742.8;14159192434967.9;13841742611046.5;...
                13530695527402.8;13226055014587.8;12927808971088;12635931132323.6;12350382686178.4;...
                12071113746683.6;11798064696770;11531167410305.9;11270346362968;11015519640844.9;...
                10766599855052.1];


            testCase.verifyEqual(actSun, expSun, "AbsTol", 1e-1, ...
                "Incorrect black body computation for sun");
        end


    % Ch 10 tex2m follows:
    % ---------------------
    % %% Spectral Representation of Light
    % lambda = [300:10:1000]*1e-9;
    % for T=3000:1000:6000
    %   plot(lambda,blackbody(lambda,T)), hold on
    % end
    % hold off
    % lamp = blackbody(lambda,2600);
    % sun = blackbody(lambda,5778);
    % plot(lambda, [lamp/max(lamp) sun/max(sun)])
    % %% Absorption
    % sunGround = loadspectrum(lambda,"solar");
    % plot(lambda,sunGround)
    % [A,lambda] = loadspectrum([400:10:700]*1e-9,"water");
    % d = 5;
    % T = 10.^(-A*d);
    % plot(lambda,T)
    % %% Reflectance
    % [R,lambda] = loadspectrum([100:10:10000]*1e-9,"redbrick");
    % plot(lambda,R)
    % %% Luminance
    % lambda = [400:700]*1e-9;
    % E = loadspectrum(lambda,"solar");
    % R = loadspectrum(lambda,"redbrick");
    % L = E.*R;
    % plot(lambda,L)
    % %% Color
    % human = luminos(lambda);
    % plot(lambda,human)
    % luminos(450e-9)/luminos(550e-9)
    % %% The Human Eye
    % cones = loadspectrum(lambda,"cones");
    % plot(lambda,cones)
    % %% Camera sensor
    % %% Measuring Color
    % lambda = [400:700]*1e-9;
    % E = loadspectrum(lambda,"solar");
    % R = loadspectrum(lambda,"redbrick");
    % L = E.*R;  % light reflected from the brick
    % cones = loadspectrum(lambda,"cones");
    % sum((L*ones(1,3)).*cones*1e-9)
    % %% Reproducing Colors
    % lambda = [400:700]*1e-9;
    % cmf = cmfrgb(lambda);
    % plot(lambda,cmf)
    % green = cmfrgb(500e-9)
    % white = -min(green)*[1 1 1]
    % feasible_green = green + white
    % rgbBrick = cmfrgb(lambda,L)
    % %% Chromaticity Coordinates
    % [r,g] = lambda2rg([400:700]*1e-9);
    % plot(r,g)
    % rg_addticks
    % hold on
    % primaries = lambda2rg(cie_primaries());
    % plot(primaries(:,1),primaries(:,2),"o")
    % plotSpectralLocus
    % green_cc = lambda2rg(500e-9)
    % plot(green_cc(:,1),green_cc(:,2),"kp")
    % white_cc = tristim2cc([1 1 1])
    % plot(white_cc(:,1),white_cc(:,2),"o")
    % cmf = cmfxyz(lambda);
    % plot(lambda,cmf)
    % [x,y] = lambda2xy(lambda);
    % plot(x,y)
    % plotChromaticity
    % lambda2xy(550e-9)
    % lamp = blackbody(lambda,2600);
    % lambda2xy(lambda,lamp)
    % %% Color Names
    % colorname("?burnt")
    % colorname("burntsienna")
    % bs = colorname("burntsienna","xy")
    % colorname("chocolate","xy")
    % colorname([0.2 0.3 0.4])
    % %% Other Color and Chromaticity Spaces
    % rgb2hsv([1 0 0])
    % rgb2hsv([0 1 0])
    % rgb2hsv([0 0 1])
    % rgb2hsv([0 0.5 0])
    % rgb2hsv([0.4 0.4 0.4])
    % rgb2hsv([0 0.5 0] + [0.4 0.4 0.4])
    % flowers = im2double(imread("flowers4.png"));
    % whos flowers
    % hsv = rgb2hsv(flowers);
    % whos hsv
    % imshow(hsv(:,:,1))
    % imshow(hsv(:,:,2))
    % imshow(hsv(:,:,3))
    % Lab = rgb2lab(flowers);
    % whos Lab
    % imshow(Lab(:,:,2),[])
    % imshow(Lab(:,:,3),[])
    % %% Transforming between Different Primaries
    % C = [0.7347 0.2653 0; ...
    %      0.2738 0.7174 0.0088; ...
    %      0.1666 0.0089 0.8245]'
    % J = inv(C)*[0.3127 0.3290 0.3582]' *(1/0.3290)
    % C*diag(J)
    % xyzBrick = C*diag(J)*rgbBrick'
    % chromBrick = tristim2cc(xyzBrick')
    % colorname(chromBrick,"xy")
    % %% What Is White?
    % d65 = blackbody(lambda,6500);
    % lambda2xy(lambda,d65)
    % ee = ones(size(lambda));
    % lambda2xy(lambda,ee)
    % %% Advanced Topics
    % %% Color Temperature
    % %% Color Constancy
    % lambda = [400:10:700]*1e-9;
    % R = loadspectrum(lambda,"redbrick");
    % sun = loadspectrum(lambda,"solar");
    % lamp = blackbody(lambda,2600);
    % xy_sun = lambda2xy(lambda,sun.*R)
    % xy_lamp = lambda2xy(lambda,lamp.*R)
    % %% White Balancing
    % %% Color Change Due to Absorption
    % [R,lambda] = loadspectrum([400:5:700]*1e-9,"redbrick");
    % sun = loadspectrum(lambda,"solar");
    % A = loadspectrum(lambda,"water");
    % d = 2;
    % T = 10.^(-d*A);
    % L = sun.*R.*T;
    % xy_water = lambda2xy(lambda,L)
    % %% Dichromatic Reflection
    % %% Gamma
    % wedge = [0:0.1:1];
    % imshow(wedge,InitialMagnification=10000)
    % imshow(wedge.^(1/2.2),InitialMagnification=10000)
    % %% Application: Color Images
    % %% Comparing Color Spaces
    % lambda = [400:5:700]*1e-9;
    % macbeth = loadspectrum(lambda,"macbeth");
    % d65 = loadspectrum(lambda,"D65")*3e9;
    % XYZ = []; Lab = [];
    % for i=1:18
    %   L = macbeth(:,i).*d65;
    %   tristim = max(cmfrgb(lambda,L),0);
    %   RGB = imadjust(tristim,[],[],0.45);
    %   XYZ(i,:) = rgb2xyz(RGB);
    %   Lab(i,:) = rgb2lab(RGB);
    % end
    % xy = XYZ(:,1:2)./(sum(XYZ,2)*[1 1]);
    % ab = Lab(:,2:3);
    % showcolorspace(xy,"xy")
    % showcolorspace(ab,"Lab")
    % %% Shadow Removal
    % im = imread("parks.jpg");
    % im = rgb2lin(im);
    % gs = shadowRemoval(im,0.7,"noexp");
    % imshow(gs,[]) % [] - scale display based on range of pixel values
    % theta = esttheta(im);
    % %% Wrapping Up
    % %% Further Reading
    % %% Data Sources
    % %% Exercises

    end    
end
