#ifndef __LIBWHIRLPOOL_ENVOY_H
#define __LIBWHIRLPOOL_ENVOY_H

#include <graal_isolate.h>


#if defined(__cplusplus)
extern "C" {
#endif

int run_main(int argc, char** argv);

int whirlpool(graal_isolatethread_t*);

int stop(graal_isolatethread_t*);

#if defined(__cplusplus)
}
#endif
#endif
