function s = ctranspose (s)
  s.massa = s.massa';
  s.amortecimento = s.amortecimento';
  s.rigidez = s.rigidez';
end%function