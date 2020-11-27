classdef lfts
  properties (Access = private)
    massa
    amortecimento
    rigidez
    gdls
    nGDLs
  end

  methods
    %%%%%%
    %% Construtor da classe
    %%%%%%
    
    function s = lfts(varargin)    
      %% Estrutura vazia
      s.massa         = [];
      s.amortecimento = [];
      s.rigidez       = [];
      s.gdls          = [];
      s.nGDLs         = 0;
      
      if nargin == 0
        %% Retornar estrutura vazia
        return;
        
      elseif nargin > 3
        %% Limita o número de entradas
        error('lfts: apenas 3 entradas são aceitas');
        
      else
        %% Verifica ese toda entrada é matriz
        isMatrizes = cellfun (@(m) isa(m,'double'), varargin);
        if ~isempty (find (~isMatrizes))
          error ('lfts: todas as entradas devem ser matrizes');
        end
        
        %% Verifica se todas são quadradas
        isQuadrada = cellfun (@issquare, varargin);
        if ~isempty (find (~isQuadrada))
          error ('lfts: todas as entradas devem ser quadradas');
        end
        
        %% Verifica os tamanhos
        tamanhos = cellfun (@(m) size(m,1), varargin); % Extrai tamanho
        tamanhos = tamanhos (find (tamanhos));         % Elimina zeros
        tamanhos = unique (tamanhos);                  % Elimina repetentes
        if ~isscalar (tamanhos) && ~isempty (tamanhos)
          error ('lfts: todas as entradas devem ser [] ou terem os mesmo tamanhos');
        end
        
        %% Atribui valores
        s.nGDLs = tamanhos;
        s.gdls  = 1 : tamanhos;
      
      
        %% Percorrer argumentos
        for i = 1 : nargin
          switch i
          case 1
            %% Rigidez: mínimo requisito para uma simulação estática
            s.rigidez = varargin{i};
            
          case 2
            %% Massa: mínimo requisito para uma simulação dinâmica
            s.massa = varargin{i};
            
          case 3
            %% Amortecimento: opcional
            s.amortecimento = varargin{i};
            
          end%switch
        end%for
      end%if
      
      s.gdls = (1 : s.nGDLs);
    end%function
    
    %%%%%%
    %% Overloading
    %%%%%%
    
    function display (s)
      printf ('%s = <objeto ''lfts''>\n', inputname (1));
      
      campos = {'massa', 'amortecimento', 'rigidez', 'gdls'};
      
      for i = 1 : length(campos)
        switch campos{i}
          case 'gdls'
            printf ('  graus de liberdade =\n');
          otherwise
            printf ('  %s =\n', campos{i});
        end
        
        if isempty (s.(campos{i}))
          printf('   ');
        end
        
        display (s.(campos{i}));
        printf('\n');
      end
    end%function
    
    %% ==========
    
    function s = transpose (s)
      s.massa         = s.massa.';
      s.amortecimento = s.amortecimento.';
      s.rigidez       = s.rigidez.';
    end%function
    
    function s = ctranspose (s)
      s.massa         = s.massa';
      s.amortecimento = s.amortecimento';
      s.rigidez       = s.rigidez';
    end%function
    
    %% ==========
    
    function b = eq (s1, s2);
      b =  isequal (s1.massa,         s2.massa) ...
        && isequal (s1.rigidez,       s2.rigidez) ...
        && isequal (s1.amortecimento, s2.amortecimento) ...
        && isequal (s1.gdls,          s2.gdls);
    end%function
    
    function b = isempty (s)
      b = isempty (s.massa) && isempty (s.amortecimento) && isempty (s.rigidez);
    end%function
    
    %% ==========
       
    function so = uminus (si)
      if isempty(si)
        so = si;
        return;
      end

      campos = {'rigidez', 'massa', 'amortecimento'};
      mo = {};
      
      for i = 1 : 3
        mi = get (si, campos{i});
        
        if isempty (mi)
          break;
        else
          mo{i} = - mi;
        end
      end
      
      so = lfts (mo{:});
      so = set (so, 'gdls', get (si, 'gdls'));
    end%function
    
    function so = minus (s1, s2)
      so = plus (s1, -s2);
    end%function
    
    function s = uplus (s)
      %% Repassa a entrada
    end%function
    
  end%methods
end%classdef