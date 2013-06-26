package HTTP::Daemon::patch::ipv6;

use 5.010001;
use strict;
no warnings;

use Module::Patch 0.10 qw();
use base qw(Module::Patch);

# VERSION

use IO::Socket qw(AF_INET INADDR_ANY INADDR_LOOPBACK inet_ntop);
my $p_url = sub {
    my $ctx  = shift;
    my $orig = $ctx->{orig};

    my $self = shift;
    my $url = $self->_default_scheme . "://";
    my $addr = $self->sockaddr;
    if (!$addr || $addr eq INADDR_ANY || $self->isa("IO::Socket::INET6")) {
        require Sys::Hostname;
        $url .= lc Sys::Hostname::hostname();
    }
    elsif ($addr eq INADDR_LOOPBACK) {
        $url .= inet_ntoa($addr);
    }
    else {
        $url .= gethostbyaddr($addr, AF_INET) || inet_ntop(AF_INET,$addr);
    }
    my $port = $self->sockport;
    $url .= ":$port" if $port != $self->_default_port;
    $url .= "/";
    $url;
};

sub patch_data {
    return {
        v => 3,
        patches => [
            {
                action => 'wrap',
                mod_version => qr/^6\.0.+/,
                sub_name => 'url',
                code => $p_url,
            },
        ],
    };
}

1;
# ABSTRACT: Patch module for HTTP::Daemon

=head1 SYNOPSIS

 use HTTP::Daemon::patch::ipv6;


=head1 DESCRIPTION

This module contains patch for HTTP::Daemon::url() for
https://rt.cpan.org/Ticket/Display.html?id=71395

=cut
