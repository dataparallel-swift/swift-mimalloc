// Copyright (c) 2025 The swift-mimalloc authors. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// mi-malloc: a compact general-purpose allocator with excellent performance
// https://microsoft.github.io/mimalloc
//
// Build mimalloc as a single static object containing the entire library. This
// should override all of the standard allocation functions.

#ifndef _DEFAULT_SOURCE
#define _DEFAULT_SOURCE
#endif

#include "mimalloc-cbits.h"
#include "mimalloc/src/static.c"
