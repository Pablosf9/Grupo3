% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% Ejercicio 2.2: Análisis de Armónicos
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández

function [tabla, THD_pct, df] = analisis_armonicos(x, fs, f0, maxH)
% ANALISIS_ARMONICOS - Identifica y cuantifica armónicos específicos.
% -----------------------------------------------------------
% Entradas:
%   x   : señal temporal
%   fs  : frecuencia de muestreo [Hz]
%   f0  : frecuencia fundamental [Hz]
%   maxH: número de armónicos (por defecto, 15)
%
% Salidas:
%   tabla   : armónico, frecuencia y magnitud
%   THD_pct : distorsión armónica total (%)
%   df      : resolución frecuencial (fs/N)

    if nargin < 4 || isempty(maxH), maxH = 15; end
    if nargin < 3 || isempty(f0), f0 = 50; end

    x = x(:); N = numel(x); df = fs / N;

    % --- FFT y semiespectro ---
    X = fft(x); M2 = abs(X)/N;
    if mod(N,2)==0
        M = M2(1:N/2+1);
        if numel(M)>2, M(2:end-1)=2*M(2:end-1); end
        f = fs*(0:N/2)/N;
    else
        M = M2(1:(N+1)/2);
        if numel(M)>1, M(2:end)=2*M(2:end); end
        f = fs*(0:(N-1)/2)/N;
    end

    % --- Búsqueda de armónicos ---
    orden = (1:maxH).';
    f_obj = orden*f0; f_obj(f_obj>f(end))=f(end);
    idx = arrayfun(@(ft) nearest_index(f,ft), f_obj);
    f_medida = f(idx); Vn = M(idx);

    % --- Cálculo del THD ---
    V1 = Vn(1);
    THD_pct = 100*sqrt(sum(Vn(2:end).^2))/V1;

    % --- Tabla de salida ---
    tabla = table(orden, f_medida(:), Vn(:), ...
        'VariableNames', {'Armonico','Frecuencia_Hz','Magnitud_V'});
end

function k = nearest_index(vec, value)
    [~,k] = min(abs(vec - value));
end