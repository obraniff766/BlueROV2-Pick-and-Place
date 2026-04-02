eta_refPID = PID.eta_ref.Data;
etaPID     = PID.eta;
eta_refCTC = CTC.eta_ref.Data;
etaCTC     = CTC.eta;
eta_refBSSM = BSSM.eta_ref.Data;
etaBSSM     = BSSM.eta;

x_refPID     = eta_refPID(:,1);
y_refPID     = eta_refPID(:,2);
z_refPID     = eta_refPID(:,3);
phi_refPID   = eta_refPID(:,4);
theta_refPID = eta_refPID(:,5);
psi_refPID   = eta_refPID(:,6);

x_refCTC     = eta_refCTC(:,1);
y_refCTC     = eta_refCTC(:,2);
z_refCTC     = eta_refCTC(:,3);
phi_refCTC   = eta_refCTC(:,4);
theta_refCTC = eta_refCTC(:,5);
psi_refCTC   = eta_refCTC(:,6);

x_refBSSM     = eta_refBSSM(:,1);
y_refBSSM     = eta_refBSSM(:,2);
z_refBSSM     = eta_refBSSM(:,3);
phi_refBSSM   = eta_refBSSM(:,4);
theta_refBSSM = eta_refBSSM(:,5);
psi_refBSSM   = eta_refBSSM(:,6);

x_PID     = etaPID(:,1);
y_PID     = etaPID(:,2);
z_PID     = etaPID(:,3);
phi_PID   = etaPID(:,4);
theta_PID = etaPID(:,5);
psi_PID   = etaPID(:,6);

x_CTC     = etaCTC(:,1);
y_CTC      = etaCTC(:,2);
z_CTC      = etaCTC(:,3);
phi_CTC    = etaCTC(:,4);
theta_CTC  = etaCTC(:,5);
psi_CTC    = etaCTC(:,6);

x_BSSM     = etaBSSM(:,1);
y_BSSM      = etaBSSM(:,2);
z_BSSM      = etaBSSM(:,3);
phi_BSSM    = etaBSSM(:,4);
theta_BSSM  = etaBSSM(:,5);
psi_BSSM    = etaBSSM(:,6);

dx = 1.5;
dy = 1.5;
dz = 1.0;
% PID
figure('Name','BlueROV2 Trajectory PID Controller','NumberTitle','off');

plot3(x_refPID, y_refPID, z_refPID, 'r', 'LineWidth', 2); hold on;
plot3(x_PID,     y_PID,     z_PID,     'b--', 'LineWidth', 1.5);

grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Desired vs Actual Trajectory');
legend('Desired','Actual');
xlim([-12, 12])
ylim([-12, 12])
zlim([-20, 2])

plot3([10 10+dx], [0 0+dy], [0 0-dz], ...
      'k-', 'LineWidth', 1.2);
plot3([10 10+dx], [0 0+dy], [-5 -5+dz], ...
      'k-', 'LineWidth', 1.2);
plot3([10 10+dx], [0 0+dy], [-15 -15+dz], ...
      'k-', 'LineWidth', 1.2);
text(10+dx, 0+dy, 0-dz, ...
     'UUV Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -5+dz, ...
     'Desired Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -15+dz, ...
     'Desired End', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);

view(45, 25); 

% Euler Angles

figure('Name','Euler Angles PID Controller','NumberTitle','off');

