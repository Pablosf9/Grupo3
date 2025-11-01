% Práctica 2. Itinerario de Eléctrica
% Máster en Ingeniería Industrial. Universidad de Almería
% 3.4 - Actividad Guiada: Comparar Diferentes Cargas
% Grupo 3: Nadia Rotbi Prado, Encarnación Cervantes Requena y Pablo Segura
% Fernández


clear; close all; clc;

% --- Parámetros comunes ---
fs = 2000; f0 = 50; Vp = 325; T  = 1.0;
t  = 0:1/fs:T-1/fs;

% --- Señales a comparar ---
v_lin = Vp*sin(2*pi*f0*t);                                % Lineal (ideal)
v_mod = Vp*sin(2*pi*f0*t) + 0.10*Vp*sin(2*pi*3*f0*t) ...  % Moderada
      + 0.05*Vp*sin(2*pi*5*f0*t);
v_alt = Vp*sin(2*pi*f0*t) + 0.25*Vp*sin(2*pi*3*f0*t) ...  % Alta
      + 0.15*Vp*sin(2*pi*5*f0*t) + 0.10*Vp*sin(2*pi*7*f0*t);

% --- Análisis de armónicos (1..15) ---
maxH = 15;
use_func = exist('analisis_armonicos','file')==2;

if use_func
  [Tlin, THDlin] = analisis_armonicos(v_lin, fs, f0, maxH);
  [Tmod, THDmod] = analisis_armonicos(v_mod, fs, f0, maxH);
  [Talt, THDalt] = analisis_armonicos(v_alt, fs, f0, maxH);
else
  [Tlin, THDlin] = analisis_armonicos_fb(v_lin, fs, f0, maxH);
  [Tmod, THDmod] = analisis_armonicos_fb(v_mod, fs, f0, maxH);
  [Talt, THDalt] = analisis_armonicos_fb(v_alt, fs, f0, maxH);
end

% --- Tabla comparativa (se rellena en MATLAB y se copia a LaTeX) ---
getV = @(Tab,n) Tab.Magnitud_V(Tab.Armonico==n);
V1 = [getV(Tlin,1); getV(Tmod,1); getV(Talt,1)];
V3 = [getV(Tlin,3); getV(Tmod,3); getV(Talt,3)];
V5 = [getV(Tlin,5); getV(Tmod,5); getV(Talt,5)];
V7 = [getV(Tlin,7); getV(Tmod,7); getV(Talt,7)];
THD = [THDlin; THDmod; THDalt];

Carga = {'Lineal (ideal)'; 'Distorsión moderada'; 'Altamente distorsionada'};
TablaComp = table(Carga, round(THD,2), round(V1,3), round(V3,3), ...
                  round(V5,3), round(V7,3), ...
  'VariableNames', {'Carga','THD_pct','V1_V','V3_V','V5_V','V7_V'});
disp(TablaComp);

% --- Gráficas: espectros 0..500 Hz en subplots ---
[f_lin,M_lin] = one_sided_spectrum(v_lin, fs);
[f_mod,M_mod] = one_sided_spectrum(v_mod, fs);
[f_alt,M_alt] = one_sided_spectrum(v_alt, fs);

figure('Name','Espectros','Color','w');
subplot(3,1,1); stem(f_lin,M_lin,'filled'); xlim([0 500]); grid on;
title(sprintf('Lineal — THD=%.2f%%',THDlin)); xlabel('Hz'); ylabel('V');

subplot(3,1,2); stem(f_mod,M_mod,'filled'); xlim([0 500]); grid on;
title(sprintf('Moderada — THD=%.2f%%',THDmod)); xlabel('Hz'); ylabel('V');

subplot(3,1,3); stem(f_alt,M_alt,'filled'); xlim([0 500]); grid on;
title(sprintf('Alta — THD=%.2f%%',THDalt)); xlabel('Hz'); ylabel('V');

saveas(gcf,'espectros_cargas.png');

% -------- Helpers (semiespectro y fallback) ------------
function [f,M]=one_sided_spectrum(x,fs)
  x=x(:); N=numel(x); X=fft(x); M2=abs(X)/N;
  if mod(N,2)==0
    M=M2(1:N/2+1); if numel(M)>2, M(2:end-1)=2*M(2:end-1); end
    f=fs*(0:N/2)/N;
  else
    M=M2(1:(N+1)/2); if numel(M)>1, M(2:end)=2*M(2:end); end
    f=fs*(0:(N-1)/2)/N;
  end
end

function [tabla,THD_pct]=analisis_armonicos_fb(x,fs,f0,maxH)
  [f,M]=one_sided_spectrum(x,fs);
  ord=(1:maxH)'; fobj=ord*f0; fobj(fobj>f(end))=f(end);
  idx=arrayfun(@(u) find(abs(f-u)==min(abs(f-u)),1), fobj);
  f_med=f(idx); Vn=M(idx); V1=Vn(1);
  THD_pct=100*sqrt(sum(Vn(2:end).^2))/V1;
  tabla=table(ord,f_med(:),Vn(:),'VariableNames', ...
       {'Armonico','Frecuencia_Hz','Magnitud_V'});
end