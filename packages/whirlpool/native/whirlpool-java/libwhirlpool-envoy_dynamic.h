#ifndef __LIBWHIRLPOOL_ENVOY_H
#define __LIBWHIRLPOOL_ENVOY_H

#include <graal_isolate_dynamic.h>


#if defined(__cplusplus)
extern "C" {
#endif

typedef int (*run_main_fn_t)(int argc, char** argv);

typedef int (*whirlpool_fn_t)(graal_isolatethread_t*);

typedef int (*stop_fn_t)(graal_isolatethread_t*);

#if defined(__cplusplus)
}
#endif
#endif
