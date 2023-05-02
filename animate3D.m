function [] = animate3D(t, phi_x, phi_y, th_x, th_y, title)
% Animate according to provided timestamps and positions
r_k = 0.125;        % Ball radius
r_w = 0.06;         % Omniwheel radius
l = 0.339;          % Height of center of gravity

% calculate psi from phi and theta using linking equation
psi_func = @(phi, th) -((r_k/r_w)*(phi-th)-th);
psi_x = psi_func(phi_x, th_x);
psi_y = psi_func(phi_y, th_y);

FPS = 60;
t_anim = 0:1/FPS:max(t);
phi_x_anim = interp1(t, phi_x, t_anim);
phi_y_anim = interp1(t, phi_y, t_anim);
th_x_anim = interp1(t, th_x, t_anim);
th_y_anim = interp1(t, th_y, t_anim);
psi_x_anim = interp1(t, psi_x, t_anim);
psi_y_anim = interp1(t, psi_y, t_anim);


%% Generate a mesh of a sphere to represent the basketball
u = linspace(0, pi, 20);
v = linspace(0, 2*pi, 40);
[bball_U, bball_V] = meshgrid(u, v);

ball_func = @(r, u, v) [r.*sin(u).*cos(v), r.*sin(u).*sin(v), r.*cos(u)];
bball = ball_func(r_k, bball_U(:), bball_V(:))';

mass_func = @(r, u, v) [r.*sin(u).*cos(v), r.*sin(u).*sin(v), r.*cos(u)+l];
pmass = mass_func(0.02, bball_U(:), bball_V(:))';


%% Generate meshes of the wheels
u = linspace(-0.0125, 0.0125, 2);
v = linspace(0, 2*pi, 40);
[wheel_U, wheel_V] = meshgrid(u, v);

wheel_x_func = @(r, u, v) [r.*sin(v), u, r.*cos(v)];
wheel_x = wheel_x_func(r_w, wheel_U(:), wheel_V(:))';

wheel_y_func = @(r, u, v) [u, r.*sin(v), r.*cos(v)];
wheel_y = wheel_y_func(r_w, wheel_U(:), wheel_V(:))';


%% Calculate positions and record animation
v = VideoWriter(title, 'MPEG-4');
open(v);

figure();
for iter = 1:numel(t_anim)
    bball_x = r_k * phi_y_anim(iter);
    bball_y = r_k * phi_x_anim(iter);
    bball_z = r_k;
    bball_transformed = transform_3D(bball, bball_y, bball_x, bball_z, phi_x_anim(iter), 0, phi_y_anim(iter), size(bball_U));
    surf(bball_transformed(:, :, 1), bball_transformed(:, :, 2), bball_transformed(:, :, 3), "FaceColor", "#FFA500")
    
    wheel_x_trans_1 = transform_3D(wheel_x, 0, 0, r_k+r_w, psi_x_anim(iter), 0, 0, size(wheel_U));
    wheel_y_trans_1 = transform_3D(wheel_y, 0, 0, r_k+r_w, 0, 0, psi_y_anim(iter), size(wheel_U));
    
    wheel_x_trans_1 = [reshape(wheel_x_trans_1(:, :, 1), 1, []); reshape(wheel_x_trans_1(:, :, 2), 1, []); reshape(wheel_x_trans_1(:, :, 3), 1, [])];
    wheel_y_trans_1 = [reshape(wheel_y_trans_1(:, :, 1), 1, []); reshape(wheel_y_trans_1(:, :, 2), 1, []); reshape(wheel_y_trans_1(:, :, 3), 1, [])];
    
    wheel_x_trans_2 = transform_3D(wheel_x_trans_1, bball_y, bball_x, bball_z, th_x_anim(iter), th_y_anim(iter), 0, size(wheel_U));
    wheel_y_trans_2 = transform_3D(wheel_y_trans_1, bball_y, bball_x, bball_z, th_x_anim(iter), th_y_anim(iter), 0, size(wheel_U));
    
    pmass_trans = transform_3D(pmass, bball_y, bball_x, bball_z, th_x_anim(iter), th_y_anim(iter), 0, size(bball_U));
    
    hold on
    surf(wheel_x_trans_2(:, :, 1), wheel_x_trans_2(:, :, 2), wheel_x_trans_2(:, :, 3), "FaceColor", "#FFCB05");
    surf(wheel_y_trans_2(:, :, 1), wheel_y_trans_2(:, :, 2), wheel_y_trans_2(:, :, 3), "FaceColor", "#FFCB05");
    surf(pmass_trans(:, :, 1), pmass_trans(:, :, 2), pmass_trans(:, :, 3), "EdgeColor", "None", "FaceColor", "#000000");
    
    
    % Move the axes with respect to the ball to avoid very wide plots
    axis equal
    xlim([-0.2 0.8])
    ylim([-0.2 0.8])
    xlabel('x (m)')
    ylabel('y (m)')
    zlabel('z (m)')
    axis([r_k*min(phi_x)-l, r_k*max(phi_x)+l, r_k*min(phi_y)-l, r_k*max(phi_y)+l, -0.01, r_k+l+0.05])
    view([10, 25]) % 10 25
    drawnow
    
    frame = getframe(gcf);
    writeVideo(v, frame);
    hold off
    cla
end
close(v);