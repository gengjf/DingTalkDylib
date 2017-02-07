
#ifndef JFFishHook_h
#define JFFishHook_h

#include <stddef.h>
#include <stdint.h>

#if !defined(JFFISHHOOK_EXPORT)
#define JFFISHHOOK_VISIBILITY __attribute__((visibility("hidden")))
#else
#define JFFISHHOOK_VISIBILITY __attribute__((visibility("default")))
#endif

#ifdef __cplusplus
extern "C" {
#endif //__cplusplus

/*
 * A structure representing a particular intended rebinding from a symbol
 * name to its replacement
 */
struct _jf_rebinding {
  const char *name;
  void *replacement;
  void **replaced;
};

/*
 * For each _jf_rebinding in _jf_rebindings, rebinds references to external, indirect
 * symbols with the specified name to instead point at replacement for each
 * image in the calling process as well as for all future images that are loaded
 * by the process. If rebind_functions is called more than once, the symbols to
 * rebind are added to the existing list of _jf_rebindings, and if a given symbol
 * is rebound more than once, the later _jf_rebinding will take precedence.
 */
JFFISHHOOK_VISIBILITY
int _jf_rebind_symbols(struct _jf_rebinding rebindings[], size_t rebindings_nel);

/*
 * Rebinds as above, but only in the specified image. The header should point
 * to the mach-o header, the slide should be the slide offset. Others as above.
 */
JFFISHHOOK_VISIBILITY
int _jf_rebind_symbols_image(void *header,
                         intptr_t slide,
                         struct _jf_rebinding rebindings[],
                         size_t rebindings_nel);

#ifdef __cplusplus
}
#endif //__cplusplus

#endif //JFFishHook_h

