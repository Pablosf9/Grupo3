%% Listado de problemas transitorios
% Grupo 3: Nadia Rotbi Prado, Pablo Segura Fernandez y Encarnación
% Cervantes Requena
% Itinerario de Eléctrica
clc, clear, close all
%% Parámetros del circuito
R = 200;          % Ohmios
L = 0.1;          % Henrios
C = 100e-6;       % Faradios
V_dc = 10;        % Voltaje DC

%% Cálculo de alfa y omega0
alpha = R/(2*L);          % Coeficiente de amortiguamiento
omega0 = 1/sqrt(L*C);     % Frecuencia natural

fprintf('Alfa = %.2f rad/s\n', alpha);
fprintf('Omega0 = %.2f rad/s\n', omega0);

% Determinar tipo de amortiguamiento
if alpha > omega0
    tipo = 'Sobreamortiguado';
elseif alpha == omega0
    tipo = 'Críticamente amortiguado';
else
    tipo = 'Subamortiguado';
end
fprintf('El circuito es %s.\n', tipo);

%% Tiempo de simulación
t = 0:1e-4:0.1;  % ajustar según velocidad de respuesta

%% Ecuaciones de estado
% x1 = corriente i(t)
% x2 = tensión en el condensador vC(t)
dxdt = @(t,x) [(V_dc - R*x(1) - x(2))/L; x(1)/C];

%% Condiciones iniciales
x0 = [0;0];  % i(0) = 0, vC(0) = 0

%% Resolver ODE
[t_sol, x] = ode45(dxdt, t, x0);

i = x(:,1);     % Corriente en la bobina
vC = x(:,2);    % Tensión en el condensador

%% Graficar corriente
figure;
subplot(2,1,1)
plot(t_sol, vC, 'r','LineWidth',1.5)
grid on
xlabel('Tiempo (s)')
ylabel('Tensión en el condensador (V)')
title('Respuesta del condensador ante un escalón de 10 V')

subplot(2,1,2)
plot(t_sol, i, 'b','LineWidth',1.5)
grid on
xlabel('Tiempo (s)')
ylabel('Corriente en la bobina (A)')
title('Corriente en la bobina ante un escalón de 10 V')

%% Representación en el plano S
% Primero se define la función de transferencia del sistema
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

figure;
pzmap(TF);
grid on;
title('Polos y ceros en el plano-s del Circuito RLC serie');

%% Diagrama de Bode
figure;
bode(TF);
grid on;
title('Diagrama de Bode del Circuito RLC serie');

