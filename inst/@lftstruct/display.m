function display (s)
  printf ('%s = <objeto ''lftstruct''>\n', inputname (1));
  
  campos = {'massa', 'amortecimento', 'rigidez', 'gdls'};
  
  for i = 1 : length(campos)
    switch campos{i}
      case 'gdls'
        printf ('  graus de liberdade =\n');
      otherwise
        printf ('  %s =\n', campos{i});
    end
    
    if isempty (s.(campos{i}))
      printf('   ');
    end
    
    display (s.(campos{i}));
    printf('\n');
  end
