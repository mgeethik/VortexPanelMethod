function [x, y, thickness, camber] = naca_coord(nacaCode, numPoints)
    % NACA 4-Series Airfoil Coordinates Generator

    % Extract parameters from NACA code
    m = str2double(nacaCode(1)) / 100;  % Maximum camber
    p = str2double(nacaCode(2)) / 10;    % Location of maximum camber
    t = str2double(nacaCode(3:4)) / 100; % Thickness
    
    % Generate x coordinates
    x = linspace(0, 1, numPoints);

    % Calculate camber line
    camber = zeros(size(x));
    camber(x <= p) = m / p^2 * (2 * p * x(x <= p) - x(x <= p).^2);
    camber(x > p) = m / (1 - p)^2 * ((1 - 2 * p) + 2 * p * x(x > p) - x(x > p).^2);

    % Calculate thickness distribution
    thickness = 5 * t * (0.2969 * sqrt(x) - 0.126 * x - 0.3516 * x.^2 + 0.2843 * x.^3 - 0.1015 * x.^4);

    % Calculate upper and lower surfaces
    y_upper = camber + 0.5 * thickness;
    y_lower = camber - 0.5 * thickness;

    % Combine upper and lower surfaces
    x = [fliplr(x), x(2:end)];
    y = [fliplr(y_lower), y_upper(2:end)];
    
    % Ensure the trailing edge is exactly at (1, 0)
    x(end) = 1;
    y(end) = 0;
end
