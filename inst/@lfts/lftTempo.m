function x = lftTempo (s, gdls, carregamento, tempo)
  
  %===============================
  % Verificação de argumentos
  %===============================
  
  %% Verifica se as frequências estão num vetor
  if ~isvector(tempo)
      error('lftTempo: TEMPO deve ser um vetor')
  end
  nF = length(tempo);     % Número de frequências
    
  %% Verifica se gdls é vetor válido
  if ~isvector (gdls) ...
  || ~isa (gdls, 'double') ...
  || ~isequal (gdls, fix(gdls))
    error('lftTempo: GDLS deve ser um vetor de inteiros');
  
  elseif length(gdls) > s.nGDLs ...
  || max(gdls) > s.nGDLs ...
  || min(gdls) < 1
    error('lftTempo: GDLS fora dos limites da estrutura');
  end
  nGDLSin = length(gdls);   % Número de graus de liberdade do carregamento
  
  %% Verifica o carregamento
  if ~isa (carregamento,'function_handle') % Verifica se é função
    error('lftTempo: CARREGAMENTO deve ser uma função');
  end
  
  if ~isequal ([nGDLSin, 1], size (carregamento (tempo(1))))
    error('lftTempo: CARREGAMENTO e GDLS tem tamnhos incompatíveis');
  end
  
  
  %% Expandindo matrizes
  s = expandir(s);
  
  %===============================
  % Representação no estado de espaços
  %===============================
  
  M_inv = inv (s.massa);
  On    = zeros (s.nGDLs);
  In    = eye (s.nGDLs);
  On1   = zeros (s.nGDLs, 1);
  edoFunc = @(t,x) ( [On, In; -M_inv*s.rigidez, -M_inv*s.amortecimento]*x ...
                   + [On1; M_inv*_f_load_(carregamento(t), s.nGDLs, gdls)]);
                   
  %===============================
  % Resolvendo a EDO
  %===============================
  
  [ts,x] = ode45 (edoFunc, tempo, zeros (s.nGDLs*2, 1));
  x = x(:,1:s.nGDLs)';
  
function fo = _f_load_ (fi, n, gs)
  fo = zeros (n, 1);
  fo(gs) = fi;
