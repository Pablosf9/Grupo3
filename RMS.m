% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Ejercicio 2.2.1 - Cálculo del Valor RMS
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández
clear; close all; clc;

%% --- Función para calcular RMS ---
function Vrms = calcularRMS(v)
    % Calcula el valor RMS de un vector de señal
    % Entrada: v → vector de valores de la señal
    % Salida: Vrms → valor RMS calculado
    N = length(v);
    Vrms = sqrt(sum(v.^2) / N);
end

%% --- Generación de señal de prueba ---
fs = 1000;              % Frecuencia de muestreo [Hz]
t = 0:1/fs:0.1;         % Duración de 100 ms
f = 50;                 % Frecuencia [Hz]
Vp = 325;               % Amplitud pico [V]

v = Vp * sin(2*pi*f*t); % Señal senoidal

%% --- Cálculo del valor RMS ---
Vrms_calc = calcularRMS(v);
Vrms_teorico = Vp / sqrt(2);  % Valor RMS teórico

error_rel = abs(Vrms_calc - Vrms_teorico)/Vrms_teorico * 100;

%% --- Resultados ---
fprintf('Valor RMS calculado: %.2f V\n', Vrms_calc);
fprintf('Valor RMS teórico: %.2f V\n', Vrms_teorico);
fprintf('Error relativo: %.4f %%\n', error_rel);

%% --- Gráfica ---
figure;
plot(t*1000, v);
xlabel('Tiempo [ms]');
ylabel('Tensión [V]');
title(sprintf('Señal Senoidal de 50 Hz - Vrms = %.2f V (Error %.2f%%)', Vrms_calc, error_rel));
grid on;
