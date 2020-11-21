%% Copyright 2020 Luis Paulo Morais Lima

%% Uma demonstra��o de simula��o no dom�nio da frequ�ncia usando
%% um sistema de massa condensada de 2 GDL: duas massas condensadas
%% unidas entre si por uma rigidez e um amortecedor viscoso, sendo
%% que uma delas est� conectada � Terra por uma rigidez.
%%
%%  N�s:      (1)             (2)
%%
%% /|       [     ]---[k]---[     ]
%% /|--[k]--[  m  ]         [  m  ]
%% /|       [     ]---[c]---[     ]
%%             |               |
%%  Desloc.:   |->  x_1        |->  x_2
%%  For�as:    |--> f_1 = 1    |--> f_2 = 0
%%

%% =================================
%% Definindo par�metros gerais do sistema

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

% �ndice dos graus de liberdade
gdls = [1, 2];

%% =================================
%% Definindo carregamento

% Apenas o n� 1 ser� carregado, portanto a sa�da da fun��o
% deve ser um vetor [F; 0], sendo F a amplitude da for�a.
F_carga = @(f) [1; 0]; 

%% =================================
%% Par�metros de simula��o

nP   = 100; % N�mero de pontos para simula��o
fMax = 200; % Frequ�ncia m�xima (Hz)

% Vetor de frequ�ncias
freqs = linspace(0, fMax, nP);

%% =================================
%% Simulando

% Sa�da simula��o
X = lftSimulacaoFrequencia (mats, gdls, F_carga, freqs);

% Extraindo frequ�ncias naturais usando eig para verifica��o
[~,natfreqs] = eig (mats.rigidez, mats.massa);
natfreqs = sqrt(diag(natfreqs))/2/pi;

%% =================================
%% Gr�ficos

h = figure(); clf();
set(h, 'name', 'Simula��o no dom�nio da frequ�ncia');
subplot(2,1,1); 
limites = [min(min(abs(X))), max(max(abs(X)))];
semilogy (freqs', abs(X)');
hold on; grid on; axis('tight');
semilogy (natfreqs(1)*[1 1], limites,'k');
semilogy (natfreqs(2)*[1 1], limites,'k');
xlabel ('Frequ�ncia (Hz)'); 
ylabel ('Amplitude (m)'); 
title ('M�dulo');
h = legend('x_1','x_2','Freq. nat. (eig)','Freq. nat. (eig)');
legend(h,'location','southeast');

subplot(2,1,2); title('Fase');
plot (freqs', arg(X)'/pi*180);
grid on;
xlabel ('Frequ�ncia (Hz)'); 
ylabel ('�ngulo (graus)'); 
title ('Fase');
h = legend('x_1','x_2');
legend(h,'location','southeast');
