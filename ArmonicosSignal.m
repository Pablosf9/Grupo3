% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Ejercicio 2.3 - Generar y Analizar Señal con Armónicos
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández

clear; close all; clc;

fs = 2000; f0 = 50; Vp = 325; T = 0.5;
t = 0:1/fs:T-1/fs; N = numel(t);

% Señal compuesta: fundamental + 3º (15%) + 5º (10%)
v = Vp*sin(2*pi*f0*t) ...
  + 0.15*Vp*sin(2*pi*3*f0*t) ...
  + 0.10*Vp*sin(2*pi*5*f0*t);

% Análisis de armónicos (1..10)
[tabla, THD_pct, df] = analisis_armonicos(v, fs, f0, 10);

% Calcular % respecto al fundamental
V1 = tabla.Magnitud_V(tabla.Armonico==1);
Porc = 100 * (tabla.Magnitud_V / V1);
tabla.Porcentaje = round(Porc,2);

disp(tabla);
fprintf('THD medido = %.2f %% | THD teórico ≈ 18%%\n', THD_pct);

% --- Gráficas ---
figure('Name','Ejercicio 2.3');
subplot(2,1,1);
t_ms = t*1000;
plot(t_ms(t_ms<=4*(1000/f0)), v(t_ms<=4*(1000/f0)),'LineWidth',1);
xlabel('Tiempo (ms)'); ylabel('Voltaje (V)');
title('Señal temporal (primeros 4 ciclos)'); grid on;

subplot(2,1,2);
bar(tabla.Armonico, tabla.Magnitud_V);
xlabel('Número de Armónico'); ylabel('Magnitud (V)');
title('Espectro de Armónicos (1..10)'); grid on;