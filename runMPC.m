clear

Q = eye(4);
Q(2, 2) = 0;
Q(4, 4) = 0;
R = 1;
T = 2;

q0 = [0; 0; 0; 0];
qdes = [10; 0; 0; 0];

% Run a quick test optimization
Fmax = 5;

Tfinal = 20;
Ts = 0.1;
t_sim = 0:Ts:Tfinal;

t_all = [];
q_all = [];
u_all = [];
options = optimset('Display', 'off');

for iter = 1:numel(t_sim)
    H = Hfunc(Q,R,qdes,T);
    c = cfunc(Q,R,qdes,T);
    A = Afunc(T,Fmax);
    b = bfunc(T,Fmax);
    Aeq = Aeqfunc(q0,T,Fmax);
    beq = beqfunc(q0,T,Fmax);

    xstar = quadprog(H,c,A,b,Aeq,beq, [], [], [], options);
    
    N = 21;
    u = xstar(1:N);
    
    odefunparams = @(t, q) eqs(t, q, interp1(linspace(0, T, N), u, t));
    
    [tout, qout] = ode45(odefunparams, [0, Ts], q0);
    
    t_all = [t_all; tout(1:end-1)+t_sim(iter)];
    q_all = [q_all; qout(1:end-1, :)];
    u_all = [u_all; u(1:end-1)];
    
    q0 = qout(end, :)';
end
plot(t_all, q_all);
legend("\phi", "d\phi", "\theta", "d\theta")

r_k = 0.125;        % Ball radius
r_w = 0.06;         % Omniwheel radius
psi = @(phi, th) -((r_k/r_w)*(phi-th)-th);
animate(t_all, q_all(:, 1), q_all(:, 3), psi(q_all(:, 1), q_all(:, 3)));