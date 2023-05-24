clear
close all

%% Dynamics Function Generation
syms m_tot m_k m_a m_w  % Mass parameters
syms r_tot r_k r_w      % Radius parameters
syms TH_k TH_w TH_a     % Inertial parameters
syms gam l g            % Misc parameters
syms t y                % Simulation parameters

% Symbolic state and input vectors
q = sym('q', [4, 1]);
u = sym('u', [1, 1]);

% Mass term in Langrangian formulation (Eqn. 2.22)
M_x = [m_tot*r_k^2 + TH_k + (r_k/r_w)^2*TH_w, -(r_k/(r_w^2))*r_tot*TH_w+gam*r_k*cos(q(3)); ...
    -(r_k/(r_w^2))*r_tot*TH_w+gam*r_k*cos(q(3)), ((r_tot^2)/(r_w^2))*TH_w + TH_a + m_a*l^2 + m_w*r_tot^2];

% Coriolis term in Langrangian formulation (Eqn. 2.23)
C_x = [-r_k*gam*sin(q(3))*q(4)^2; 0];

% Gravitational term in Lagrangian formulation (Eqn. 2.24)
G_x = [0; -g*sin(q(3))*gam];

% Non-potential force term in Lagrangian formulation (Eqn. 2.17 + Eqn. 2.18)
f_np = [(r_k/r_w)*u; u-(1+(r_k/r_w))*u];

% Solve for ddq in M(q, dq)*ddq + C(q, dq) + G(q) = f_np, simplify
ddq = M_x\(f_np - G_x - C_x);
ddq = subs(ddq, {m_tot, r_tot, gam}, {m_k+m_a+m_w, r_k+r_w, l*m_a+(r_k+r_w)*m_w});

% Substitute in values for physical parameters
ddq = subs(ddq, {TH_a,TH_k,TH_w,g,l,m_a,m_k,m_w,r_k,r_w}, {4.76, 0.0239, 0.00236, 9.81, 0.339, 9.2, 2.29, 3, 0.125, 0.06});

% Full dynamics equation
dynamics = [q(2); ddq(1); q(4); ddq(2)];


%% MPC Function Generation
N = 21; % Number of nodes

% Define symbolic variables for every state at each node
qN = sym('qN', [4, N]);
uN = sym('uN', [1, N]);
q0 = sym('q0', [4, 1]);

% Linearized dynamics at current state q0
A = subs(jacobian(dynamics, q), {u(1), q(1), q(2), q(3), q(4)}, {0, q0(1), q0(2), q0(3), q0(4)});
B = subs(jacobian(dynamics, u(1)), {u(1), q(1), q(2), q(3), q(4)}, {0, q0(1), q0(2), q0(3), q0(4)});

% Linearized dynamics at current state q0 up for every state at each node
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
syms thmax; % Max lean angle
syms dphimax; % Max wheel velocity

% IC constraints
ic_constraint = q0-qN(:, 1);

% Inequality constraints on force and lean angle
limit_constraints = [uN(:) - Fmax; -uN(:) - Fmax; qN(3, :)' - thmax; -qN(3, :)' - thmax; qN(2, :)' - dphimax; -qN(2, :)' - dphimax];

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


%% Export Matlab functions
matlabFunction(H,'File','Hfunc','Vars',{Q,R,qdes,T})
matlabFunction(c,'File','cfunc','Vars',{Q,R,qdes,T})
matlabFunction(A_cons,'File','Afunc','Vars',{T,Fmax,thmax,dphimax})
matlabFunction(b_cons,'File','bfunc','Vars',{T,Fmax,thmax,dphimax})
matlabFunction(Aeq,'File','Aeqfunc','Vars',{q0,T,Fmax,thmax,dphimax})
matlabFunction(beq,'File','beqfunc','Vars',{q0,T,Fmax,thmax,dphimax})
matlabFunction(dynamics, "File", "dynamfunc", "Vars", {t, q, u})