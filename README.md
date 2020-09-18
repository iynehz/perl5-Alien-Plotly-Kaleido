[![Build Status](https://travis-ci.org/stphnlyd/perl5-Alien-Plotly-Kaleido.svg?branch=master)](https://travis-ci.org/stphnlyd/perl5-Alien-Plotly-Kaleido)
[![AppVeyor Status](https://ci.appveyor.com/api/projects/status/github/stphnlyd/perl5-Alien-Plotly-Kaleido?branch=master&svg=true)](https://ci.appveyor.com/project/stphnlyd/perl5-Alien-Plotly-Kaleido)

# NAME

Alien::Plotly::Kaleido - Finds or installs plotly kaleido

# VERSION

version 0.0001

# SYNOPSIS

```perl
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
```

# DESCRIPTION

This module finds [plotly's kaleido](https://github.com/plotly/Kaleido)
from your system, or installs it (version 0.0.3.post1).

For installation it uses prebuilt packages from
[kaleido's github release page](https://github.com/plotly/Kaleido/releases).
It supports 3 OS platforms: Windows, Linux and OSX.

# SEE ALSO

[https://github.com/plotly/Kaleido](https://github.com/plotly/Kaleido)

[Alien](https://metacpan.org/pod/Alien), 
[Chart::Plotly](https://metacpan.org/pod/Chart%3A%3APlotly)

# AUTHOR

Stephan Loyd <sloyd@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2020 by Stephan Loyd.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
