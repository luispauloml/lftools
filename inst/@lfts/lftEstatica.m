function x = lftEstatica (s, carregamento, gdls)
  %% Verifica se há matriz de rigidez
  if isempty (s.rigidez)
    error('lftEstatica: a estrutura não possui matriz de rigidez');
  end
  
  %% Verifica os GDLs e carregamento
  teste = @(v) (~isvector (v) || ~isa (v, 'double'));
  if teste(carregamento)
    error('lftEstatica: GDLS deve ser um vetor');
  elseif teste(gdls)
    error('lftEstatica: CARREGAMENTO deve ser um vetor');
  end
  
  %% Verifica se o número de GDLs é válido e compatível com o carregamento
  if max (gdls) > s.nGDLs ...
  || min (gdls) < 1 ...
  || length(gdls) ~= length(carregamento)
    error('lftEstatica: GDLS incompatíveis');
  end
  
  %% Gerando carregamento
  f = zeros(s.nGDLs, 1);
  f(gdls) = carregamento(:);
  
  %% Calculando deslocamentos
  x = expandir(s).rigidez * f;
