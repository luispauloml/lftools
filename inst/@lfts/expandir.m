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
  so = lfts(mo{:});
