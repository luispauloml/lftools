function c = camposVazios(s)
  candidatos = {'massa', 'amortecimento', 'rigidez'};
  c = {};
  
  for i = 1 : 3
    if isempty (s.(candidatos{i}))
      c{1,end+1} = candidatos{i};
    end
  end
