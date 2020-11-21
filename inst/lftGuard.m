%% -*- texinfo -*-
%% @deftypefun  {} {[@var{n}, @var{camposNulos}] =} lftGuard (@var{strc})
%% @deftypefunx {} {[@var{camposValidos}] =} lftGuard ()
%% Verifica se a entrada @var{strc} é uma estrutura apropriada para 
%% ser usada nas funções de simulação do LFT. Retorna a ordem @var{n} das
%% matrizes contidas na estrutura, quais matrizes estão vazias (@var{camposNulos}).
%% Se for chamada sem argumentos, retorna quais campos são validos
%% para uma estrtura (@var{camposValidos}).
%%
%% Uma estrutura apropriada deve ter os campos "massa", 
%% "amortecimento" e "rigidez" contendo matrizes quadradas de mesmo
%% tamanho, ou matrizes vazias.
%%
%% Pelo menos uma matriz deve ser não vazia e quadrada.
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
%% Se a estrutura for inválida, um erro é lançado:
%% @example
%% @group
%% s = struct('massa',         zeros(2,1),...
%%            'amortecimento', eye(2,2),...
%%            'rigidez',       ones(2,2));
%% lftguard(s)
%%   @result{} error: lftguard(): as matrizes não tem as mesmas dimensões.
%% @end group
%% @end example
%% @end deftypefun

function [s,varargout] = lftGuard (varargin)
  
%% Campos aceitos numa estrutura
camposValidos = {'massa','amortecimento','rigidez'};

%% Função de erro
funcError = @(s) error(['lftguard(): ',s,'.']);

%% Verifica se há argumentos de entrada
if nargin == 0
  o = camposValidos;
  return
elseif nargin > 1
  funcError('nenhum ou apenas um argumento de entrada é admitido');
end

%% Argumento de entrada
stru = varargin{1};
  
%% Verifica se é uma estrutura
if ~isstruct (stru)
  funcError('a entrada não é uma estrutura (structure)');
end

%% Verifica a quantidade de campos
camposEntrada = fieldnames (stru);         % Campos da estrutura de entrada
if length (camposEntrada) > 3
  funcError ('a estrutura tem mais que três campos');
end

%% Verifica se os campos são válidos e se são matrizes
camposValidos = {'massa','amortecimento','rigidez'}; % Campos aceitos
tamanhos      = []; % Armazena tamanhos das matrizes
camposNulos   = {}; % Armazena quais matrizes são nulas
for i = 1 : 3
  if ~ismember (camposEntrada{i},camposValidos)
    error('os campos da estrutura são inválidos');
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
    % Se não for vazia, armazena o tamanho
    tamanhos = [tamanhos; s];
  end  
end

%% Verifica se todas as matrizes estão vazias
if isempty (tamanhos)
  funcError('a estrutura está vazia');
end  

%% Verifica se todas as matrizes tem o mesmo tamanho
flagMesmoTamanho = true;
for i = 2 : size (tamanhos,1)
  flagMesmoTamanho = isequal (tamanhos(i-1,:), tamanhos(i,:)) ...
                   & flagMesmoTamanho;
end

if ~flagMesmoTamanho
  funcError('as matrizes não tem as mesmas dimensões');
end  

%% Verifica se as matrizes são quadradas
if tamanhos(1,1) ~= tamanhos(1,2)
  funcError('as matrizes não são quadradas');
end

%% Argumento de saída  
o         = tamanhos(1);   % Ordem das matrizes
varargout = {camposNulos}; % Matrizes vazias
