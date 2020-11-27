function [p, varargout] = size (s, varargin)
  n = s.nGDLs;
  
  if nargin > 2
    error('size: apenas dois argumentos S e DIM são aceitáveis');
  end
  
  if nargin == 2
    dim = varargin{1};
    if fix (dim(1)) ~= dim(1)
      error('size: DIM deve ser um valor inteiro');
    end
    
    if nargout > 1
      error('size: apenas uma saída é possível quando se define DIM');
    end
    
    if (dim == 1) || (dim == 2)
      p = n;
      return;
    else
      if n == 0
        p = 0;
      else
        p = 1;
      end
      return;
    end
  end
  
  p = [n n];
  
  if nargout > 1
    varargout = cell (1, nargout - 1);
    p = n;
    varargout{1} = n;
    for i = 2 : nargout - 1
      if n == 0
        varargout{i} = 0;
      else
        varargout{i} = 1;
      end
    end
  end
