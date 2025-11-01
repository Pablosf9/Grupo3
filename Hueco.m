% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Actividad Guiada 2.3 - Análisis de un Hueco de Tensión
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández
clear; close all; clc;

%% --- Parámetros básicos ---
fs = 2000;             % Frecuencia de muestreo [Hz]
t_total = 0.2;         % Duración total [s]
t = 0:1/fs:t_total;
f = 50; Vp = 325;

%% --- Generar señal base ---
v = Vp * sin(2*pi*f*t);

%% --- Introducir hueco de tensión ---
inicio_hueco = 0.05;   % 50 ms
duracion_hueco = 0.05; % 50 ms (2.5 ciclos)
fin_hueco = inicio_hueco + duracion_hueco;

idx_hueco = (t >= inicio_hueco) & (t < fin_hueco);
v(idx_hueco) = 0.5 * Vp * sin(2*pi*f*t(idx_hueco)); % profundidad 50%

%% --- Función RMS deslizante (reutilizada del ejercicio anterior) ---
function [v_rms, t_rms] = rmsDeslizante(v, fs, ventana_ms)
    Nw = round((ventana_ms / 1000) * fs);
    v2 = v.^2;
    v_rms = sqrt(movmean(v2, Nw));
    t_rms = (0:length(v)-1)/fs;
end

%% --- Cálculo del RMS deslizante ---
[vrms, t_rms] = rmsDeslizante(v, fs, 20);

%% --- Cálculos de análisis ---
[Vrms_min, idx_min] = min(vrms);
t_inicio_evento = t(find(vrms < 230*0.99, 1, 'first'));
t_fin_evento = t(find(vrms > 230*0.99 & t > fin_hueco, 1, 'first'));
duracion_evento = t_fin_evento - t_inicio_evento;

%% --- Mostrar resultados ---
fprintf('Inicio del hueco detectado: %.2f ms\n', t_inicio_evento*1000);
fprintf('Valor RMS mínimo: %.2f V\n', Vrms_min);
fprintf('Duración hasta recuperación: %.2f ms\n', duracion_evento*1000);
fprintf('Hueco supera límite -10%%: %s\n', string(Vrms_min < 207));

%% --- Visualización ---
figure;
subplot(2,1,1);
plot(t*1000, v, 'k');
xlabel('Tiempo [ms]'); ylabel('Tensión [V]');
title('Señal con Hueco de Tensión (50%, 50 ms)');
grid on;

subplot(2,1,2);
plot(t_rms*1000, vrms, 'b', 'LineWidth', 1.3); hold on;
yline(230, 'g--', 'Nominal 230 V');
yline(207, 'r--', 'Límite -10%');
xline(inicio_hueco*1000, 'k--', 'Inicio Hueco');
xline(fin_hueco*1000, 'k--', 'Fin Hueco');
xlabel('Tiempo [ms]'); ylabel('RMS [V]');
title('Valor RMS Deslizante (Ventana 20 ms)');
legend('RMS','Nominal','Límite -10%','Ubicación del Hueco');
grid on;
