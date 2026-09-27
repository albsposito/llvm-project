/* p.clip probe: saturate to int8 and uint8 ranges. */
int clip_s8(int x) { return __builtin_pulp_clip(x, -128, 127); }
unsigned int clipu_u8(int x) { return __builtin_pulp_clipu(x, 0, 255); }
