classdef lftstruct
  properties
    massa         % Matriz de massa
    amortecimento % Matriz de amortecimento
    rigidez       % Matriz de rigidez
    gdls          % Vetor com �ndices dos graus de liberdade
    nGDLs         % N�mero de graus de liberdade
  end
  
  methods (Access = private)
    so = plusminus (s1, s2, op)
  end
  
  methods
    %% Construtor
    function s = lftstruct(varargin)
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
        %% Limita o n�mero de entradas
        error('lftstruct: apenas 3 entradas s�o aceitas');
        
      else
        %% Percorrer argumentos
        for i = 1 : nargin
          
          %% Verifica e a entrada � matriz
          matriz = varargin{i};
          if ~isa (matriz, 'double')
            error ('lftstruct: todas as entradas devem ser matrizes');
          end
          
          %% Verifica se � quadrada
          tamanho = size (matriz);
          if tamanho(1) ~= tamanho(2)
            error ('lftstruct: todas as entradas devem ser quadradas');
          end
          
          %% Compara com as entradas anterior
          if i == 1
            s.nGDLs = tamanho(1);    % Armazena a ordem se for a primeira entrada
          else
            if s.nGDLs ~= tamanho(1) % Compara com as demais
              error ('lftstruct: todas as entradas devem ter o mesmo tamanho');
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
    
    %% Fun��es booleanas
    function b = hasMassa (s)
      b = ~isempty (s.massa);
    end%function
    
    function b = hasAmortecimento (s)
      b = ~isempty (s.amortecimento);
    end%function
    
    function b = hasRigidez (s)
      b = ~isempty (s.rigidez);
    end%function
       
    %% Opera��es
    function so = expandir (si)
      %% Par�metros
      gdls   = get (si, 'gdls');
      maxGDL = max (gdls);
      
      %% Verifica se j� est� expandida ou se � vazia
      if isequal (gdls, sort(gdls), 1:maxGDL) || isempty (si)
        so = si;
        return;
      end
      
      %% Campos a serem percorridos cuja ordem deve ser a mesma
      %% das entrada do construtor
      campos    = {'rigidez', 'massa', 'amortecimento'};
      
      %% C�lula para armazenar matrizes expandidas
      mo        = {};
      
      %% La�o pelos campos
      for i = 1 : 3
        mi = get (si, campos{i});
        
        if isempty (mi)
          break; % Interromper la�o para n�o gerar mais entradas que as necess�rias
          
        else
          m_tmp             = zeros (maxGDL, maxGDL);
          m_tmp(gdls, gdls) = mi;
          mo{i}             = m_tmp;
        end
      end
      
      %% Criando nova estrutura
      so = lftstruct(mo{:});
    end%function
    
    %% Overloading
    disp (s);
    s = equal (s1, s2);
    v = get (v, prop);
    s = set (s, prop, val);
    so = plus (s1, s2)
    so = uminus (si);
    [p,q] = size (s)
    
    function s = uplus (s)
      %% Repassa a entrada
    end%function
    
    function s = ctranspose (s)
      %% Repassa a entrada
    end%function
    
    function so = minus (s1, s2)
      so = plus (s1, -s2);
    end%function
    
    function b = isempty (s)
      b = hasMassa (s) || hasAmortecimento (s) || hasRigidez (s);
      b = ~b;
    end%function
    
    function b = eq (s1, s2);
      b =  isequal (s1.massa,         s2.massa) ...
        && isequal (s1.rigidez,       s2.rigidez) ...
        && isequal (s1.amortecimento, s2.amortecimento) ...
        && isequal (s1.gdls,          s2.gdls);
    end%function
  end%methods
end%classdef
