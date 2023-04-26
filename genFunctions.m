clear

N = 21; % Number of nodes

% Create our state and input vectors symbolically
q = sym('q', [4, 1]);
u = sym('u', [1, 1]);

syms m_tot m_k m_a m_w  % Mass parameters
syms r_tot r_k r_w      % Radius parameters
syms TH_k TH_w TH_a     % Inertial parameters
syms gam l g            % Misc parameters
syms t y         % Simulation parameters


% Mass term in Langrangian formulation (Eqn. 2.22)
M_x = [m_tot*r_k^2 + TH_k + (r_k/r_w)^2*TH_w, -(r_k/(r_w^2))*r_tot*TH_w+gam*r_k*cos(q(3)); ...
    -(r_k/(r_w^2))*r_tot*TH_w+gam*r_k*cos(q(3)), ((r_tot^2)/(r_w^2))*TH_w + TH_a + m_a*l^2 + m_w*r_tot^2];

% Coriolis term in Langrangian formulation (Eqn. 2.23)
C_x = [-r_k*gam*sin(q(3)*q(4)^2); 0];

% Gravitational term in Lagrangian formulation (Eqn. 2.24)
G_x = [0; -g*sin(q(3))*gam];

% Non-potential force term in Lagrangian formulation (Eqn. 2.17+Eqn. 2.18)
f_np = [(r_k/r_w)*u; u-(1+(r_k/r_w))*u];

% Solve for ddq in M(q, dq)*ddq + C(q, dq) + G(q) = f_np, simplify
ddq = M_x\(f_np - G_x - C_x);
ddq = subs(ddq, {m_tot, r_tot, gam}, {m_k+m_a+m_w, r_k+r_w, l*m_a+(r_k+r_w)*m_w});

ddq = subs(ddq, {TH_a,TH_k,TH_w,g,l,m_a,m_k,m_w,r_k,r_w}, {4.76, 0.0239, 0.00236, 9.81, 0.339, 9.2, 2.29, 3, 0.125, 0.06});
eqs = [q(2); ddq(1); q(4); ddq(2)];
%%

A = subs(jacobian(eqs, q), {q(1), q(2), q(3), q(4)}, {0, 0, 0, 0});
B = subs(jacobian(eqs, u), {u, q(1), q(2), q(3), q(4)}, {0, 0, 0, 0, 0});

dq = A*q+B*u;

%%

% Define symbolic variables for every state at each node
qN = sym('qN', [4, N]);
uN = sym('uN', [1, N]);

% 1st-order Dynamics for each of the states at each node
dqN = A*qN+B*uN;

% Defect constraints
% Explicit Euler
syms T; % Constant finite time horizon
dt = T/(N-1); % Time between nodes

qNext = qN(:, 2:end);
qPrev = qN(:, 1:end-1);
dqPrev = dqN(:, 1:end-1);
defect = qNext - qPrev - dqPrev*dt;
defect = defect(:);

syms Fmax; % Max force
q0 = sym('q0', [4, 1]);

% IC constraints
ic_constraint = q0-qN(:, 1);

th_lim = deg2rad(4);
% Inequality
limit_constraints = [uN(:) - Fmax; -uN(:) - Fmax; qN(3, N) - th_lim; -qN(3, N) - th_lim];

eqCon = [defect; ic_constraint];
ineqCon = limit_constraints;

% Cost function
Q = sym('Q', [4, 4]);
R = sym('R', [1, 1]);
qdes = sym('qdes', [4, 1]);

% Define our cost
cost = sum(sum((((qdes-qN(:, 1:end-1))'*Q*(qdes-qN(:, 1:end-1)) + uN(:, 1:end-1)'*R*uN(:, 1:end-1)))*dt));

% Decision vector
x = [uN(:); qN(:)];

% Cost
H = hessian(cost, x);
c = subs(jacobian(cost, x), x, zeros(size(x)))';

% Constraints
A_cons = jacobian(ineqCon, x);
b_cons = -subs(ineqCon, x, zeros(size(x)));

Aeq = jacobian(eqCon, x);
beq = -subs(eqCon, x, zeros(size(x)));

% Export Matlab functions
matlabFunction(H,'File','Hfunc','Vars',{Q,R,qdes,T})
matlabFunction(c,'File','cfunc','Vars',{Q,R,qdes,T})
matlabFunction(A_cons,'File','Afunc','Vars',{T,Fmax})
matlabFunction(b_cons,'File','bfunc','Vars',{T,Fmax})
matlabFunction(Aeq,'File','Aeqfunc','Vars',{q0,T,Fmax})
matlabFunction(beq,'File','beqfunc','Vars',{q0,T,Fmax})
matlabFunction(dq, "File", "odefun", "Vars", {t, q, u})
matlabFunction(eqs, "File", "eqs", "Vars", {t, q, u})