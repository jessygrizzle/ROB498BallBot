function [energy] = calculateEnergies(dphi, th, dth)
% Calculates energy for one plane of motion (xz or yz). There is no
% rotation in the xy plane (around the z-axis) so these terms are not
% included.

% System parameters
m_k = 2.29;         % Ball mass
m_w = 3;            % Virtual actuating wheel mass
m_a = 9.2;          % Body mass
r_k = 0.125;        % Ball radius
r_w = 0.06;         % Omniwheel radius
% r_a = 0.1;        % Body radius
l = 0.339;          % Height of center of gravity
TH_k = 0.0239;      % Ball inertia
TH_w = 0.00236;     % Total inertia of actuating wheel (?)
% TH_wxy = 0.00945; % Inertia of actuating wheel in xy plane
TH_a = 4.76;        % Total inertia of body
% TH_axy = 0.092;   % Inertia of body in xy plane
g = 9.81;           % Gravitational acceleration


%% Ball Energy
% Ball kinetic energy (Eqn. 2.8)
ball_kinetic = 0.5 * m_k * (r_k.*dphi).^2 + 0.5 * TH_k .* dphi.^2;
% Ball potential energy (Eqn. 2.9)
ball_potential = 0;


%% Wheel Energy
% Wheel kinetic energy (Eqn. 2.11)
wheel_kinetic = 0.5*m_w*((r_k.*dphi).^2 + 2*(r_k+r_w).*cos(th).*dth.*(r_k.*dphi) + (r_k+r_w).^2.*dth.^2) ...
    + 0.5*TH_w*(r_k/r_w.*(dphi-dth)-dth).^2;
% Wheel potential energy (Eqn. 2.12)
wheel_potential = m_w * g * (r_k + r_w) .* cos(th);


%% Body Energy
% Body kinetic energy (Eqn. 2.14)
body_kinetic = 0.5*m_a*((r_k.*dphi).^2 + 2*l.*cos(th).*dth.*(r_k.*dphi) + l^2.*dth.^2) + 0.5*TH_a.*dth.^2;
% Body potential energy (Eqn. 2.15)
body_potential = m_a * g * l .* cos(th);

% Total Energy
energy = ball_kinetic + ball_potential + wheel_kinetic + wheel_potential + body_kinetic + body_potential;
end