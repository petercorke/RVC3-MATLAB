% Section 11.2 Image Histograms

%% Fig 11.5a
church = rgb2gray(imread('church.png'));
[counts, x] = imhist(church);
figure; bar(x, counts);
grid on

xlabel('Pixel values')
ylabel('Number of pixels')

rvcprint3('fig11_5a');
close all;

% Section 11.3 Monadic Operations

imd = im2double(church);
im = im2uint8(imd);

flowers = rgb2gray(imread('flowers8.png'));
color = repmat(flowers, [1 1 3]);

color = zeros(size(color), 'like', color);
color(:,:,1) = flowers;

bright = (church >= 180);
imtool(bright)

im = histeq(church);
counts = imhist(church);
plot(cumsum(counts))

%% Fig 11.5b
x = imhist(im);
cdf = cumsum(x);
hold on
plot(cdf,'r')
h = legend('Original', 'Normalized', 'Location', 'Southeast');
h.FontSize = 12;
xaxis(0,256);
xlabel('Pixel values')
ylabel('Cumulative number of pixels')
grid

rvcprint3('fig11_5b');

