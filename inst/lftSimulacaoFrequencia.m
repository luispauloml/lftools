%% -*- texinfo -*-
%% @deftypefun  {} {@var{X} =} lftSimulacaoFrequencia (@var{matsStruc}, @var{gdls}, @var{carregamento}, @var{freqs})
%% Realiza uma simula��o no dom�nio da frequ�nca.
%%
%% Simula as matrizes contidas em @var{matsStrc}, sob o carregamento 
%% fornecido em @var{carregamento}, nas frequ�ncias contidas no vetor
%% @var{frequencias} e reduzindo as matrizes para os �ndices contidos
%% no vetor @var{gdls}. Basicamente, resolve equa��o:
%%  @example
%%    [M]*x'' + [C]*x' + [K]*x = f
%%  @end example
%% para X, onde [M] � a matriz de massa, [C] a de amortecimento, [K] a de
%% rigidez e f � o vetor de carregamento. Um ap�strofe (') indica 
%% derivada no tempo. A sa�da � o deslocamento x.
%% Tanto x quando f est�o no dom�nio da frequ�ncia.
%%
%% Entradas:
%%
%% @itemize @bullet
%% @item @var{matsStruc}: uma estrutura (struct) contendo as matrizes de
%% massa, amortecimento e rigidez do sistema de tamanho N x N.
%% Conferir "help lftGuard".
%%
%% @item @var{gdls}: um vetor de comprimento nGDLs <= N contendo os �ndices das
%% matrizes do sistema que devem ser simulados.
%% 
%% @item @var{carregamento}: uma matriz ou uma fun��o.
%%  @itemize @bullet
%%  @item Se @var{carregamento} for uma matriz, deve ter tamanho nGDLs x nF
%%  e cada elemento (i,j)
%%  representa o carregamento em newtons (N) de cada grau de liberdade 
%%  @var{gdls}(i) numa frequencia @var{freqs}(j).
%%  @item Se @var{carregamento} for uma fun��o, deve receber como
%%  argumento um elemento de @var{freqs}(j) e resultar num vetor
%%  coluna de tamanho nGDLs x 1. O resultando tamb�m deve ser o carregamento
%%  dos graus de liberdade de @var{gdls} em newtons (N).
%%  @end itemize
%%
%% @item @var{freqs}: um vetor de comprimento nF contendo as frequ�ncia
%% em hertz (Hz) a serem simuladas.
%%
%% @item 'verbose': mostra mensagens no terminal indicando o progresso da simula��o.
%% @end itemize
%%
%% Sa�da:
%%
%% @itemize @plus
%% @item @var{X}: uma matriz nGDLs x nF com os deslocamentos do sistema.
%% @end itemize
%% @end deftypefun

function [X] = lftSimulacaoFrequencia(matsStruc,gdls,carregamento,freqs,varargin)
  %% Fun��o de erro
  funcError = @(s)(error(['lftSimulacaoFrequencia(): ',s,'.']));

  %===============================
  % Valida��o das entradas
  %===============================
  
  %% Verifica a estrutura de matrizes
  [ordem, nullMats] = lftGuard(matsStruc);
  
  %% Verifica se as frequ�ncias est�o num vetor
  if ~isvector(freqs)
      funcError('as frequ�ncias devem estar num vetor')
  end
  nF = length(freqs); % N�mero de frequ�ncias
  
  %% Verifica se glds � vetor
  if ~isvector(gdls)
    funcError('a lista de GDLs deve ser um vetor');
    
  elseif length(gdls) > ordem || max(gdls) > ordem || min(gdls) < 1
    funcError(['a quantidade de GDLs deve ser menor que a ordem N das matrizes e ',...
               'os valores dos indices devem estar em [1,N]']);
  end
  nGDLs = length(gdls); % N�mero de graus de liberdade
  
  %% Verifica o carregamento
  flagFuncaoCarregamento = false;
  if isa (carregamento,'function_handle') % Verifica se � fun��o
    flagFuncaoCarregamento = true;
    if ~isequal ([nGDLs, 1], size (carregamento (freqs(1))))
      funcError(['a sa�da da fun��o de carregamento deve ser um vetor ',...
                 'coluna de comprimento igual a ordem das matrizes do sistema']);
    end
    
  elseif ismatrix (carregamento) % Verifica se � matriz
    if ~isequal ([nGDLs, nF], size (carregamento))
      funcError('a matriz de carregamento deve ter tamanho nGDLs x nF');
    end
    
  else % Se n�o for nem matriz, nem fun��o
    funcError('o carregamento deve ser uma matriz ou uma fun��o');
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
    fLoad        = carregamento;      % Transfere a fun��o para um novo nome
    carregamento = zeros (nGDLs, nF); % Cria uma matriz de carregamento nula
    
    for i = 1 : nF
      carregamento(:,i) = fLoad (freqs(i)); % Calcula o carregamento
    end
  end    

  %===============================
  % Equa��o na frequ�ncia
  %===============================

  % F�rmula da equa��o na frequ�ncia:
  %  f  =      [M]*x'' +   [C]*x'+ [K]*x (dominio do tempo)
  %  F  = -w^2*[M]*X + i*w*[C]*X + [K]*X (dom�nio da frequ�ncia)
  %  F  = (-w^2*[M] + i*w*[C] + [K])*X
  %  F  = [T]*X 
  % [T] = (-w^2*[M] + i*w*[C] + [K])
  % [T] � uma matriz de transforma��o (frequencia em Hz)
  
  %% Matriz de sa�da
  X = zeros(nGDLs,nF);
  
  for i = 1:nF
      %% Frequencia
      freq = freqs(i);
      
      %% Matriz de transforma��o
      T = -(2 * pi * freq)^2 * matsStruc.massa(gdls,gdls) ...
        + 1i * (2 * pi * freq) * matsStruc.amortecimento(gdls,gdls) ...
        + matsStruc.rigidez(gdls,gdls);
      
      %% sa�da
      X(gdls,i) = inv(T)*carregamento(:,i);
  end
