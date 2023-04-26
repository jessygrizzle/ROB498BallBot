clear
close all

% m_k = 2.29;         % Ball mass
% m_w = 3;            % Virtual actuating wheel mass
% m_a = 9.2;          % Body mass
% r_k = 0.125;        % Ball radius
% r_w = 0.06;         % Omniwheel radius
% r_a = 0.1;          % Body radius
% l = 0.339;          % Height of center of gravity
% TH_k = 0.0239;      % Ball inertia
% TH_w = 0.00236;     % Total inertia of actuating wheel (?)
% TH_wxy = 0.00945;   % Inertia of actuating wheel in xy plane
% TH_a = 4.76;        % Total inertia of body
% TH_axy = 0.092;     % Inertia of body in xy plane
% g = 9.81;           % Gravitational acceleration

% dynamics function with zero torque
odeNoInput = @(t, q) dynamfunc(t, q, 0);

% dynamics function with constant torque
odeConstInput = @(t, q) dynamfunc(t, q, 2);

[t, y] = ode45(dynam, [0, 20], [0; 0; 0; 0]);
animate(t, y(:, 1), y(:, 3), psi(y(:, 1), y(:, 3)));