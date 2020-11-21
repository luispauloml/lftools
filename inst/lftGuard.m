%% -*- texinfo -*-
%% @deftypefun  {} {[@var{n}, @var{camposNulos}] =} lftGuard (@var{strc})
%% @deftypefunx {} {[@var{camposValidos}] =} lftGuard ()
%% Verifica se a entrada @var{strc} � uma estrutura apropriada para 
%% ser usada nas fun��es de simula��o do LFT. Retorna a ordem @var{n} das
%% matrizes contidas na estrutura, quais matrizes est�o vazias (@var{camposNulos}).
%% Se for chamada sem argumentos, retorna quais campos s�o validos
%% para uma estrtura (@var{camposValidos}).
%%
%% Uma estrutura apropriada deve ter os campos "massa", 
%% "amortecimento" e "rigidez" contendo matrizes quadradas de mesmo
%% tamanho, ou matrizes vazias.
%%
%% Pelo menos uma matriz deve ser n�o vazia e quadrada.
%%
%% Exemplo:
%% @example
%% @group
%% s = struct('massa',         zeros(2,2),...
%%            'amortecimento', eye(2,2),...
%%            'rigidez',       ones(2,2));
%% lftguard(s)
%%   @result{} 2
%% s = struct('massa',         [],...
%%            'amortecimento', [],...
%%            'rigidez',       1);
%% lftguard(s)
%%   @result{} 1
%% @end group
%% @end example
%%
%% Se a estrutura for inv�lida, um erro � lan�ado:
%% @example
%% @group
%% s = struct('massa',         zeros(2,1),...
%%            'amortecimento', eye(2,2),...
%%            'rigidez',       ones(2,2));
%% lftguard(s)
%%   @result{} error: lftguard(): as matrizes n�o tem as mesmas dimens�es.
%% @end group
%% @end example
%% @end deftypefun

function [s,varargout] = lftGuard (varargin)
  
%% Campos aceitos numa estrutura
camposValidos = {'massa','amortecimento','rigidez'};

%% Fun��o de erro
funcError = @(s) error(['lftguard(): ',s,'.']);

%% Verifica se h� argumentos de entrada
if nargin == 0
  o = camposValidos;
  return
elseif nargin > 1
  funcError('nenhum ou apenas um argumento de entrada � admitido');
end

%% Argumento de entrada
stru = varargin{1};
  
%% Verifica se � uma estrutura
if ~isstruct (stru)
  funcError('a entrada n�o � uma estrutura (structure)');
end

%% Verifica a quantidade de campos
camposEntrada = fieldnames (stru);         % Campos da estrutura de entrada
if length (camposEntrada) > 3
  funcError ('a estrutura tem mais que tr�s campos');
end

%% Verifica se os campos s�o v�lidos e se s�o matrizes
camposValidos = {'massa','amortecimento','rigidez'}; % Campos aceitos
tamanhos      = []; % Armazena tamanhos das matrizes
camposNulos   = {}; % Armazena quais matrizes s�o nulas
for i = 1 : 3
  if ~ismember (camposEntrada{i},camposValidos)
    error('os campos da estrutura s�o inv�lidos');
  end
  
  valor = stru.(camposEntrada{i});
  if ~ismatrix (valor)
    error('todos os campos devem ser matrizes ou escalares');
  end
  
  %% Se passar em todos os testes, medir o tamanho das matrizes
  s = size (valor);
  if isequal (s,[0 0])
    % Se for vazia, armazena o nome da matriz
    inds{end+1} = camposEntrada{i};
  else  
    % Se n�o for vazia, armazena o tamanho
    tamanhos = [tamanhos; s];
  end  
end

%% Verifica se todas as matrizes est�o vazias
if isempty (tamanhos)
  funcError('a estrutura est� vazia');
end  

%% Verifica se todas as matrizes tem o mesmo tamanho
flagMesmoTamanho = true;
for i = 2 : size (tamanhos,1)
  flagMesmoTamanho = isequal (tamanhos(i-1,:), tamanhos(i,:)) ...
                   & flagMesmoTamanho;
end

if ~flagMesmoTamanho
  funcError('as matrizes n�o tem as mesmas dimens�es');
end  

%% Verifica se as matrizes s�o quadradas
if tamanhos(1,1) ~= tamanhos(1,2)
  funcError('as matrizes n�o s�o quadradas');
end

%% Argumento de sa�da  
o         = tamanhos(1);   % Ordem das matrizes
varargout = {camposNulos}; % Matrizes vazias
