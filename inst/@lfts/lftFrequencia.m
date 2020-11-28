function X = lftFrequencia (s, gdls, carregamento, freqs)
  
  %===============================
  % Verifica��o de argumentos
  %===============================
  
  %% Verifica se as frequ�ncias est�o num vetor
  if ~isvector(freqs)
      error('lftFrequencia: FREQS deve ser um vetor')
  end
  nF = length(freqs);     % N�mero de frequ�ncias
    
  %% Verifica se gdls � vetor v�lido
  if ~isvector (gdls) ...
  || ~isa (gdls, 'double') ...
  || ~isequal (gdls, fix(gdls))
    error('lftFrequencia: GDLS deve ser um vetor de inteiros');
  
  elseif length(gdls) > s.nGDLs ...
  || max(gdls) > s.nGDLs ...
  || min(gdls) < 1
    error('lftFrequencia: GDLS fora dos limites da estrutura');
  end
  nGDLSin = length(gdls);   % N�mero de graus de liberdade do carregamento
  
  %% Verifica o carregamento
  flagFuncaoCarregamento = false;
  
  if isa (carregamento,'function_handle') % Verifica se � fun��o
    flagFuncaoCarregamento = true;
    if ~isequal ([nGDLSin, 1], size (carregamento (freqs(1))))
      error('lftFrequencia: CARREGAMENTO e GDLS tem tamnhos incompat�veis');
    end
    
  elseif ismatrix (carregamento)          % Verifica se � matriz
      if ~isequal ([nGDLSin, nF], size (carregamento))
      error('lftFrequencia: CARREGAMENTO e GDLS tem tamnhos incompat�veis');
    end
    
  else                                    % Se n�o for nem matriz, nem fun��o
    error('lftFrequencia: CARREGAMENTO deve ser uma matriz ou uma fun��o');
  end
  
  %===============================
  % Adiciona zeros nas matrizes vazias
  %===============================
  matvazias = camposVazios(s);
  for i = 1 : size(matvazias, 1)
    s.(matvazias{i}) = 0;
  end
  
  
  %===============================
  % Discretizando o carregamento
  %===============================
  
  if flagFuncaoCarregamento
    fLoad        = carregamento;        % Transfere a fun��o para um novo nome
    carregamento = zeros (nGDLSin, nF); % Cria uma matriz de carregamento nula
    
    for i = 1 : nF
      carregamento(:,i) = fLoad (freqs(i));
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
  
  %% Vetor de carregamento nulo
  F = zeros (s.nGDLs, 1);
  
  %% Matriz de sa�da
  X = zeros (s.nGDLs, nF);
  
  %% Expandir estrutura
  s = expandir(s);
  
  %% Substitui matrizes vazias por zeros
  matvazias = camposVazios(s);
  for i = 1 : size(matvazias, 1)
    s.(matvazias{i}) = 0;
  end
  
  for i = 1:nF
      %% Frequencia
      freq = freqs(i);
      
      %% Carregamento
      F(gdls) = carregamento(:,i);
      
      %% Matriz de transforma��o
      T = -(2 * pi * freq)^2    * s.massa ...
        + 1i * (2 * pi * freq)  * s.amortecimento ...
                                + s.rigidez;
      
      %% Deslocamento
      X(:,i) = inv(T)*F;
  end
