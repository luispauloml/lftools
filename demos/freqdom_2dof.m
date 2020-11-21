%% Copyright 2020 Luis Paulo Morais Lima

%% Uma demonstração de simulação no domínio da frequência usando
%% um sistema de massa condensada de 2 GDL: duas massas condensadas
%% unidas entre si por uma rigidez e um amortecedor viscoso, sendo
%% que uma delas está conectada à Terra por uma rigidez.
%%
%%  Nós:      (1)             (2)
%%
%% /|       [     ]---[k]---[     ]
%% /|--[k]--[  m  ]         [  m  ]
%% /|       [     ]---[c]---[     ]
%%             |               |
%%  Desloc.:   |->  x_1        |->  x_2
%%  Forças:    |--> f_1 = 1    |--> f_2 = 0
%%

%% =================================
%% Definindo parâmetros gerais do sistema

massa    = 10;   % Massa (kg)
k_rig    = 2d6;   % Rigidez (N/m)
eta_visc = 0.05;  % Fator de amortecimento

% Amortecimento
c_visc   = eta_visc * 2 * massa * sqrt (k_rig/massa);

%% =================================
%% Descrevendo o sistema

m_massa = massa  * eye(2,2);
m_rig   = k_rig  * [2, -1; -1, 1];
m_amort = c_visc * [1, -1; -1, 1];

% Criando a estrutura
mats = struct('massa',         m_massa ...
             ,'amortecimento', m_amort ...
             ,'rigidez',       m_rig);

% Índice dos graus de liberdade
gdls = [1, 2];

%% =================================
%% Definindo carregamento

% Apenas o nó 1 será carregado, portanto a saída da função
% deve ser um vetor [F; 0], sendo F a amplitude da força.
F_carga = @(f) [1; 0]; 

%% =================================
%% Parâmetros de simulação

nP   = 100; % Número de pontos para simulação
fMax = 200; % Frequência máxima (Hz)

% Vetor de frequências
freqs = linspace(0, fMax, nP);

%% =================================
%% Simulando

% Saída simulação
X = lftSimulacaoFrequencia (mats, gdls, F_carga, freqs);

% Extraindo frequências naturais usando eig para verificação
[~,natfreqs] = eig (mats.rigidez, mats.massa);
natfreqs = sqrt(diag(natfreqs))/2/pi;

%% =================================
%% Gráficos

h = figure(); clf();
set(h, 'name', 'Simulação no domínio da frequência');
subplot(2,1,1); 
limites = [min(min(abs(X))), max(max(abs(X)))];
semilogy (freqs', abs(X)');
hold on; grid on; axis('tight');
semilogy (natfreqs(1)*[1 1], limites,'k');
semilogy (natfreqs(2)*[1 1], limites,'k');
xlabel ('Frequência (Hz)'); 
ylabel ('Amplitude (m)'); 
title ('Módulo');
h = legend('x_1','x_2','Freq. nat. (eig)','Freq. nat. (eig)');
legend(h,'location','southeast');

subplot(2,1,2); title('Fase');
plot (freqs', arg(X)'/pi*180);
grid on;
xlabel ('Frequência (Hz)'); 
ylabel ('Ângulo (graus)'); 
title ('Fase');
h = legend('x_1','x_2');
legend(h,'location','southeast');
