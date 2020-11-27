function s = transpose (s)
  s.massa         = s.massa.';
  s.amortecimento = s.amortecimento.';
  s.rigidez       = s.rigidez.';
