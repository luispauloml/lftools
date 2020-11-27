function so = uminus (si)
  if isempty(si)
    so = si;
    return;
  end

  campos = {'rigidez', 'massa', 'amortecimento'};
  mo = {};
  
  for i = 1 : 3
    mi = get (si, campos{i});
    
    if isempty (mi)
      break;
    else
      mo{i} = - mi;
    end
  end
  
  so = lfts (mo{:});
  so = set (so, 'gdls', get (si, 'gdls'));
