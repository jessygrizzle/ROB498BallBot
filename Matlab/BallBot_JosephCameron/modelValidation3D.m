clear
close all

%% Dynamics Functions for Validation Scenarios
% combining x and y planar dynamics into one dynamics function
dynamics3D = @(time, q3D, u3D) [dynamfunc(time, q3D(1:4), u3D(1)); dynamfunc(time, q3D(5:8), u3D(2))];

% dynamics function with zero torque
odeNoInput = @(t, q) dynamics3D(t, q, [0; 0]);

% dynamics function with constant torque
odeConstInput = @(t, q) dynamics3D(t, q, [3; 0]);


%% Validation Scenario 1
% simulation with no torque with initial velocity
[tout, qout] = ode45(odeNoInput, [0 10], [0 -1.5 -0.1 0.2 0 -0.3 0 0]');
animate3D(tout, qout(:,1), qout(:,5), qout(:,3), qout(:,7), 'initial_velocity_no_torque.mp4');
moving_energy_x = calculateEnergies(qout(:,2), qout(:,3), qout(:,4));
moving_energy_y = calculateEnergies(qout(:,6), qout(:,7), qout(:,8));
figure
plot(tout, moving_energy_x + moving_energy_y);
ylim([moving_energy_x(1)+moving_energy_y(1)-1 moving_energy_x(1)+moving_energy_y(1)+1]);
ylabel('Total System Energy (J)');
xlabel('Time (s)');
grid on


%% Validation Scenario 2
% simulation with constant torque from right of equilibrium
[tout, qout] = ode45(odeConstInput, [0 2], [0 0 0.5 0 0 0 0.5 0]');
animate3D(tout, qout(:,1), qout(:,5), qout(:,3), qout(:,7), 'const_torque.mp4');
