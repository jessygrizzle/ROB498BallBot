function [] = animate2D(t, phi, th, title)
% Animate according to provided timestamps and positions

r_k = 0.125;        % Ball radius
r_w = 0.06;         % Omniwheel radius
l = 0.339;          % Height of center of gravity

% calculate psi from phi and theta using linking equation
psi_func = @(phi, th) -((r_k/r_w)*(phi-th)-th);
psi = psi_func(phi, th);

FPS = 20;
t_anim = 0:1/FPS:max(t);
phi_anim = interp1(t, phi, t_anim);
th_anim = interp1(t, th, t_anim);
psi_anim = interp1(t, psi, t_anim);

v = VideoWriter(title, 'MPEG-4');
open(v);

figure();
for iter = 1:numel(t_anim)
    
    % Calculate location of the ball's center
    x_k = r_k * phi_anim(iter);
    y_k = r_k;
    
    % Calculate location of the wheel's center
    x_w = x_k + sin(th_anim(iter))*(r_k+r_w);
    y_w = y_k + cos(th_anim(iter))*(r_k+r_w);
    
    % Calculate location of the ball bot's center of mass
    x_a = x_k + sin(th_anim(iter))*l;
    y_a = y_k + cos(th_anim(iter))*l;
    
    % Plot ball, wheel, and ball bot as circles of representative radii
    viscircles([x_k, y_k], r_k, 'Color', "#FFA500");
    hold on
    viscircles([x_w, y_w], r_w, 'Color', "#FFCB05");
    viscircles([x_a, y_a], 0.01, 'Color', "#000000");
    
    % Plot indicator for ball rotation
    ind_k_x = [x_k, x_k + r_k*sin(phi_anim(iter))];
    ind_k_y = [y_k, y_k + r_k*cos(phi_anim(iter))];
    plot(ind_k_x, ind_k_y, '-k');
    
    % Plot indicator for wheel rotation
    ind_w_x = [x_w, x_w + r_w*sin(psi_anim(iter))];
    ind_w_y = [y_w, y_w + r_w*cos(psi_anim(iter))];
    plot(ind_w_x, ind_w_y, '-k');
    
    % Move the axes with respect to the ball to avoid very wide plots
    axis equal
    xlabel('x (m)');
    ylabel('z (m)');
    axis([x_k-1, x_k+1, -l, 2*r_k+l])
    drawnow
    
    frame = getframe(gcf);
    writeVideo(v, frame);
    hold off
    cla
end
close(v);