package Alien::Plotly::Kaleido;

# ABSTRACT: Finds or installs plotly kaleido

use 5.010;
use strict;
use warnings;

# VERSION

use parent 'Alien::Base';

use File::Which qw(which);
use IPC::Run ();
use JSON ();
use Path::Tiny ();

sub bin_dir {
    my ($class) = @_;
    if ( $class->install_type eq 'system' ) {
        return Alien::Base::bin_dir($class);
    }
    else {
        return Path::Tiny->new( $class->dist_dir );
    }
}

sub version {
    my ($self) = @_;
    if ( $self->install_type eq 'system' ) {
        state $version;
        unless ($version) {
            $version = $self->detect_kaleido_version;
        }
        return $version;
    }
    else {
        return $self->SUPER::version;
    }
}

sub detect_kaleido_version {
    my ($class) = @_;

    my $kaleido = which('kaleido');
    if ($kaleido) {
        my $decode_json_safe = sub {
            my ($out) = @_;
            my $data;
            eval { $data = JSON::decode_json($out); };
            $@ = '' if ($@);
            return $data;
        };

        my $cmd = [ $kaleido, 'plotly', '--disable-gpu' ];

        my $h;
        my $data;
        eval {
            my ( $in, $out, $err );
            my $t = IPC::Run::timer(30);
            if ( $^O eq 'MSWin32' ) {
                $h = IPC::Run::start( $cmd, \$in, \$out, \$err, $t );
            }
            else {
                $h =
                  IPC::Run::start( $cmd, \$in, '>pty>', \$out, '2>', \$err,
                    $t );
            }
            while ( not $data and not $t->is_expired ) {
                $h->pump;
                $data = $decode_json_safe->($out);
            }
            if ($^O eq 'MSWin32') {
                $h->finish;
            }
        };
        if ($^O ne 'MSWin32') {
            $h->kill_kill;
        }
        if ($@) {
            warn $@;
            $h->kill_kill;
        }
        if ( $data and exists $data->{version} ) {
            return $data->{version};
        }
    }

    die "Failed to detect kaleido version";
}

1;

__END__

=head1 SYNOPSIS

    use Alien::Plotly::Kaleido;
    use Config;

    if (Alien::Plotly::Kaleido->install_type eq 'share') {
        $ENV{PATH} = join(
            $Config{path_sep},
            Alien::Plotly::Kaleido->bin_dir,
            $ENV{PATH}
        );

        # get version
        my $version = Alien::Plotly::Kaleido->version;
    }

    # If install_type is not 'share' then it means kaleido
    # was detected from PATH when Alien::Plotly::Kaleido was installed.
    # So in either case now you has 'kaleido' in PATH.

=head1 DESCRIPTION

This module finds L<plotly's kaleido|https://github.com/plotly/Kaleido>
from your system, or installs it (version 0.0.3.post1).

For installation it uses prebuilt packages from
L<kaleido's github release page|https://github.com/plotly/Kaleido/releases>.
It supports 3 OS platforms: Windows, Linux and OSX.

=head1 SEE ALSO

L<https://github.com/plotly/Kaleido>

L<Alien>, 
L<Chart::Plotly>

