% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Ejercicio 2.2.2 - Detección de Cruces por Cero
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández
clear; close all; clc;

%% --- Función para detectar cruces por cero ---
function [indices_cero, tiempos_cruce_interp, f_detectada] = detectarCrucesCero(v, t)
% Detecta cruces por cero con interpolación lineal para evitar acumular
% errores
% Entradas:
%   v : vector de la señal
%   t : vector de tiempos (misma longitud que v)
% Salidas:
%   indices_cero          : índices i tales que v(i) y v(i+1) tienen distinto signo
%   tiempos_cruce_interp  : tiempos estimados (en s) de los cruces por cero (interpolados)
%   f_detectada           : frecuencia estimada [Hz]

    s = sign(v);
    s(s==0) = 1; 
    idx = find(diff(s) ~= 0); 

    if isempty(idx)
        indices_cero = [];
        tiempos_cruce_interp = [];
        f_detectada = NaN;
        return;
    end

    indices_cero = idx;

    % Interpolación lineal para estimar el instante exacto del cruce v=0
    tiempos_cruce_interp = zeros(size(idx));
    for k = 1:length(idx)
        i = idx(k);
        t1 = t(i); t2 = t(i+1);
        v1 = v(i); v2 = v(i+1);
        % tiempo aproximado donde v = 0 por interpolación lineal
        tiempos_cruce_interp(k) = t1 - v1*(t2-t1)/(v2-v1);
    end

    % Estimación de la frecuencia:
    dt_all = diff(tiempos_cruce_interp);   % medio-período
    if length(dt_all) >= 1
        T = 2 * mean(dt_all);  % período completo
        f_detectada = 1 / T;
    else
        f_detectada = NaN;
    end

end


%% --- Generación de señal de prueba ---
fs = 10000;              % Frecuencia de muestreo [Hz]
t = 0:1/fs:0.1;         % Duración de 100 ms
f = 50;                 % Frecuencia [Hz]
Vp = 325;               % Amplitud pico [V]

v = Vp * sin(2*pi*f*t); % Señal senoidal

%% --- Detección ---
[indices, t_cruce, f_est] = detectarCrucesCero(v, t);

%% --- Resultados ---
fprintf('Frecuencia estimada: %.4f Hz\n', f_est);

%% --- Gráfica ---
figure;
plot(t*1000, v, 'b', 'LineWidth', 1.2); hold on;
plot(t_cruce*1000, zeros(size(t_cruce)), 'ro', 'MarkerFaceColor','r'); % marca en y=0
xlabel('Tiempo [ms]'); ylabel('Tensión [V]');
title(sprintf('Cruces por cero (interpolados) - f = %.4f Hz', f_est));
grid on;