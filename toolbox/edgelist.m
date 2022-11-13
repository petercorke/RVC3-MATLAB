%EDGELIST Return list of edge pixels for region
%
% EG = EDGELIST(IM, SEED) is a list of edge pixels (2xN) of a region in the
% image IM starting at edge coordinate SEED=[X,Y].  The edgelist has one
% column per edge point coordinate (x,y).
%
% EG = EDGELIST(IM, SEED, DIRECTION) as above, but the direction of edge
% following is specified.  DIRECTION == 0 (default) means clockwise, non
% zero is counter-clockwise.  Note that direction is with respect to y-axis
% upward, in matrix coordinate frame, not image frame.
%
% [EG,D] = EDGELIST(IM, SEED, DIRECTION) as above but also returns a vector
% of edge segment directions which have values 1 to 8 representing W SW S
% SE E NW N NW respectively.
%
% Notes:: - Coordinates are given assuming the matrix is an image, so the
% indices are
%   always in the form (x,y) or (column,row).
% - IM is a binary image where 0 is assumed to be background, non-zero
%   is an object.
% - SEED must be a point on the edge of the region. - The seed point is
% always the first element of the returned edgelist. - 8-direction chain
% coding can give incorrect results when used with
%   blobs founds using 4-way connectivty.
%
% Reference:: - METHODS TO ESTIMATE AREAS AND PERIMETERS OF BLOB-LIKE
% OBJECTS: A COMPARISON
%   Luren Yang, Fritz Albregtsen, Tor Lgnnestad and Per Grgttum IAPR
%   Workshop on Machine Vision Applications Dec. 13-15, 1994, Kawasaki
%
% See also ILABEL.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

function [e,d] = edgelist(im, P, direction)

% deal with direction argument
if nargin == 2
    direction = 0;
end

if direction == 0
    neighbours = 1:8; % neigbours in clockwise direction
else
    neighbours = 8:-1:1;  % neigbours in counter-clockwise direction
end

P = P(:);
try
    pix0 = im(P(2), P(1));  % color of pixel we start at
catch
    error('TBCOMMON:edgelist', 'specified coordinate is not within image');
end
P0 = [];

% find an adjacent point outside the blob
Q = adjacent_point(im, P, pix0);

assert(~isempty(Q), 'TBCOMMON:edgelist', 'no neighbor outside the blob');

e = P;  % initialize the edge list
dir = []; % initialize the direction list

% these are directions of 8-neighbours in a clockwise direction
dirs = [-1 0; -1 1; 0 1; 1 1; 1 0; 1 -1; 0 -1; -1 -1]';

while true
    % find which direction is Q
    dQ = Q - P;
    for kq=1:8
        if all(dQ == dirs(:,kq))
            break;
        end
    end
    
    
    % now test for directions relative to Q
    for j=neighbours
        % get index of neighbor's direction in range [1,8]
        k = j + kq;
        if k > 8
            k = k - 8;
        end
        dir = [dir; k]; %#ok<AGROW>
        
        % compute coordinate of the k'th neighbor
        Nk = P + dirs(:,k);
        try
            if im(Nk(2), Nk(1)) == pix0
                % if this neighbor is in the blob it is the next edge pixel
                P = Nk;
                break;
            end
        catch
        end
        Q = Nk;     % the (k-1)th neighbor
    end
    
    % check if we are back where we started
    if isempty(P0)
        P0 = P;     % make a note of where we started
    else
        if all(P == P0)
            break;
        end
    end
    
    % keep going, add P to the edgelist
    e = [e P]; %#ok<AGROW>
end

if nargout > 1
    d = dir;
end
end

function P = adjacent_point(im, seed, pix0)
% find an adjacent point not in the region
dirs = [1 0; 0 1; -1 0; 0 -1; -1 1; -1 -1; 1 -1; 1 1];
for d=dirs'
    P = seed(:) + d;
    try
        if im(P(2), P(1)) ~= pix0
            return;
        end
    catch
        % if we get an exception then by definition P is outside the region,
        % since it's off the edge of the image
        return;
    end
end
P = [];
end
