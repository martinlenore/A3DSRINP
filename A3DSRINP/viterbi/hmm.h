#ifndef HMM_H
#define HMM_H

#include <unistd.h>
#include "viterbi.h"
#include "cache.h"

typedef struct _matrix_t {
  long double *data;
  size_t alloc;
  size_t x;
  size_t y;
} matrix_t;

typedef struct _vector_t {
  long double *data;
  size_t alloc;
  size_t len;
} vector_t;

typedef struct _obs_vector_t {
	size_t *data;
	size_t alloc;
	size_t len;
} obs_vector_t;

typedef struct _hmm2d_t {
  size_t n;
  size_t *states;
  size_t t;
  size_t *obs;
  matrix_t *ax;
  matrix_t *ay;
  vector_t *pix;
  vector_t *piy;
  matrix_t *bx;
  matrix_t *by;
  obs_vector_t *xobs;
  obs_vector_t *yobs;
} hmm2d_t;

#ifdef __cplusplus
extern "C" {
#endif

matrix_t *init_matrix(size_t x, size_t y);
long double *matrix_el(matrix_t *m, size_t x, size_t y);
vector_t *init_vector(size_t x);
obs_vector_t *init_obs_vector(size_t x);
void vector_free(vector_t *vec);
void obs_vector_free(obs_vector_t *vec);
int vector_push(vector_t *vec, long double el);
int obs_vector_push(obs_vector_t *vec, size_t el);
long double *vector_el(vector_t *vec, size_t i);
size_t *obs_vector_el(obs_vector_t *vec, size_t i);

viterbi2d_result_t *init_viterbi2d_result();
void viterbi2d_free(viterbi2d_result_t *res);
long state_to_idx(hmm2d_t *hmm, size_t k);
viterbi2d_result_t *viterbi2d(hmm2d_t *hmm, cache_t *cache, size_t t, size_t k);
viterbi2d_result_t *viterbi2d_max(hmm2d_t *hmm, cache_t **cache);
viterbi2d_result_t *viterbi2d_max_no_cache(hmm2d_t *hmm);
hmm2d_t *init_hmm2d();
void print_hmm(hmm2d_t *);
void reconstruct(hmm2d_t *hmm, cache_t *cache, const char *filename);

#ifdef __cplusplus
}
#endif

#endif
