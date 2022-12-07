%% Fig 11.10 Application: motion detection

vid = VideoReader('traffic_sequence.mpg');
bg = im2single(im2gray((vid.readFrame)));

sigma = 0.02;
count = 0;
while 1
    im = im2single(im2gray((vid.readFrame)));
	if isempty(im) break; end; % end of file?
	d = im-bg;
	d = max(min(d, sigma), -sigma); % apply c(.)
	bg = bg + d;
	imshow(bg);
    
    count = count + 1;
    if count > 200
        break;
    end
end

imshow(im)
axis on
rvcprint3('fig11_10a');

imshow(bg)
axis on
rvcprint3('fig11_10b');

% Used idisp because it sets up the colormap, red for neg, blue for
% positive.  This can be recreated with use of idisp from the previous
% version of the toolbox.

%idisp(im-bg, 'invsigned', 'nogui')
%rvcprint3('fig11_10c');

