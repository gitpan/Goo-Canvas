#! /usr/bin/perl -w
use 5.008;
use strict;
use warnings;
use Cwd;
use File::Spec;
use ExtUtils::MakeMaker;

# minimum required version of dependancies we need to build
our %build_reqs = (
	'perl-ExtUtils-Depends'   => '0.2',
	'perl-ExtUtils-PkgConfig' => '1.0',
	'perl-Glib'               => '1.103',
	'perl-Gtk2'               => '1.100',
	'perl-Cairo'              => '1.00',
	'goocanvas'           => '0.6',
);

our %prereqs = (
	'Glib'                => $build_reqs{'perl-Glib'},
	'Gtk2'                => $build_reqs{'perl-Gtk2'},
	'Cairo'               => $build_reqs{'perl-Cairo'},
	'ExtUtils::Depends'   => $build_reqs{'perl-ExtUtils-Depends'},
	'ExtUtils::PkgConfig' => $build_reqs{'perl-ExtUtils-PkgConfig'},
);

# Writing a fake Makefile ensures that CPAN will pick up the correct
# dependencies and install them.
unless (eval "use ExtUtils::Depends;"
           . "use ExtUtils::PkgConfig;"
           . "use Gtk2::CodeGen;"
           . "use Cairo;"
           # just seeing if Glib is available isn't enough, make sure
           # it's recent enough, too 
           . "use Glib '$build_reqs{'perl-Glib'}';"
           . "use Gtk2 '$build_reqs{'perl-Gtk2'}';"
           . "use Glib::MakeHelper;"
           . "1") {
   warn "$@\n";
   WriteMakefile(
         PREREQ_FATAL => 1,
         PREREQ_PM    => \%prereqs,
   );
   exit 1; # not reached
}

mkdir 'build', 0777;

our %pkgcfg = ExtUtils::PkgConfig->find ('goocanvas');

# now we're ready to start creating the makefile.
# we need to use ExtUtils::Depends to get relevant information out of
# the Glib extension, and to save config information for other modules which
# will chain from this one.

our @xs_files = <xs/*.xs>;
our %pm_files = (
    'lib/Goo/Canvas.pm' => '$(INST_LIBDIR)/Canvas.pm',
);
our %pod_files;
%pod_files = (
    'lib/Goo/Canvas.pm' => '$(INST_MAN3DIR)/Goo::Canvas.$(MAN3EXT)',
    Glib::MakeHelper->do_pod_files (@xs_files),
);

ExtUtils::PkgConfig->write_version_macros (
    "build/goocanvas-perl-version.h",
    'goocanvas' => 'GOO_CANVAS'
);

#
# autogeneration
#
Gtk2::CodeGen->parse_maps ('goocanvas-perl');
Gtk2::CodeGen->write_boot (ignore => '^Goo::Canvas$');

my $goo = ExtUtils::Depends->new ('Goo::Canvas', 'Gtk2', 'Glib', 'Cairo');
$goo->set_inc ($pkgcfg{cflags} . ' -I./build ');
$goo->set_libs ($pkgcfg{libs});
$goo->add_xs (@xs_files);
$goo->add_pm (%pm_files);
my $cwd = cwd();
$goo->add_typemaps (
    File::Spec->catfile( $cwd, 'build/goocanvas-perl.typemap'),
    File::Spec->catfile( $cwd, 'goocanvas.typemap'),
);
$goo->install (qw(goocanvas-perl.h
		build/goocanvas-perl-autogen.h
		build/goocanvas-perl-version.h));
$goo->save_config ('build/IFiles.pm');
use Data::Dumper qw(Dumper);

WriteMakefile(
    NAME          => 'Goo::Canvas',
    VERSION_FROM  => 'lib/Goo/Canvas.pm', # finds $VERSION
    PREREQ_PM     => \%prereqs,
    ABSTRACT_FROM => 'lib/Goo/Canvas.pm', # retrieve abstract from module
    XSPROTOARG    => '-noprototypes',
    MAN3PODS	  => \%pod_files,
    $goo->get_makefile_vars,
);

print <<__EOW__;
WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING

   This is an unstable development release of Gtk2::SourceView.
   The API is not frozen and things are subject to change at any
   time.  Report any bugs to gtk-perl-list AT gnome DOT org as
   soon as possible. Please use the 1.00x series for important work.

WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING
__EOW__

sub MY::postamble {
	return Glib::MakeHelper->postamble_clean ()
        . Glib::MakeHelper->postamble_docs (@main::xs_files)
            . Glib::MakeHelper->postamble_rpms (
                'GOO_CANVAS' => $build_reqs{'goocanvas'},
                'PERL_EXTUTILS_DEPENDS' => 
                    $build_reqs{'perl-ExtUtils-Depends'},
                'PERL_EXTUTILS_PKGCONFIG' => 
                    $build_reqs{'perl-ExtUtils-PkgConfig'},
                'PERL_GLIB' => $build_reqs{'perl-Glib'},
                'PERL_GTK' => $build_reqs{'perl-Gtk2'},
                'PERL_CAIRO' => $build_reqs{'perl-Cairo'},
            );
}
