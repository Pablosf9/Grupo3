%% Listado de problemas transitorios
% Grupo 3: Nadia Rotbi Prado, Pablo Segura Fernandez y Encarnación
% Cervantes Requena
% Itinerario de Eléctrica
clc, clear, close all
%% Parámetros del circuito
R = 500;          % Ohmios
L = 50e-3;        % Henrios
C = 2e-6;         % Faradios
V_in = 24;        % Voltaje escalón

%% Tiempo de simulación
t = 0:1e-5:0.02;  % 0 a 20 ms

%% Ecuaciones de estado
% x1 = corriente i(t)
% x2 = tensión en el condensador vC(t)
% dx1/dt = (V_in - R*x1 - x2)/L
% dx2/dt = x1/C
dxdt = @(t,x) [(V_in - R*x(1) - x(2))/L; x(1)/C];

%% Condiciones iniciales: i(0)=0, vC(0)=0
x0 = [0;0];

%% Resolver ODE
[t_sol, x] = ode45(dxdt, t, x0);

i = x(:,1);     % Corriente en la bobina
vC = x(:,2);    % Tensión en el condensador

%% Graficar resultados
figure;
subplot(2,1,1)
plot(t_sol, vC, 'r','LineWidth',1.5)
grid on
xlabel('Tiempo (s)')
ylabel('Tensión en el condensador (V)')
title('Respuesta del condensador ante un escalón de 24 V')

subplot(2,1,2)
plot(t_sol, i, 'b','LineWidth',1.5)
grid on
xlabel('Tiempo (s)')
ylabel('Corriente en la bobina (A)')
title('Corriente en la bobina ante un escalón de 24 V')

%% Representación en el plano S
% Se define la función de transferencia del sistema
num = 1;
den = [L*C, R*C, 1];
TF = tf(num, den);

% Se obtienen polos y ceros y se muestran por pantalla
[p, z] = pzmap(TF);

disp('Polos del circuito:');
disp(p);
disp('Ceros del circuito:');
disp(z);
% NOTA: Si no hay ceros, no aparecerá ningún valor por pantalla

% Se representan en el plano S
figure;
pzmap(TF);
grid on;
title('Polos y ceros en el plano-s del Circuito RLC serie');

%% Diagrama de Bode
figure;
bode(TF);
grid on;
title('Diagrama de Bode del Circuito RLC serie');
