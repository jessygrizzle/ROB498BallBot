clear
close all

%% LQR
% Symbolic state and input vectors
q = sym('q', [4, 1]);
u = sym('u', [1, 1]);
syms t;

% Linearized dynamics at upper position
A = subs(jacobian(dynamfunc(t, q, u), q), {q(1), q(2), q(3), q(4)}, {0, 0, 0, 0});
B = subs(jacobian(dynamfunc(t, q, u), u), {u, q(1), q(2), q(3), q(4)}, {0, 0, 0, 0, 0});
A = double(A);
B = double(B);

% Define quadratic cost for infinite time horizon
Q = 0.000000001*eye(4);
Q(1,1) = 1; % penalty on ball angle (position)
Q(2,2) = 0; % penalty on ball velocity
Q(3,3) = 1000; % penalty on lean angle
Q(4,4) = 0; % penalty on lean velocity
R = 1;

% Initial and goal states
q0 = [0 0 0 0]';
qdes = [6/0.125 0 0 0]';

% Get Gain Matrix, K, with LQR
K = lqr(A,B,Q,R);

% Dynamics with LQR control inputs
odecon = @(t,q) dynamfunc(t, q, -K*(q-qdes));

% Nonlinear simulation
tspan = [0 10]; % simulation timespan
[tout, qout] = ode45(odecon, tspan, q0);


%% Plotting and Animation
animate2D(tout, qout(:, 1), qout(:, 3), 'LQR_2D.mp4')

figure
plot(tout, qout)
legend("\phi", "d\phi", "\theta", "d\theta")