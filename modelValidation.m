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
animate2D(tout, qout(:,1), qout(:,3), 'upright_no_torque_2D.mp4');
upright_energy = calculateEnergies(qout(:,2), qout(:,3), qout(:,4));
figure
plot(tout, upright_energy);
ylim([upright_energy(1)-1 upright_energy(1)+1]);
ylabel('Total System Energy (J)');
xlabel('Time (s)');
grid on


%% Validation Scenario 2
% simulation with no torque from left of equilibrium
[tout, qout] = ode45(odeNoInput, [0 10], [0 0 -0.2 0]');
animate2D(tout, qout(:,1), qout(:,3), 'left_no_torque_2D.mp4');
tilted_energy = calculateEnergies(qout(:,2), qout(:,3), qout(:,4));
figure
plot(tout, tilted_energy);
ylim([tilted_energy(1)-1 tilted_energy(1)+1]);
ylabel('Total System Energy (J)');
xlabel('Time (s)');
grid on


%% Validation Scenario 3
% simulation with no torque with initial velocity
[tout, qout] = ode45(odeNoInput, [0 10], [0 -2 -4 0]');
animate2D(tout, qout(:,1), qout(:,3), 'velocity_no_torque_2D.mp4');
moving_energy = calculateEnergies(qout(:,2), qout(:,3), qout(:,4));
figure
plot(tout, moving_energy);
ylim([moving_energy(1)-1 moving_energy(1)+1]);
ylabel('Total System Energy (J)');
xlabel('Time (s)');
grid on


%% Validation Scenario 4
% simulation with constant torque  from right of equilibrium
[tout, qout] = ode45(odeConstInput, [0 10], [0 0 0.5 0]');
animate2D(tout, qout(:,1), qout(:,3), 'right_const_torque_2D.mp4');