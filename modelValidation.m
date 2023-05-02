clear
close all

%% Dynamics Functions for Validation Scenarios
% dynamics function with zero torque
odeNoInput = @(t, q) dynamfunc(t, q, 0);

% dynamics function with constant torque
odeConstInput = @(t, q) dynamfunc(t, q, 3);


%% Validation Scenario 1
% simulation with no torque from upright equilibrium
[tout, qout] = ode45(odeNoInput, [0 10], [0 0 0 0]');
% animate2D(tout, qout(:,1), qout(:,3), 'upright_no_torque_2D.mp4');
upright_energy = calculateEnergies(qout(:,2), qout(:,3), qout(:,4));
figure
plot(tout, upright_energy);
ylim([upright_energy(1)-1 upright_energy(1)+1]);
ylabel('Total System Energy (J)');
xlabel('Time (s)');
grid on


%% Validation Scenario 2
% simulation with no torque from left of equilibrium
[tout, qout] = ode45(odeNoInput, [0 30], [0 0 -0.2 0]');
% animate2D(tout, qout(:,1), qout(:,3), 'left_no_torque_2D.mp4');
tilted_energy = calculateEnergies(qout(:,2), qout(:,3), qout(:,4));
figure
plot(tout, tilted_energy);
ylim([tilted_energy(1)-1 tilted_energy(1)+1]);
ylabel('Total System Energy (J)');
xlabel('Time (s)');
grid on

figure
subplot(4,1,1);
plot(tout, qout(:,1));
xlabel('Time (s)')
ylabel('\phi (rad)')
title('Ball angle (\phi) over time')

subplot(4,1,2);
plot(tout, qout(:,2));
xlabel('Time (s)')
ylabel('d\phi/dt (rad/s)')
title('Ball velocity (d\phi/dt) over time')

subplot(4,1,3);
plot(tout, qout(:,3));
xlabel('Time (s)')
ylabel('\theta (rad)')
title('Lean angle (\theta) over time')

subplot(4,1,4);
plot(tout, qout(:,4));
xlabel('Time (s)')
ylabel('d\theta/dt (rad/s)')
title('Lean velocity (d\theta/dt) over time')

% legend("\phi", "d\phi", "\theta", "d\theta");
% ylabel('Angle (rad)');
% xlabel('Time (s)');


%% Validation Scenario 3
% simulation with no torque with initial velocity
[tout, qout] = ode45(odeNoInput, [0 30], [0 -2 -4 0]');
% animate2D(tout, qout(:,1), qout(:,3), 'velocity_no_torque_2D.mp4');
moving_energy = calculateEnergies(qout(:,2), qout(:,3), qout(:,4));
figure
plot(tout, moving_energy);
ylim([moving_energy(1)-1 moving_energy(1)+1]);
ylabel('Total System Energy (J)');
xlabel('Time (s)');
grid on

plot(tout, qout);
legend("\phi", "d\phi", "\theta", "d\theta");
ylabel('Angle (rad)');
xlabel('Time (s)');

figure
subplot(4,1,1);
plot(tout, qout(:,1));
xlabel('Time (s)')
ylabel('\phi (rad)')
title('Ball angle (\phi) over time')

subplot(4,1,2);
plot(tout, qout(:,2));
xlabel('Time (s)')
ylabel('d\phi/dt (rad/s)')
title('Ball velocity (d\phi/dt) over time')

subplot(4,1,3);
plot(tout, qout(:,3));
xlabel('Time (s)')
ylabel('\theta (rad)')
title('Lean angle (\theta) over time')

subplot(4,1,4);
plot(tout, qout(:,4));
xlabel('Time (s)')
ylabel('d\theta/dt (rad/s)')
title('Lean velocity (d\theta/dt) over time')


%% Validation Scenario 4
% simulation with constant torque  from right of equilibrium
[tout, qout] = ode45(odeConstInput, [0 10], [0 0 0.5 0]');
% animate2D(tout, qout(:,1), qout(:,3), 'right_const_torque_2D.mp4');