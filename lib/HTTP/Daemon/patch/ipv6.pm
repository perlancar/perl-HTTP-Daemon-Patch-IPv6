package HTTP::Daemon::patch::ipv6;

use 5.010001;
use strict;
use warnings;

use parent qw(Module::Patch);

# VERSION

sub patch_data {
    return {
        versions => {
            '6.01' => {
                subs => sub {},
            },
        },
    };
}

1;
# ABSTRACT: Setup module
