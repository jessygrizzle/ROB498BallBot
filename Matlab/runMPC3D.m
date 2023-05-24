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
r_k = 0.125; % Ball radius
q0x = [0; 0; 0; 0];
qdesx = [6/0.125; 0; 0; 0];
q0y = [0; 0; 0; 0];
qdesy = [2/0.125; 1; 0; 0];

% simulation parameters
Tfinal = 10; % total simulation time
t_sim = 0:Ts:Tfinal;
t_all = [];
q_all = [];
u_all = [];
options = optimset('Display', 'on');

% MPC loop
for iter = 1:numel(t_sim)
    disp(iter);
    
    % Set up direct collocation from current position
    H = Hfunc(Q,R,qdesx,T);
    c = cfunc(Q,R,qdesx,T);
    A = Afunc(T,Fmax,thmax,dphimax);
    b = bfunc(T,Fmax,thmax,dphimax);
    Aeq = Aeqfunc(q0x,T,Fmax,thmax,dphimax);
    beq = beqfunc(q0x,T,Fmax,thmax,dphimax);

    % Get optimal trajectory and inputs
    xstar = quadprog(H,c,A,b,Aeq,beq, [], [], [], options);
    N = 21;
    ux = xstar(1:N);
    
    % Set up direct collocation from current position
    H = Hfunc(Q,R,qdesy,T);
    c = cfunc(Q,R,qdesy,T);
    A = Afunc(T,Fmax,thmax,dphimax);
    b = bfunc(T,Fmax,thmax,dphimax);
    Aeq = Aeqfunc(q0y,T,Fmax,thmax,dphimax);
    beq = beqfunc(q0y,T,Fmax,thmax,dphimax);

    % Get optimal trajectory and inputs
    xstar = quadprog(H,c,A,b,Aeq,beq, [], [], [], options);
    uy = xstar(1:N);
    
    % Simulate system for Ts with optimal inputs
    dynamics3D = @(time, q3D, u3D) [dynamfunc(time, q3D(1:4), u3D(1)); dynamfunc(time, q3D(5:8), u3D(2))];
    odefunparams = @(t, q) dynamics3D(t, q, [interp1(linspace(0, T, N), ux, t); interp1(linspace(0, T, N), uy, t)]);
    [tout, qout] = ode45(odefunparams, [0, Ts], [q0x; q0y]);
    
    % Bookkeep time, state, and input for plotting
    t_all = [t_all; tout(1:end-1)+t_sim(iter)];
    q_all = [q_all; qout(1:end-1, :)];
    u_all = [u_all; [ux(1:end-1), uy(1:end-1)]];
    
    % Update initial condition for next iteration
    q0x = qout(end, 1:4)';
    q0y = qout(end, 5:8)';
end


%% Plotting and Animation
animate3D(t_all, q_all(:,1), q_all(:,5), q_all(:,3), q_all(:,7), 'MPC_3D.mp4')

figure
plot(t_all, q_all)
legend("\phi x", "d\phi x", "\theta x", "d\theta x", "\phi y", "d\phi y", "\theta y", "d\theta y")