function s = set (s,varargin)

  %% Verifica a quantidade de entradas
  npares = numel (varargin);
  if mod (npares, 2) ~= 0
    error('set: s�o esperados pares PROP e VALOR');
  end
  npares = npares / 2;
  
  %% Separa propriedades de valores
  props   = varargin(1:2:end);
  valores = varargin(2:2:end);
  
  %% Verifica se as propriedades s�o v�lidas
  candidatas = {'massa', 'rigidez', 'amortecimento', 'gdls'};
  if numel (setdiff (props, candidatas)) ~= 0
    error('set: propriedades inv�lidas');
  end
  
  %% Verifica se os valores s�o matrizes
  if npares ~= numel (find (cellfun ('isclass', valores, 'double')))
    error('set: todos os valores devem ser matrizes');
  end
  
  %% N�mero de graus de liverdade do sistema
  nGDLs = get (s, 'nGDLs');
  for i = 1 : npares
    valor = valores{i};
  
    switch props{i}
      case candidatas(1:3) % massa, rigidez ou amortecimento
        if issquare (valor) && size (valor, 1) == nGDLs
          s.(props{i}) = valor;
        else
          error('set: ordem da matriz incompat�vel; deveria ser %i', nGDLs);
        end%if
          
      case 'gdls'
        if isvector (valor) ...
        && length (valor) == nGDLs ... 
        && isequal (fix (valor), valor)
          s.gdls = valor(:)';     % For�a a ser um vetor linha
          s.nGDLs = max (s.gdls); % Atualiza a quantidade de GDLs
        else
          error (['set: o vetor de GDLs deve ter comprimento igual'...
                 ,'ao n�mero de GDLs e conter apenas valores inteiros']);
        end%if
        
      otherwise
        error('set: a propriedade ''%s'' n�o est� definida', props{i});
    end%swtich
  end%for
