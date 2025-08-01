/*
 * mi-malloc: a compact general-purpose allocator with excellent performance
 * https://microsoft.github.io/mimalloc
 *
 * Build mimalloc as a single static object containing the entire library. This
 * should override all of the standard allocation functions.
 */

#include "mimalloc-cbits.h"
#include "mimalloc/src/static.c"

