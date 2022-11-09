%MCLPLOT Visualize the localization process.

% Copyright 2022-2023 Peter Corke, Witold Jachimczyk, Remo Pillat

classdef mclPlot < handle
    
    properties (Access = private)
        %Figure - Graph handle for the visualization figure.
        Figure

        %Axes - Graph handle for the visualization axes.
        Axes

        %ParticlePlot - Graph handle for particle plot.
        ParticlePlot

        %PositionPlot - Graph handle for robot position plot.
        PositionPlot

        %TruePositionPlot - Graph handle for true robot position plot.
        TruePositionPlot

        %OrientationPlot - Graph handle for robot orientation plot.
        OrientationPlot

        %LaserPlot - Graph handle for laser scan plot.
        LaserPlot
    end
    
    methods
        function obj = mclPlot(og)
            
            % Initialize graph handles
            obj.ParticlePlot = [];
            obj.PositionPlot = [];
            obj.TruePositionPlot = [];
            obj.OrientationPlot = [];
            obj.LaserPlot = [];
            
            % Show BOG
            figure()
            obj.Figure = gcf;
            obj.Axes = gca;
            hold(obj.Axes, "off")
            og.show('Parent', obj.Axes);
            hold(obj.Axes, "on")
            
        end

        function delete(obj)
            if ~isempty(obj.Figure) && ishandle(obj.Figure)
                close(obj.Figure);
            end
        end
        
        function plot(obj, amcl, estimatedPose, truePose, scan)
            %plotStep Update BOG plot with latest robot and particle data.
            % Plot the robot's estimated pose, particles and laser
            % scans on the BOG.
            
            % Get particles from AMCL.
            [particles, ~] = amcl.getParticles;
            % Compute the end point for robot orientation vector.
            orient = [estimatedPose(1) + cos(estimatedPose(3)), estimatedPose(2) + sin(estimatedPose(3))];
            % Transform laser scans from camera frame to global frame.
            transScan = transformScan(scan, amcl.SensorModel.SensorPose + estimatedPose);
            transScanCart = transScan.Cartesian;

            if ishandle(obj.Axes)
                if isempty(obj.ParticlePlot)
                    % Create plots inside obj.Figure and store plot handles
                    % Plot particles.
                    obj.ParticlePlot = plot(obj.Axes, particles(:, 1), particles(:,2), '.');
                    % Plot estimated robot position.
                    obj.PositionPlot = plot(obj.Axes, estimatedPose(1), estimatedPose(2), 'go', LineWidth=1.5);
                    % Plot estimated robot orientation.
                    obj.OrientationPlot = plot(obj.Axes, [estimatedPose(1),orient(1)], [estimatedPose(2),orient(2)], 'g', LineWidth=1);
                    % Plot laser scans
                    obj.LaserPlot = plot(obj.Axes, transScanCart(:,1), transScanCart(:,2), 'r.');
                    % Plot true robot position.
                    if ~isempty(truePose)
                        obj.TruePositionPlot = plot(obj.Axes, truePose(1), truePose(2), 'r+', MarkerSize=10, LineWidth=1.5);
                    end
                else
                    % Update each plot: particle, position, orientation, laser
                    set(obj.ParticlePlot, 'XData', particles(:, 1), 'YData', particles(:, 2));
                    set(obj.PositionPlot, 'XData', estimatedPose(1), 'YData', estimatedPose(2));
                    set(obj.OrientationPlot, 'XData', [estimatedPose(1),orient(1)], 'YData', [estimatedPose(2),orient(2)]);
                    set(obj.LaserPlot, 'XData', transScanCart(:,1), 'YData', transScanCart(:,2));
                    if ~isempty(truePose)
                        set(obj.TruePositionPlot, 'XData', truePose(1), 'YData', truePose(2));
                    end                    
                end
            end
            drawnow("limitrate");
        end
    end
end