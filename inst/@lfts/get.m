function [v,varargout] = get (s, varargin)
  if nargin < 2
    error(['get: espera-se pelo menos uma PROPRIEDADE da estrutura; '...
          ,'os valores possíveis são ''massa'', ''amortecimento'', '...
          ,'''rigidez'', ''gdls'', e ''nGDLs''']);
  end
  
  %% Verifica se as propriedades são válidas
  nprops = numel(varargin);
  if ~isempty (find (~cellfun ('isclass', varargin, 'char')))
    error('get: as propriedades devem ser strings');
  end
  
  %% Extraindo propriedades
  varargout = cell(1,nprops);
  candidatas = {'massa','rigidez','amortecimento','gdls','nGDLs'};
  for i = 1 : nprops
    if ismember (varargin{i}, candidatas)
      varargout{i} = s.(varargin{i});
    else
      error('get: propriedades inválida');
    end%if
  end%for
  
  v          = varargout{1};
  varargout  = varargout(2:end);