subplot(3,1,1);
plot(phi_refPID, 'r', 'LineWidth', 2); hold on;
plot(phi_PID,     'b', 'LineWidth', 1.5);
ylabel('\phi (rad)');
title('Roll'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

subplot(3,1,2);
plot(theta_refPID, 'r', 'LineWidth', 2); hold on;
plot(theta_PID,     'b', 'LineWidth', 1.5);
ylabel('\theta (rad)');
title('Pitch'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

subplot(3,1,3);
plot(psi_refPID, 'r', 'LineWidth', 2); hold on;
plot(psi_PID,     'b', 'LineWidth', 1.5);
ylabel('\psi (rad)');
xlabel('Samples');
title('Yaw'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-20 20]);
%drawnow;
% CTC

figure('Name','BlueROV2 Trajectory CTC Controller','NumberTitle','off');

plot3(x_refCTC, y_refCTC, z_refCTC, 'r', 'LineWidth', 2); hold on;
plot3(x_CTC,     y_CTC,     z_CTC,     'b--', 'LineWidth', 1.5);

grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Desired vs Actual Trajectory');
legend('Desired','Actual');

xlim([-12, 12])
ylim([-12, 12])
zlim([-20, 2])
plot3([10 10+dx], [0 0+dy], [0 0-dz], ...
      'k-', 'LineWidth', 1.2);
plot3([10 10+dx], [0 0+dy], [-5 -5+dz], ...
      'k-', 'LineWidth', 1.2);
plot3([10 10+dx], [0 0+dy], [-15 -15+dz], ...
      'k-', 'LineWidth', 1.2);
text(10+dx, 0+dy, 0-dz, ...
     'UUV Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -5+dz, ...
     'Desired Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -15+dz, ...
     'Desired End', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);

view(45, 25);

% Euler Angles

figure('Name','Euler Angles CTC Controller','NumberTitle','off');

subplot(3,1,1);
plot(phi_refCTC, 'r', 'LineWidth', 2); hold on;
plot(phi_CTC,     'b', 'LineWidth', 1.5);
ylabel('\phi (rad)');
title('Roll'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

subplot(3,1,2);
plot(theta_refCTC, 'r', 'LineWidth', 2); hold on;
plot(theta_CTC,     'b', 'LineWidth', 1.5);
ylabel('\theta (rad)');
title('Pitch'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

subplot(3,1,3);
plot(psi_refCTC, 'r', 'LineWidth', 2); hold on;
plot(psi_CTC,     'b', 'LineWidth', 1.5);
ylabel('\psi (rad)');
xlabel('Samples');
title('Yaw'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

% BSSM

figure('Name','BlueROV2 Trajectory Backstepping Sliding Mode Controller','NumberTitle','off');

plot3(x_refBSSM, y_refBSSM, z_refBSSM, 'r', 'LineWidth', 2); hold on;
plot3(x_BSSM,     y_BSSM,     z_BSSM,     'b--', 'LineWidth', 1.5);

grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Desired vs Actual Trajectory');
legend('Desired','Actual');
xlim([-12, 12])
ylim([-12, 12])
zlim([-20, 0])
plot3([10 10+dx], [0 0+dy], [0 0-dz], ...
      'k-', 'LineWidth', 1.2);
plot3([10 10+dx], [0 0+dy], [-5 -5+dz], ...
      'k-', 'LineWidth', 1.2);
plot3([10 10+dx], [0 0+dy], [-15 -15+dz], ...
      'k-', 'LineWidth', 1.2);
text(10+dx, 0+dy, 0-dz, ...
     'UUV Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -5+dz, ...
     'Desired Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -15+dz, ...
     'Desired End', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
view(45, 25);

% Euler Angles

figure('Name','Euler Angles Backstepping Sliding Mode Controller','NumberTitle','off');

subplot(3,1,1);
plot(phi_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(phi_BSSM,     'b', 'LineWidth', 1.5);
ylabel('\phi (rad)');
title('Roll'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

subplot(3,1,2);
plot(theta_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(theta_BSSM,     'b', 'LineWidth', 1.5);
ylabel('\theta (rad)');
title('Pitch'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

subplot(3,1,3);
plot(psi_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(psi_BSSM,     'b', 'LineWidth', 1.5);
ylabel('\psi (rad)');
xlabel('Samples');
title('Yaw'); legend('Desired','Actual'); grid on;
xlim([0, 30000]);
ylim([-4 4]);

figure('Name','BlueROV2 Trajectory – All Controllers','NumberTitle','off');

% Desired trajectories
plot3(x_refPID,  y_refPID,  z_refPID,  'r', 'LineWidth', 2); hold on;

% Actual trajectories
plot3(x_PID,  y_PID,  z_PID,  'b--', 'LineWidth', 1.5);
plot3(x_CTC,  y_CTC,  z_CTC,  'g--', 'LineWidth', 1.5);
plot3(x_BSSM, y_BSSM, z_BSSM, 'm--', 'LineWidth', 1.5);

grid on; axis equal;
xlabel('X (m)'); ylabel('Y (m)'); zlabel('Z (m)');
title('Desired vs Actual Trajectory');
legend('Desired','PID','CTC','BacksteppingsSMC');
xlim([-12, 12])
ylim([-12, 12])
zlim([-20, 0])
plot3([10 10+dx], [0 0+dy], [0 0-dz], ...
      'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot3([10 10+dx], [0 0+dy], [-5 -5+dz], ...
      'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
plot3([10 10+dx], [0 0+dy], [-15 -15+dz], ...
      'k-', 'LineWidth', 1.2, 'HandleVisibility', 'off');
text(10+dx, 0+dy, 0-dz, ...
     'UUV Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -5+dz, ...
     'Desired Start', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
text(10+dx, 0+dy, -15+dz, ...
     'Desired End', ...
     'FontSize', 10, ...
     'BackgroundColor', 'w', ...
     'Margin', 2);
view(45,25);

err_PID  = PID.error;
err_CTC  = CTC.error;
err_BSSM = BSSM.error;

c_pid  = 'b';
c_ctc  = 'r';
c_bssm = 'g';

figure('Name','Linear Errors Comparison','NumberTitle','off');

subplot(3,2,1);
plot(err_PID(:,1),  c_pid, 'LineWidth', 1.5); hold on;
plot(err_CTC(:,1),  c_ctc, 'LineWidth', 1.5);
plot(err_BSSM(:,1), c_bssm, 'LineWidth', 1.5);
ylabel('e_x (m)'); grid on;
title('Error: X');
legend('PID','CTC','BSSM');
xlim([0, 30000]);

subplot(3,2,2);
plot(err_PID(:,4),  c_pid, 'LineWidth', 1.5); hold on;
plot(err_CTC(:,4),  c_ctc, 'LineWidth', 1.5);
plot(err_BSSM(:,4), c_bssm, 'LineWidth', 1.5);
ylabel('e_\phi (rad)'); grid on;
title('Error: Roll');
legend('PID','CTC','BSSM');
xlim([0, 30000]);

subplot(3,2,3);
plot(err_PID(:,2),  c_pid, 'LineWidth', 1.5); hold on;
plot(err_CTC(:,2),  c_ctc, 'LineWidth', 1.5);
plot(err_BSSM(:,2), c_bssm, 'LineWidth', 1.5);
ylabel('e_y (m)'); grid on;
title('Error: Y');
xlim([0, 30000]);

subplot(3,2,4);
plot(err_PID(:,5),  c_pid, 'LineWidth', 1.5); hold on;
plot(err_CTC(:,5),  c_ctc, 'LineWidth', 1.5);
plot(err_BSSM(:,5), c_bssm, 'LineWidth', 1.5);
ylabel('e_\theta (rad)'); grid on;
title('Error: Pitch');
xlim([0, 30000]);

subplot(3,2,5);
plot(err_PID(:,3),  c_pid, 'LineWidth', 1.5); hold on;
plot(err_CTC(:,3),  c_ctc, 'LineWidth', 1.5);
plot(err_BSSM(:,3), c_bssm, 'LineWidth', 1.5);
ylabel('e_z (m)'); xlabel('Samples'); grid on;
title('Error: Z');
xlim([0, 30000]);

subplot(3,2,6);
plot(err_PID(:,6),  c_pid, 'LineWidth', 1.5); hold on;
plot(err_CTC(:,6),  c_ctc, 'LineWidth', 1.5);
plot(err_BSSM(:,6), c_bssm, 'LineWidth', 1.5);
ylabel('e_\psi (rad)'); xlabel('Samples'); grid on;
title('Error: Yaw');
xlim([0, 30000]);

figure('Name','Tracking Performance: PID Controller','NumberTitle','off');
subplot(3,2,1);
plot(x_refPID, 'r', 'LineWidth', 2); hold on;
plot(x_PID, 'b', 'LineWidth', 1.5);
ylabel('X (m)'); title('X'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,2);
plot(phi_refPID, 'r', 'LineWidth', 2); hold on;
plot(phi_PID, 'b', 'LineWidth', 1.5);
ylabel('\phi (rad)'); title('Roll'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,3);
plot(y_refPID, 'r', 'LineWidth', 2); hold on;
plot(y_PID, 'b', 'LineWidth', 1.5);
ylabel('Y (m)'); title('Y'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,4);
plot(theta_refPID, 'r', 'LineWidth', 2); hold on;
plot(theta_PID, 'b', 'LineWidth', 1.5);
ylabel('\theta (rad)'); title('Pitch'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,5);
plot(z_refPID, 'r', 'LineWidth', 2); hold on;
plot(z_PID, 'b', 'LineWidth', 1.5);
ylabel('Z (m)'); xlabel('Samples'); title('Z'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,6);
plot(psi_refPID, 'r', 'LineWidth', 2); hold on;
plot(psi_PID, 'b', 'LineWidth', 1.5);
ylabel('\psi (rad)'); xlabel('Samples'); title('Yaw'); legend('Desired','Actual'); grid on; xlim([0, 30000]);

figure('Name','Tracking Performance: CTC Controller','NumberTitle','off');
subplot(3,2,1);
plot(x_refCTC, 'r', 'LineWidth', 2); hold on;
plot(x_CTC, 'b', 'LineWidth', 1.5);
ylabel('X (m)'); title('X'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,2);
plot(phi_refCTC, 'r', 'LineWidth', 2); hold on;
plot(phi_CTC, 'b', 'LineWidth', 1.5);
ylabel('\phi (rad)'); title('Roll'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,3);
plot(y_refCTC, 'r', 'LineWidth', 2); hold on;
plot(y_CTC, 'b', 'LineWidth', 1.5);
ylabel('Y (m)'); title('Y'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,4);
plot(theta_refCTC, 'r', 'LineWidth', 2); hold on;
plot(theta_CTC, 'b', 'LineWidth', 1.5);
ylabel('\theta (rad)'); title('Pitch'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,5);
plot(z_refCTC, 'r', 'LineWidth', 2); hold on;
plot(z_CTC, 'b', 'LineWidth', 1.5);
ylabel('Z (m)'); xlabel('Samples'); title('Z'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,6);
plot(psi_refCTC, 'r', 'LineWidth', 2); hold on;
plot(psi_CTC, 'b', 'LineWidth', 1.5);
ylabel('\psi (rad)'); xlabel('Samples'); title('Yaw'); legend('Desired','Actual'); grid on; xlim([0, 30000]);

figure('Name','Tracking Performance: Backstepping Sliding Mode Controller','NumberTitle','off');
subplot(3,2,1);
plot(x_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(x_BSSM, 'b', 'LineWidth', 1.5);
ylabel('X (m)'); title('X'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,2);
plot(phi_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(phi_BSSM, 'b', 'LineWidth', 1.5);
ylabel('\phi (rad)'); title('Roll'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,3);
plot(y_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(y_CTC, 'b', 'LineWidth', 1.5);
ylabel('Y (m)'); title('Y'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,4);
plot(theta_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(theta_BSSM, 'b', 'LineWidth', 1.5);
ylabel('\theta (rad)'); title('Pitch'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,5);
plot(z_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(z_BSSM, 'b', 'LineWidth', 1.5);
ylabel('Z (m)'); xlabel('Samples'); title('Z'); legend('Desired','Actual'); grid on; xlim([0, 30000]);
subplot(3,2,6);
plot(psi_refBSSM, 'r', 'LineWidth', 2); hold on;
plot(psi_BSSM, 'b', 'LineWidth', 1.5);
ylabel('\psi (rad)'); xlabel('Samples'); title('Yaw'); legend('Desired','Actual'); grid on; xlim([0, 30000]);