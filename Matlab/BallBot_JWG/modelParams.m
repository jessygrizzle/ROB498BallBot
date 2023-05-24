function [g L R r mBot mBall Jbot Jball Jwheels] = modelParams()

% made up numbers for now
g = 9.81; % m/sec^2
R = 0.11938; %m radius of basketball or 4.7 inches
r = 0.025; %m
L = R + 0.1; % m
mBot = 1.0; % kg
mBall = 0.62; % Kg or 22 ounces
Jbot  = 0.1; % kg m^2
Jball = 0.0503; % kg m^2 
Jwheels = 0.1; % kg m^2 includes scaled rotor inertia
end

