package Goo::Canvas::Install::Files;

$self = {
          'inc' => '-I/usr/include/goocanvas-1.0 -I/usr/include/gtk-2.0 -I/usr/include/cairo -I/usr/lib/gtk-2.0/include -I/usr/include/atk-1.0 -I/usr/include/pango-1.0 -I/usr/include/glib-2.0 -I/usr/lib/glib-2.0/include -I/usr/include/freetype2 -I/usr/include/libpng12   -I./build ',
          'typemaps' => [
                          'goocanvas-perl.typemap',
                          'goocanvas.typemap'
                        ],
          'deps' => [
                      'Glib',
                      'Gtk2',
                      'Cairo'
                    ],
          'libs' => '-lgoocanvas -lgtk-x11-2.0 -lgdk-x11-2.0 -latk-1.0 -lgdk_pixbuf-2.0 -lm -lpangocairo-1.0 -lfontconfig -lXext -lXrender -lXinerama -lXi -lXrandr -lXcursor -lXfixes -lpango-1.0 -lcairo -lX11 -lgobject-2.0 -lgmodule-2.0 -ldl -lglib-2.0  '
        };


# this is for backwards compatiblity
@deps = @{ $self->{deps} };
@typemaps = @{ $self->{typemaps} };
$libs = $self->{libs};
$inc = $self->{inc};

	$CORE = undef;
	foreach (@INC) {
		if ( -f $_ . "/Goo/Canvas/Install/Files.pm") {
			$CORE = $_ . "/Goo/Canvas/Install/";
			last;
		}
	}

1;
