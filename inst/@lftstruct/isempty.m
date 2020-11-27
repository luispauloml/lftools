function b = isempty (s)
  b = hasMassa (s) || hasAmortecimento (s) || hasRigidez (s);
  b = ~b;
