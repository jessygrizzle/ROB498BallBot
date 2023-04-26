clear
syms m_tot m_k m_a m_w  % Mass parameters
syms r_tot r_k r_w      % Radius parameters
syms TH_k TH_w TH_a     % Inertial parameters
syms gam l g            % Misc parameters
syms T_x(t) t y         % Simulation parameters

% Define the simulation state vector
y = sym('y', [4, 1]);   

% Mass term in Langrangian formulation (Eqn. 2.22)
M_x = [m_tot*r_k^2 + TH_k + (r_k/r_w)^2*TH_w, -(r_k/(r_w^2))*r_tot*TH_w+gam*r_k*cos(y(3)); ...
    -(r_k/(r_w^2))*r_tot*TH_w+gam*r_k*cos(y(3)), ((r_tot^2)/(r_w^2))*TH_w + TH_a + m_a*l^2 + m_w*r_tot^2];

% Coriolis term in Langrangian formulation (Eqn. 2.23)
C_x = [-r_k*gam*sin(y(3)*y(4)^2); 0];

% Gravitational term in Lagrangian formulation (Eqn. 2.24)
G_x = [0; -g*sin(y(3))*gam];

% Non-potential force term in Lagrangian formulation (Eqn. 2.17+Eqn. 2.18)
f_np = [(r_k/r_w)*T_x; T_x-(1+(r_k/r_w)*T_x)];

% Solve for ddq in M(q, dq)*ddq + C(q, dq) + G(q) = f_np, simplify
ddq = M_x\(f_np - G_x - C_x);
ddq = subs(ddq, {m_tot, r_tot, gam}, {m_k+m_a+m_w, r_k+r_w, l*m_a+(r_k+r_w)*m_w});
ddq = simplify(ddq) % Print to console for copying into simulation.m

ddq = subs(ddq, {TH_a,TH_k,TH_w,g,l,m_a,m_k,m_w,r_k,r_w}, {4.76, 0.0239, 0.00236, 9.81, 0.339, 9.2, 2.29, 3, 0.125, 0.06});
ddq = sym(ddq)
dydt = [y(2); ddq(1); y(4); ddq(2)];

T_x = 2.*t.^2;
matlabFunction(T_x, "File", "T_x", "Vars", {t});
matlabFunction(dydt, "File", "dydt", "Vars", {t, [y(1); y(2); y(3); y(4)]});