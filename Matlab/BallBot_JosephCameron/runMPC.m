clear
close all

%% MPC
% MPC cost parameters
Q = zeros(4,4);
Q(1,1) = 1; % penalty on ball angle (position)
Q(2,2) = 0; % penalty on ball velocity
Q(3,3) = 1000; % penalty on lean angle
Q(4,4) = 0; % penalty on lean velocity
R = 1; % penalty on torque

% MPC time parameters
T = 8; % finite time horizon
Ts = 0.1; % sample time

% MPC limit constraints
Fmax = 15; % max torque
thmax = deg2rad(100); % max allowable lean angle
dphimax = 100; % max ball velocity rad/s

% MPC initial and desired final conditions
q0 = [0; 0; 0; 0];
qdes = [6/0.125; 0; 0; 0];

% simulation parameters
Tfinal = 10; % total simulation time
t_sim = 0:Ts:Tfinal;
t_all = [];
q_all = [];
u_all = [];
options = optimset('Display', 'off');

% MPC loop
for iter = 1:numel(t_sim)
    % Set up direct collocation from current position
    H = Hfunc(Q,R,qdes,T);
    c = cfunc(Q,R,qdes,T);
    A = Afunc(T,Fmax,thmax,dphimax);
    b = bfunc(T,Fmax,thmax,dphimax);
    Aeq = Aeqfunc(q0,T,Fmax,thmax,dphimax);
    beq = beqfunc(q0,T,Fmax,thmax,dphimax);

    % Get optimal trajectory and inputs
    xstar = quadprog(H,c,A,b,Aeq,beq, [], [], [], options);
    N = 21;
    u = xstar(1:N);
    
    % Simulate system for Ts with optimal inputs
    odefunparams = @(t, q) dynamfunc(t, q, interp1(linspace(0, T, N), u, t));
    [tout, qout] = ode45(odefunparams, [0, Ts], q0);
    
    % Bookkeep time, state, and input for plotting
    t_all = [t_all; tout(1:end-1)+t_sim(iter)];
    q_all = [q_all; qout(1:end-1, :)];
    u_all = [u_all; u(1:end-1)];
    
    % Update initial condition for next iteration
    q0 = qout(end, :)';
end


%% Plotting and Animation
animate2D(t_all, q_all(:, 1), q_all(:, 3), 'MPC_2D.mp4')

figure
plot(t_all, q_all)
legend("\phi", "d\phi", "\theta", "d\theta")