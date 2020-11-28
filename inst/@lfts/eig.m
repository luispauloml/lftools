function [varargout] = eig (s)
  
  %% N�mero de entradas
  if nargin > 1
    error('eig: apenas uma entrada � permitida');
  end
  
  %% Verifica se massa ou rigidez est�o presentes
  if isempty (s.massa) || isempty (s.rigidez)
    error('eig: matriz de massa ou de rigidez n�o definida');
  end
  
  %% Expandir
  s = expandir(s);
  
  %% Verifica se h� amortecimento
  flagAmortecimento = ~isempty(s.amortecimento);
  if flagAmortecimento
    im    = inv(s.massa); %matriz de massa invertida
  end
  
  %% Passando par�metro para eig nativo
  switch nargout
    case {0, 1}
      if flagAmortecimento
        lambda = eig([zeros(size(im)), eye(size(im)); -im*s.rigidez, -im*s.amortecimento]);
      else
        lambda = eig(s.rigidez,s.massa);
      end
      
    case 2
      if flagAmortecimento
        [v, lambda] = eig([zeros(size(im)), eye(size(im)); -im*s.rigidez, -im*s.amortecimento]);
      else
        [v, lambda] = eig(s.rigidez, s.massa);
      end
      
    case 3
      if flagAmortecimento
        [v, lambda, w] = eig([zeros(size(im)), eye(size(im)); -im*s.rigidez, -im*s.amortecimento]);
      else
        [v, lambda, w] = eig(s.rigidez, s.massa);
      end
    otherwise
      error('eig: n�mero de sa�das indefinido');
  end

  %% Ordenando sa�das
  switch nargout
    case {0, 1}
      varargout = {lambda};
    case 2
      varargout = {v,lambda};
    case 3
      varargout = {v, lambda, w};
  end
