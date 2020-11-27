function so = plus (s1, s2)
  %% Verifica a classe dos operandos
  if ~isa (s1, 'lfts') || ~isa (s2, 'lfts')
    error('adição e subtração implementadas apenas para operações entre ''lfts''');
  end

  %% Verifica se alguma das estruturas está vazia
  %% Se uma estiver vazia, retornar a outra
  if isempty (s1)
    so = s2;
    return;
  elseif isempty (s2)
    so = s1;
    return;
  end
  
  %% Expandindo entradas
  si   = {expandir(s1), expandir(s2)};
  gdls = {get(si{1}, 'gdls'), get(si{2}, 'gdls')};
  
  %% Maior índice de GDL
  maxGDLs = max ([gdls{1}, gdls{2}]);
  
  %% Percorrendo as estruturas
  matrizes = {'rigidez', 'massa', 'amortecimento'};
  mo = {};
  M0 = zeros (maxGDLs, maxGDLs);
  
  for i = 1 : 3 
    m_tmp = M0;
    
    for j = 1 : 2
      mi = get (si{j}, matrizes{i});
      
      if ~isempty(mi)
          m_tmp(gdls{j}, gdls{j}) = m_tmp(gdls{j}, gdls{j}) + mi;
      end%if empty
    end%for j
    
    if ~isequal (m_tmp, M0)
      mo{i} = m_tmp;
    end
  end
  
  so = lfts(mo{:});
