% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Ejercicio 2.2.3 - Detección de Variaciones de Tensión
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández
clear; close all; clc;

%% --- Función RMS deslizante ---
function [v_rms, t_rms] = rmsDeslizante(v, fs, ventana_ms)
    % Calcula el RMS deslizante de una señal
    % Entradas:
    %   v → señal
    %   fs → frecuencia de muestreo [Hz]
    %   ventana_ms → tamaño de la ventana [ms]
    % Salidas:
    %   v_rms → vector de valores RMS
    %   t_rms → vector de tiempos asociados

    Nw = round((ventana_ms / 1000) * fs);   % muestras por ventana
    v2 = v.^2;
    v_rms = sqrt(movmean(v2, Nw));
    t_rms = (0:length(v)-1)/fs;
end

%% --- Señal con hueco de tensión para ver el cálculo de RMS en varios casos ---
fs = 2000; t_total = 0.2;
t = 0:1/fs:t_total;
f = 50; Vp = 325;

v = Vp * sin(2*pi*f*t);
% Hueco del 50% entre 50 y 100 ms
v((t >= 0.05) & (t < 0.1)) = 0.5 * Vp * sin(2*pi*f*t((t >= 0.05) & (t < 0.1)));

%% --- Calcular RMS deslizante ---
[vrms, t_rms] = rmsDeslizante(v, fs, 20); % ventana 20 ms

%% --- Gráficas ---
figure;
subplot(2,1,1);
plot(t*1000, v, 'k');
xlabel('Tiempo [ms]'); ylabel('Tensión [V]');
title('Señal con hueco de tensión (50% - 50 ms)'); grid on;

subplot(2,1,2);
plot(t_rms*1000, vrms, 'b', 'LineWidth', 1.2);
hold on;
yline(230, 'g--', 'Nominal (230 V)');
yline(207, 'r--', 'Límite -10% (207 V)');
xlabel('Tiempo [ms]'); ylabel('RMS [V]');
title('Valor RMS deslizante (Ventana 20 ms)');
legend('RMS','Nominal','Límite -10%','Location','best');
grid on;
