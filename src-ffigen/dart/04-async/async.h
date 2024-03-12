#include "zig.h"
zig_extern void hello_world_async(uint8_t *const a0, void (*const a1)(uint8_t *));
zig_extern intptr_t write(int32_t const a0, uint8_t const *const a1, uintptr_t const a2);
zig_extern zig_noreturn void abort(void);
zig_extern int getcontext(struct ucontext_t__7101 *const a0);
zig_extern int *zig_e___errno_location(void);
zig_extern int dl_iterate_phdr(int (*const a0)(struct dl_phdr_info__5040 *, uintptr_t, void *), void *const a1);
zig_extern void *mmap64(void *const a0, uintptr_t const a1, unsigned int const a2, unsigned int const a3, int32_t const a4, int64_t const a5);
zig_extern int sigaction(int const a0, struct Sigaction__3982 const *const a1, struct Sigaction__3982 *const a2);
zig_extern int close(int32_t const a0);
zig_extern uint8_t *realpath(uint8_t const *const a0, uint8_t *const a1);
zig_extern intptr_t read(int32_t const a0, uint8_t *const a1, uintptr_t const a2);
zig_extern int msync(void const *const a0, uintptr_t const a1, int const a2);
zig_extern int munmap(void const *const a0, uintptr_t const a1);
zig_extern uint8_t *getenv(uint8_t const *const a0);
zig_extern int openat64(int const a0, uint8_t const *const a1, uint32_t const a2, ...);
zig_extern int flock(int32_t const a0, int const a1);
zig_extern int fstat64(int32_t const a0, struct Stat__8142 *const a1);
zig_extern int isatty(int32_t const a0);
