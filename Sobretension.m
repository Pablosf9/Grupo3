% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Ejercicio 4.3: Sobretensión por Conmutación de Condensadores
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández
clear; close all; clc;

%% 1. Generar la señal de sobretensión
% Parámetros básicos
fs = 10e3;               % Frecuencia de muestreo (10 kHz)
t_total = 0.4;           % Duración total [s]
t = 0:1/fs:t_total;      % Vector de tiempo
f = 50;                  % Frecuencia [Hz]
Vp = 325;                % Amplitud nominal [V pico]

% Sobretensión
inicio_evento = 0.150;   % [s]
duracion_evento = 0.080; % [s]
fin_evento = inicio_evento + duracion_evento;

% Señal base
v = Vp * sin(2*pi*f*t);

% Aumento del 25% durante el evento
indice_evento = (t >= inicio_evento) & (t <= fin_evento);
v(indice_evento) = 1.25 * Vp * sin(2*pi*f*t(indice_evento));

figure;
plot(t*1000, v);
xlabel('Tiempo [ms]');
ylabel('Tensión [V]');
title('Señal con sobretensión de 25% durante 80 ms');
grid on;

%% 2. Calcular RMS deslizante con ventanas de 10 ms y 20 ms
% Ventanas de 10 ms y 20 ms
ventana1 = round(0.010 * fs);
ventana2 = round(0.020 * fs);

% RMS deslizante
v_rms_10 = sqrt(movmean(v.^2, ventana1));
v_rms_20 = sqrt(movmean(v.^2, ventana2));

figure;
plot(t*1000, v_rms_10, 'b', 'DisplayName', 'Ventana 10 ms');
hold on;
plot(t*1000, v_rms_20, 'r', 'DisplayName', 'Ventana 20 ms');
xlabel('Tiempo [ms]');
ylabel('Tensión RMS [V]');
title('Cálculo de RMS deslizante');
legend;
grid on;

figure;
plot(t*1000, v, 'k', 'DisplayName', 'Señal original');
hold on;
plot(t*1000, v_rms_10, 'b', 'DisplayName', 'RMS 10 ms');
plot(t*1000, v_rms_20, 'r', 'DisplayName', 'RMS 20 ms');
xlabel('Tiempo [ms]');
ylabel('Tensión [V]');
title('Comparación de RMS con diferentes ventanas');
legend;
grid on;

