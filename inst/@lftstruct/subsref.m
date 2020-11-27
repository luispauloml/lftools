function v = subsref (val, idxin)
  %% Verifica idx
  if ~isfield (idxin, 'type') || ~isfield (idxin, 'subs')
    error('subsref: second argument must be a structure with fields ''type'' and ''subs''');
  end
  
  idx.type = {idxin.type};
  idx.subs = {idxin.subs};
  
  %% Verifica se usa nota��o de ponto
  if ~isequal (idx.type{1}, '.')
    error('subsref: lftstruct s� pode ser indexada com '',''');
  end
  
  %% Verifica se s�o campos permitidos
  candidatos = {'massa', 'rigidez', 'amortecimento', 'gdls'};
  if ~ismember (idx.subs{1}, candidatos)
    error('subsref: campo inv�lido');
  end
  
  %% Se passar nas checagens, destruir lftstrcut e passar para subsref nativo
  %% (jeito errado de desligar avisos, mas funciona sem penalidades aparentes)
  warning off
  v = subsref (struct (val), idxin);
  warning on
