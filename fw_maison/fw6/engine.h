/* engine.h : interface du moteur de grille (engine.c) */
#pragma once
void engine_clear(void);
int engine_block_set(int lane, int col, int model);
void engine_block_clear(int lane, int col);
int engine_block_move(int lane1, int col1, int lane2, int col2);
int engine_param(int lane, int col, int idx, float v);
int engine_bypass(int lane, int col, int on);
void engine_scene_store(int sc, int lane, int col, int on, const float *p, int n);
int engine_scene_select(int sc);
void engine_split(int from, int to, int mix);
void engine_level(float db);
int engine_scene(void);
unsigned int engine_version(void);
int engine_get(int lane, int col, int *model, int *on);
const float *engine_params(int lane, int col);
int engine_toggle_family(int fam, int *lane, int *col);
int engine_family_on(int fam);
int engine_process(int x);
int engine_model_by_name(const char *s, int n);
int engine_model_ready(int m);
unsigned int engine_mem_free(void);
unsigned int engine_mods(void);
int engine_scene_get(int sc, int lane, int col, int *on, float *p);
int engine_sections(unsigned char *from, unsigned char *to, unsigned char *mix);
