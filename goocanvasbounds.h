/* @(#)goocanvasbounds.h
 */

#ifndef _GOOCANVASBOUNDS_H
#define _GOOCANVASBOUNDS_H 1

#include "goocanvas.h"
G_BEGIN_DECLS
#define GOO_TYPE_CANVAS_BOUNDS (goo_canvas_bounds_get_type())

GType goo_canvas_bounds_get_type();

GooCanvasBounds* goo_canvas_bounds_copy(const GooCanvasBounds* src);
gboolean goo_canvas_bounds_equal(const GooCanvasBounds* a,
                                 const GooCanvasBounds* b);

G_END_DECLS

#endif /* _GOOCANVASBOUNDS_H */

