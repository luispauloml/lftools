%% -*- texinfo -*-
%% @deftypefun  {} {@var{X} =} lftSimulacaoFrequencia (@var{matsStruc}, @var{gdls}, @var{carregamento}, @var{freqs})
%% Realiza uma simulação no domínio da frequênca.
%%
%% Simula as matrizes contidas em @var{matsStrc}, sob o carregamento 
%% fornecido em @var{carregamento}, nas frequências contidas no vetor
%% @var{frequencias} e reduzindo as matrizes para os índices contidos
%% no vetor @var{gdls}. Basicamente, resolve equação:
%%  @example
%%    [M]*x'' + [C]*x' + [K]*x = f
%%  @end example
%% para X, onde [M] é a matriz de massa, [C] a de amortecimento, [K] a de
%% rigidez e f é o vetor de carregamento. Um apóstrofe (') indica 
%% derivada no tempo. A saída é o deslocamento x.
%% Tanto x quando f estão no domínio da frequência.
%%
%% Entradas:
%%
%% @itemize @bullet
%% @item @var{matsStruc}: uma estrutura (struct) contendo as matrizes de
%% massa, amortecimento e rigidez do sistema de tamanho N x N.
%% Conferir "help lftGuard".
%%
%% @item @var{gdls}: um vetor de comprimento nGDLs <= N contendo os índices das
%% matrizes do sistema que devem ser simulados.
%% 
%% @item @var{carregamento}: uma matriz ou uma função.
%%  @itemize @bullet
%%  @item Se @var{carregamento} for uma matriz, deve ter tamanho nGDLs x nF
%%  e cada elemento (i,j)
%%  representa o carregamento em newtons (N) de cada grau de liberdade 
%%  @var{gdls}(i) numa frequencia @var{freqs}(j).
%%  @item Se @var{carregamento} for uma função, deve receber como
%%  argumento um elemento de @var{freqs}(j) e resultar num vetor
%%  coluna de tamanho nGDLs x 1. O resultando também deve ser o carregamento
%%  dos graus de liberdade de @var{gdls} em newtons (N).
%%  @end itemize
%%
%% @item @var{freqs}: um vetor de comprimento nF contendo as frequência
%% em hertz (Hz) a serem simuladas.
%%
%% @item 'verbose': mostra mensagens no terminal indicando o progresso da simulação.
%% @end itemize
%%
%% Saída:
%%
%% @itemize @plus
%% @item @var{X}: uma matriz nGDLs x nF com os deslocamentos do sistema.
%% @end itemize
%% @end deftypefun

function [X] = lftSimulacaoFrequencia(matsStruc,gdls,carregamento,freqs,varargin)
  %% Função de erro
  funcError = @(s)(error(['lftSimulacaoFrequencia(): ',s,'.']));

  %===============================
  % Validação das entradas
  %===============================
  
  %% Verifica a estrutura de matrizes
  [ordem, nullMats] = lftGuard(matsStruc);
  
  %% Verifica se as frequências estão num vetor
  if ~isvector(freqs)
      funcError('as frequências devem estar num vetor')
  end
  nF = length(freqs); % Número de frequências
  
  %% Verifica se glds é vetor
  if ~isvector(gdls)
    funcError('a lista de GDLs deve ser um vetor');
    
  elseif length(gdls) > ordem || max(gdls) > ordem || min(gdls) < 1
    funcError(['a quantidade de GDLs deve ser menor que a ordem N das matrizes e ',...
               'os valores dos indices devem estar em [1,N]']);
  end
  nGDLs = length(gdls); % Número de graus de liberdade
  
  %% Verifica o carregamento
  flagFuncaoCarregamento = false;
  if isa (carregamento,'function_handle') % Verifica se é função
    flagFuncaoCarregamento = true;
    if ~isequal ([nGDLs, 1], size (carregamento (freqs(1))))
      funcError(['a saída da função de carregamento deve ser um vetor ',...
                 'coluna de comprimento igual a ordem das matrizes do sistema']);
    end
    
  elseif ismatrix (carregamento) % Verifica se é matriz
    if ~isequal ([nGDLs, nF], size (carregamento))
      funcError('a matriz de carregamento deve ter tamanho nGDLs x nF');
    end
    
  else % Se não for nem matriz, nem função
    funcError('o carregamento deve ser uma matriz ou uma função');
  end
  
  %===============================
  % Adiciona zeros nas matrizes vazias
  %===============================
  for i = 1 : size(nullMats)
    matsStruc.(nullMats(i)) = zeros (nGDLs, nGDLs);
  end  
  
  %===============================
  % Discretizando o carregamento
  %===============================
  
  if flagFuncaoCarregamento
    fLoad        = carregamento;      % Transfere a função para um novo nome
    carregamento = zeros (nGDLs, nF); % Cria uma matriz de carregamento nula
    
    for i = 1 : nF
      carregamento(:,i) = fLoad (freqs(i)); % Calcula o carregamento
    end
  end    

  %===============================
  % Equação na frequência
  %===============================

  % Fórmula da equação na frequência:
  %  f  =      [M]*x'' +   [C]*x'+ [K]*x (dominio do tempo)
  %  F  = -w^2*[M]*X + i*w*[C]*X + [K]*X (domínio da frequência)
  %  F  = (-w^2*[M] + i*w*[C] + [K])*X
  %  F  = [T]*X 
  % [T] = (-w^2*[M] + i*w*[C] + [K])
  % [T] é uma matriz de transformação (frequencia em Hz)
  
  %% Matriz de saída
  X = zeros(nGDLs,nF);
  
  for i = 1:nF
      %% Frequencia
      freq = freqs(i);
      
      %% Matriz de transformação
      T = -(2 * pi * freq)^2 * matsStruc.massa(gdls,gdls) ...
        + 1i * (2 * pi * freq) * matsStruc.amortecimento(gdls,gdls) ...
        + matsStruc.rigidez(gdls,gdls);
      
      %% saída
      X(gdls,i) = inv(T)*carregamento(:,i);
  end
