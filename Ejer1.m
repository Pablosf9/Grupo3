%% Respuesta al escalón de un circuito RL y señal de entrada
% Datos del problema
R = 82;            % [ohm]
L = 100e-3;        % [H]
V = 5;             % [V] amplitud del escalón

% Constantes del modelo RL
tau   = L/R;               % [s]   --> tau = L/R (constante de tiempo)
Iinf  = V/R;               % [A]   --> corriente final por Ley de Ohm en régimen
t50   = tau*log(2);        % [s]   --> resolver (1 - e^{-t/tau}) = 0.5

% Eje temporal (0 a ~6 tau para ver el asentamiento)
t = linspace(0, 6*tau, 2000);    % [s]

% Respuesta de corriente i(t) ante un escalón de tensión V
% i(t) = (V/R) * (1 - e^{-t/tau})
i = Iinf * (1 - exp(-t/tau));

% Señal de entrada: escalón de amplitud V
u = V * (t >= 0);   % representación discreta del escalón

% Puntos clave a marcar en la respuesta
t_keys = [0, 1*tau, 2*tau, 3*tau, 5*tau, t50];
i_keys = Iinf * (1 - exp(-t_keys/tau));

%% Gráfica
figure('Color','w','Position',[100 100 820 540])

% --- (1) Respuesta i(t) (arriba)
subplot(2,1,1)
plot(t*1e3, i*1e3, 'LineWidth',1.8); hold on; grid on
xlabel('t (ms)'); ylabel('i(t) (mA)')
title('Respuesta de corriente i(t) = (V/R)\cdot(1 - e^{-t/\tau})')
ylim([0 1.1*Iinf*1e3])

% Líneas verticales en τ, 2τ, 3τ, 5τ y t50
xline(tau*1e3,'--','\tau','LabelVerticalAlignment','bottom');
xline(2*tau*1e3,'--','2\tau','LabelVerticalAlignment','bottom');
xline(3*tau*1e3,'--','3\tau','LabelVerticalAlignment','bottom');
xline(5*tau*1e3,'--','5\tau','LabelVerticalAlignment','bottom');
xline(t50*1e3,':','50%','LabelVerticalAlignment','bottom');

% Línea horizontal en Iinf
yline(Iinf*1e3,'--',sprintf('I_\\infty = %.2f mA', Iinf*1e3));

% Marcadores y etiquetas de puntos
plot(t_keys*1e3, i_keys*1e3, 'o', 'MarkerSize',6, 'LineWidth',1.2)
text((t50*1e3), (i_keys(end)*1e3), '  50%', 'VerticalAlignment','bottom')

% --- (2) Escalón de entrada (abajo)
subplot(2,1,2)
plot(t*1e3, u, 'LineWidth',1.8); hold on; grid on
xlabel('t (ms)'); ylabel('u(t) (V)')
title('Entrada: escalón de 5 V')
ylim([-0.1*V, 1.2*V])

% Línea vertical en t=0 y etiqueta de amplitud
xline(0,'--','t=0','LabelVerticalAlignment','bottom')
yline(V,'--',sprintf('V = %.1f V',V));

% Información en consola
fprintf('tau = %.6f s (%.4f ms)\n', tau, tau*1e3);
fprintf('I_inf = V/R = %.6f A (%.2f mA)\n', Iinf, Iinf*1e3);
fprintf('t50 = tau*ln(2) = %.6f s (%.3f ms)\n', t50, t50*1e3);
