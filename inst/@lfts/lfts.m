classdef lfts
  properties (Access = private)
    massa
    amortecimento
    rigidez
    gdls
    nGDLs
  end

  methods
    function s = lfts(varargin)
      %% Estrutura vazia
      s.massa         = [];
      s.amortecimento = [];
      s.rigidez       = [];
      s.gdls          = [];
      s.nGDLs         = 0;
      %s = class(s, 'lfts');
      
      if nargin == 0
        %% Retornar estrutura vazia
        return;
        
      elseif nargin > 3
        %% Limita o n�mero de entradas
        error('lfts: apenas 3 entradas s�o aceitas');
        
      else
        %% Percorrer argumentos
        for i = 1 : nargin
          
          %% Verifica e a entrada � matriz
          matriz = varargin{i};
          if ~isa (matriz, 'double')
            error ('lfts: todas as entradas devem ser matrizes');
          end
          
          %% Verifica se � quadrada
          tamanho = size (matriz);
          if tamanho(1) ~= tamanho(2)
            error ('lfts: todas as entradas devem ser quadradas');
          end
          
          %% Compara com as entradas anterior
          if i == 1
            s.nGDLs = tamanho(1);    % Armazena a ordem se for a primeira entrada
          else
            if s.nGDLs ~= tamanho(1) % Compara com as demais
              error ('lfts: todas as entradas devem ter o mesmo tamanho');
            end%if
          end%if
          
          %% Preenche a estrutura
          switch i
          case 1
            %% Rigidez: m�nimo requisito para uma simula��o est�tica
            s.rigidez = matriz;
            
          case 2
            %% Massa: m�nimo requisito para uma simula��o din�mica
            s.massa = matriz;
            
          case 3
            %% Amortecimento: opcional
            s.amortecimento = matriz;
            
          end%switch
        end%for
      end%if
      
      s.gdls = (1 : s.nGDLs);
    end%function
  end%methods
end%classdef