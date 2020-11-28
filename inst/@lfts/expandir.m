function s = expandir (s)
  %% Verifica se j� est� expandida ou se � vazia
  newGDLs = 1 : s.nGDLs;
  if isequal (s.gdls, sort(s.gdls), newGDLs) || isempty (s)
    return;
  end
  
  %% Campos a serem percorridos
  campos    = {'rigidez', 'massa', 'amortecimento'};
  
  %% La�o pelos campos
  for i = 1 : 3
    mi = s.(campos{i});
    
    if ~isempty (mi)
      m_tmp                 = zeros (s.nGDLs);
      m_tmp(s.gdls, s.gdls) = mi;
      s.(campos{i})         = m_tmp;
    end
  end
  
  s.gdls = newGDLs;
