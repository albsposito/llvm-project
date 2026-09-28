typedef float16 v2h __attribute__((vector_size (4)));typedef short v2s __attribute__((vector_size (4)));
int any_lt(v2h a, v2h b){ v2s m = a < b; return m[0] != 0 || m[1] != 0; }
v2h sel(v2h a, v2h b){ v2s m = a < b; return (v2h)(((v2s)a & m) | ((v2s)b & ~m)); }
