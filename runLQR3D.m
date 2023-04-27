clear
close all

%% LQR 3D
% Symbolic state and input vectors
q = sym('q', [8, 1]); % qx; qy
u = sym('u', [2, 1]); % Tx; Ty
syms t;

% Combining x and y planar dynamics into one dynamics function
dynamics3D = @(time, q3D, u3D) [dynamfunc(time, q3D(1:4), u3D(1)); dynamfunc(time, q3D(5:8), u3D(2))];

% Linearized dynamics at upper position
A = subs(jacobian(dynamics3D(t, q, u), q), {q(1), q(2), q(3), q(4), q(5), q(6), q(7), q(8)}, {0, 0, 0, 0, 0, 0, 0, 0});
B = subs(jacobian(dynamics3D(t, q, u), u), {u(1), u(2), q(1), q(2), q(3), q(4), q(5), q(6), q(7), q(8)}, {0, 0, 0, 0, 0, 0, 0, 0, 0, 0});
A = double(A);
B = double(B);

% Define quadratic cost for infinite time horizon
Q = eye(8);
R = eye(2);

% Initial and goal states
q0 = [0 0 0 0 0 0 0 0]';
qdes = [6/0.125 0 0 0 2/0.125 0 0 0]';

% Get Gain Matrix, K, with LQR
K = lqr(A,B,Q,R);

% Dynamics with LQR control inputs
odecon = @(t,q) dynamics3D(t, q, -K*(q-qdes));

% Nonlinear simulation
tspan = [0 10]; % simulation timespan
[tout, qout] = ode45(odecon, tspan, q0);


%% Plotting and Animation
animate3D(tout, qout(:,1), qout(:,5), qout(:,3), qout(:,7), 'LQR3D.mp4');

plot(tout, qout);
legend("\phi x", "d\phi x", "\theta x", "d\theta x", "\phi y", "d\phi y", "\theta y", "d\theta y")