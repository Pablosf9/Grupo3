% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Ejercicio 2.1 - Análisis Espectral Básico
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández

clear; close all; clc;

% --- Parámetros de la señal ---
fs = 2000;      % Frecuencia de muestreo [Hz]
f0 = 50;        % Frecuencia de la señal [Hz]
Vp = 325;       % Amplitud pico [V]
T  = 1;         % Duración [s]
t  = 0:1/fs:T-1/fs;
N  = length(t);

% --- Generar señal senoidal pura ---
v = Vp * sin(2*pi*f0*t);

% --- Calcular FFT y normalizar ---
V = fft(v);
M = abs(V)/N;           % Normalización por N

% --- Quedarse solo con frecuencias positivas ---
M = M(1:N/2+1);         % Primera mitad del espectro
M(2:end-1) = 2*M(2:end-1); % Duplicar las intermedias
f = fs*(0:N/2)/N;       % Vector de frecuencias

% --- Graficar el espectro hasta 500 Hz ---
figure;
stem(f, M, 'filled');
xlim([0 500]); grid on;
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (V)');
title('Espectro de una senoidal pura de 50 Hz');