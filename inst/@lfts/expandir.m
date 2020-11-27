function so = expandir (si)
  %% Parâmetros
  gdls   = get (si, 'gdls');
  maxGDL = max (gdls);
  
  %% Verifica se já está expandida ou se é vazia
  if isequal (gdls, sort(gdls), 1:maxGDL) || isempty (si)
    so = si;
    return;
  end
  
  %% Campos a serem percorridos cuja ordem deve ser a mesma
  %% das entrada do construtor
  campos    = {'rigidez', 'massa', 'amortecimento'};
  
  %% Célula para armazenar matrizes expandidas
  mo        = {};
  
  %% Laço pelos campos
  for i = 1 : 3
    mi = get (si, campos{i});
    
    if isempty (mi)
      break; % Interromper laço para não gerar mais entradas que as necessárias
      
    else
      m_tmp             = zeros (maxGDL, maxGDL);
      m_tmp(gdls, gdls) = mi;
      mo{i}             = m_tmp;
    end
  end
  
  %% Criando nova estrutura
  so = lfts(mo{:});
