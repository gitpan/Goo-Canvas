#define GOO_CANVAS_MAJOR_VERSION (0)
#define GOO_CANVAS_MINOR_VERSION (6)
#define GOO_CANVAS_MICRO_VERSION (0)
#define GOO_CANVAS_CHECK_VERSION(major,minor,micro) \
	(GOO_CANVAS_MAJOR_VERSION > (major) || \
	 (GOO_CANVAS_MAJOR_VERSION == (major) && GOO_CANVAS_MINOR_VERSION > (minor)) || \
	 (GOO_CANVAS_MAJOR_VERSION == (major) && GOO_CANVAS_MINOR_VERSION == (minor) && GOO_CANVAS_MICRO_VERSION >= (micro)))