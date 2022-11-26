%vid = Movie('LeftBag.mpg', 'grey', 'double');
vid = Movie('traffic_sequence.mpg', 'grey', 'double');


bg = vid.grab();

sigma = 0.02;
h = get(gca, 'Children');
count = 0;
while 1
    im = vid.grab();
    if isempty(im) break; end
    d = im - bg;
    d = max(min(d, sigma), -sigma);
    bg = bg + d;

    count = count + 1;
    if count > 200
        break;
    end
end

idisp(im, 'nogui')
rvcprint('subfig', 'a', 'svg')

idisp(bg, 'nogui')
rvcprint('subfig', 'b', 'svg')

idisp(im-bg, 'invsigned', 'nogui')
rvcprint('subfig', 'c', 'svg')

