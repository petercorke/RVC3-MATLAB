%ANIMATE Create a movie animation class
%
% Helper class for creating animations as MP4, animated GIF or a folder of
% images.
%
%
% ANIM = ANIMATE(NAME) initializes an animation, and creates
% a movie file or a folder holding individual frames.
%
% ANIM = ANIMATE({NAME, OPTIONS}) as above but arguments are passed as a cell array,
% which allows a single argument to a higher-level option like 'movie',M to express
% options as well as filename.
%
% Options:
%  resolution  -  Set the resolution of the saved image to R pixels per inch.
%  profile     -  See VideoWriter for details
%  fps         -  Frame rate (default 30)
%  bgcolor     - Set background color of axes, 3 vector or MATLAB
%                    color name.
% inner        -  inner frame of axes; no axes, labels, ticks.
%
% A profile can also be set by the file extension:
%
% none    Create a folder full of frames in PNG format frames named
%         0000.png, 0001.png and so on
% .gif    Create animated GIF
% .mp4    Create MP4 movie (not on Linux)
% .avi    Create AVI movie
% .mj2    Create motion jpeg file
%
% Notes:
% - MP4 movies cannot be generated under Linux, a limitation of MATLAB VideoWriter.
% - if no extension or profile is given a folder full of frames is created.
% - if a profile is given a movie is created, see VideoWriter for allowable
%   profiles.
% - if the file has an extension it specifies the profile.
% - if an extension of '.gif' is given an animated GIF is created
% - if NAME is [] then an Animation object is created but the add() and close()
%   methods do nothing.
%
% Example:
%
%         anim = Animate("movie.mp4");
%          for i=1:100
%              plot(...);
%              anim.add();
%          end
%          anim.close();
%
% will save the frames in an MP4 movie file using VideoWriter.
%
% Alternatively, to createa of images in PNG format frames named 0000.png,
% 0001.png and so on in a folder called 'frames'
%
%          anim = Animate('frames');
%          for i=1:100
%              plot(...);
%              anim.add();
%          end
%          anim.close();
%
% To convert the image files to a movie you could use a tool like ffmpeg
%           ffmpeg -r 10 -i frames/%04d.png out.mp4
%
% See also VideoWriter.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat 

classdef Animate < handle
    properties
        frame
        dir
        video           % video writing object
        opt
        profile
    end
    
    methods
        function a = Animate(varargin)
%             arguments
%                 filename
%                 options.resolution
%                 options.profile
%                 options.fps (1,1) double = 30
%                 options.bgcolor
%                 options.inner (1,1) logical = false
%             end
            %Animate construct object
                ip = inputParser();
                ip.KeepUnmatched = true;
                ip.addRequired("filename");
                ip.addParameter("fps", 30);
                ip.addParameter("resolution", []);
                ip.addParameter("profile", "");
                ip.addParameter("bgcolor", []);
                ip.addParameter("inner", false, @(x) islogical(x));
                ip.parse(varargin{:});
                args = ip.Results;

                filename = args.filename;
                video_args = ip.Unmatched;

            if isempty(filename)
                % we're not animating
                a.dir = [];
                return
            elseif isstruct(filename)
                    % convert text options from a struct to a cell array
                    for fieldname=fieldnames(filename)'
                        fieldname = fieldname{1};
                        args = setfield(args, fieldname, getfield(filename, fieldname));
                    end
                    filename = args.filename
            end

            a.opt = args;
            a.frame = 0;
            
            args.profile
            
            [~,~,e] = fileparts(filename);
            
            if ~isempty(args.profile)
                % create a video with this profile
                a.profile = args.profile %#ok<NOPRT>
                a.video = VideoWriter(filename, a.profile, video_args{:});
                fprintf('saving video --> %s with profile ''%s''\n', filename, a.profile);
            elseif ~isempty(e)
                % an extension was given
                switch (e)
                    case {'.mp4', '.m4v'}
                        if ~(ismac || ispc)
                            error('RVC3:Animate:nosupported', 'MP4 creation not supported by MATLAB on this platform')
                        end
                        a.profile = 'MPEG-4';
                    case '.mj2'
                        a.profile = 'Motion JPEG 2000';
                    case '.avi'
                        a.profile = 'Motion JPEG AVI';
                    case {'.gif','.GIF'}
                        a.profile = 'GIF';
                end
                fprintf('Animate: saving video --> %s with profile ''%s''\n', filename, a.profile);
                if strcmp(profile, 'GIF')
                    a.video = filename;
                else
                    a.video = VideoWriter(filename, profile, video_args{:});
                    a.video.FrameRate = opt.fps;
                    a.video.Quality = 95;
                    open(a.video);
                end
                a.profile = profile;
            else
                % create a folder to hold the frames
                a.dir = filename;
                mkdir(filename);
                
                % clear out old frames
                delete( fullfile(filename, '*.png') );
                fprintf('saving frames --> %s\n', filename);
                a.profile = 'FILES';
            end            
        end
        
        function add(a, fh)
            %ADD Add current plot to the animation
            %
            % A.ADD() adds the current figure to the animation.
            %
            % A.ADD(FIG) as above but captures the figure FIG.
            %
            % Notes:
            % - the frame is added to the output file or as a new sequentially
            %   numbered image in a folder.
            % - if the filename was given as [] in the constructor then no
            %   action is taken.
            %
            
            if isempty(a.dir) && isempty(a.video)
                return;
            end
            
            if nargin < 2
                fh = gcf;
            end
            
            if ~isempty(a.opt.bgcolor)
                fh.Color = a.opt.bgcolor;
            end
            ax = gca;
            ax.Units = 'pixels';
            switch a.profile
                case 'FILES'
                    if isempty(a.opt.resolution)
                        print(fh, '-dpng', fullfile(a.dir, sprintf('%04d.png', a.frame)));
                    else
                        print(fh, '-dpng', sprintf('-r%d', a.opt.resolution), fullfile(a.dir, sprintf('%04d.png', a.frame)));
                    end
                case 'GIF'
                    if a.opt.inner
                        im = frame2im( getframe(fh, ax.Position) );  % get the frame
                    else
                        im = frame2im(getframe(fh));  % get the frame
                    end
                    [A, map] = rgb2ind(im, 256);
                    if a.frame == 0
                        imwrite(A, map, a.video, 'gif', 'LoopCount',Inf, 'DelayTime', 1/a.opt.fps);
                    else
                        imwrite(A, map, a.video, 'gif', 'WriteMode','append', 'DelayTime', 1/a.opt.fps);
                    end
                otherwise
                    
                    if a.opt.inner
                        im = frame2im( getframe(fh, ax.Position) );  % get the frame
                    else
                        im = frame2im(getframe(fh));  % get the frame
                    end
                    % crop so that height/width are multiples of two, by default MATLAB pads
                    % with black which gives lines at the edge
                    w = size(im,2); h = size(im,1);
                    w = floor(w/2)*2; h = floor(h/2)*2;
                    im = im(1:h,1:w,:);
                    
                    % add the frame to the movie
                    writeVideo(a.video, im)
            end
            a.frame = a.frame + 1;
        end
        
        function out = close(a)
            %CLOSE  Closes the animation
            %
            % A.CLOSE() ends the animation process and closes any output file.
            %
            % Notes::
            % - if the filename was given as [] in the constructor then no
            %   action is taken.
            %
            if isempty(a.profile)
                out = [];
            else
                switch a.profile
                    case {'GIF', 'FILES'}
                    otherwise
                        if nargout > 0
                            out = char(a.video);
                        end
                        close(a.video);
                end
            end
        end
    end %methods
end %classdef
