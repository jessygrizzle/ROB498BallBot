clear
m_k = 2.29;         % Ball mass
m_w = 3;            % Virtual actuating wheel mass
m_a = 9.2;          % Body mass
r_k = 0.125;        % Ball radius
r_w = 0.06;         % Omniwheel radius
r_a = 0.1;          % Body radius
l = 0.339;          % Height of center of gravity
TH_k = 0.0239;      % Ball inertia
TH_w = 0.00236;     % Total inertia of actuating wheel (?)
TH_wxy = 0.00945;   % Inertia of actuating wheel in xy plane
TH_a = 4.76;        % Total inertia of body
TH_axy = 0.092;     % Inertia of body in xy plane
g = 9.81;           % Gravitational acceleration

% Wheel torque function of time
T_x = @(t) 0.0;

% y = [phi; dphi/dt; theta; dtheta/dt];
% dy/dt = [dphi/dt; dphi^2/d^phi; dtheta/dt; dtheta^2/d^t];
dydt = @(t, y) [y(2);...
    (((r_k*T_x(t))/r_w + r_k*sin(y(3)*y(4)^2)*(m_w*(r_k + r_w) + l*m_a))*(TH_w*(r_k + r_w)^2 + TH_a*r_w^2 + m_w*r_w^2*(r_k + r_w)^2 + l^2*m_a*r_w^2))/(TH_k*TH_w*(r_k + r_w)^2 + TH_a*TH_w*r_k^2 + TH_a*TH_k*r_w^2 - r_k^2*r_w^2*cos(y(3))^2*(m_w*(r_k + r_w) + l*m_a)^2 + TH_w*m_w*r_k^2*(r_k + r_w)^2 + TH_k*m_w*r_w^2*(r_k + r_w)^2 + TH_w*l^2*m_a*r_k^2 + TH_k*l^2*m_a*r_w^2 + TH_w*r_k^2*(r_k + r_w)^2*(m_a + m_k + m_w) + TH_a*r_k^2*r_w^2*(m_a + m_k + m_w) + 2*TH_w*r_k^2*cos(y(3))*(r_k + r_w)*(m_w*(r_k + r_w) + l*m_a) + m_w*r_k^2*r_w^2*(r_k + r_w)^2*(m_a + m_k + m_w) + l^2*m_a*r_k^2*r_w^2*(m_a + m_k + m_w)) + (r_k*(TH_w*(r_k + r_w) - r_w^2*cos(y(3))*(m_w*(r_k + r_w) + l*m_a))*(T_x(t) + g*sin(y(3))*(m_w*(r_k + r_w) + l*m_a) - (r_k*T_x(t))/r_w - 1))/(TH_k*TH_w*(r_k + r_w)^2 + TH_a*TH_w*r_k^2 + TH_a*TH_k*r_w^2 - r_k^2*r_w^2*cos(y(3))^2*(m_w*(r_k + r_w) + l*m_a)^2 + TH_w*m_w*r_k^2*(r_k + r_w)^2 + TH_k*m_w*r_w^2*(r_k + r_w)^2 + TH_w*l^2*m_a*r_k^2 + TH_k*l^2*m_a*r_w^2 + TH_w*r_k^2*(r_k + r_w)^2*(m_a + m_k + m_w) + TH_a*r_k^2*r_w^2*(m_a + m_k + m_w) + 2*TH_w*r_k^2*cos(y(3))*(r_k + r_w)*(m_w*(r_k + r_w) + l*m_a) + m_w*r_k^2*r_w^2*(r_k + r_w)^2*(m_a + m_k + m_w) + l^2*m_a*r_k^2*r_w^2*(m_a + m_k + m_w)); ...
    y(4);...
    (((m_a + m_k + m_w)*r_k^2*r_w^2 + TH_w*r_k^2 + TH_k*r_w^2)*(T_x(t) + g*sin(y(3))*(m_w*(r_k + r_w) + l*m_a) - (r_k*T_x(t))/r_w - 1))/(TH_k*TH_w*(r_k + r_w)^2 + TH_a*TH_w*r_k^2 + TH_a*TH_k*r_w^2 - r_k^2*r_w^2*cos(y(3))^2*(m_w*(r_k + r_w) + l*m_a)^2 + TH_w*m_w*r_k^2*(r_k + r_w)^2 + TH_k*m_w*r_w^2*(r_k + r_w)^2 + TH_w*l^2*m_a*r_k^2 + TH_k*l^2*m_a*r_w^2 + TH_w*r_k^2*(r_k + r_w)^2*(m_a + m_k + m_w) + TH_a*r_k^2*r_w^2*(m_a + m_k + m_w) + 2*TH_w*r_k^2*cos(y(3))*(r_k + r_w)*(m_w*(r_k + r_w) + l*m_a) + m_w*r_k^2*r_w^2*(r_k + r_w)^2*(m_a + m_k + m_w) + l^2*m_a*r_k^2*r_w^2*(m_a + m_k + m_w)) + (r_k*(TH_w*(r_k + r_w) - r_w^2*cos(y(3))*(m_w*(r_k + r_w) + l*m_a))*((r_k*T_x(t))/r_w + r_k*sin(y(3)*y(4)^2)*(m_w*(r_k + r_w) + l*m_a)))/(TH_k*TH_w*(r_k + r_w)^2 + TH_a*TH_w*r_k^2 + TH_a*TH_k*r_w^2 - r_k^2*r_w^2*cos(y(3))^2*(m_w*(r_k + r_w) + l*m_a)^2 + TH_w*m_w*r_k^2*(r_k + r_w)^2 + TH_k*m_w*r_w^2*(r_k + r_w)^2 + TH_w*l^2*m_a*r_k^2 + TH_k*l^2*m_a*r_w^2 + TH_w*r_k^2*(r_k + r_w)^2*(m_a + m_k + m_w) + TH_a*r_k^2*r_w^2*(m_a + m_k + m_w) + 2*TH_w*r_k^2*cos(y(3))*(r_k + r_w)*(m_w*(r_k + r_w) + l*m_a) + m_w*r_k^2*r_w^2*(r_k + r_w)^2*(m_a + m_k + m_w) + l^2*m_a*r_k^2*r_w^2*(m_a + m_k + m_w))];

% Initialize the ball bot to start aiming straight up
[t, y] = ode45(dydt, [0, 20], [0; 0; 0; 0]);

figure()

% Obtain the wheel's angle - same function works for phi's derivatives
psi = @(phi, th) -((r_k/r_w)*(phi-th)-th);

plot(t, y(:, 1), 'b');
hold on
plot(t, y(:, 2), 'b--');
plot(t, y(:, 3), 'g');
plot(t, y(:, 4), 'g--');
plot(t, psi(y(:, 1), y(:, 3)), 'r');
plot(t, psi(y(:, 2), y(:, 4)), 'r--');
legend("\phi (ball angle)", "d\phi/dt", "\theta (lean angle)", "d\theta/dt", "\psi (wheel angle)", "d\psi/dt");
hold off

animate(t, y(:, 1), y(:, 3), psi(y(:, 1), y(:, 3)));
