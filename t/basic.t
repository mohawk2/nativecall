use strict;
use warnings;
use Test::More tests => 1;

use parent qw(NativeCall);

sub fmax :Args(double, double) :Native :Returns(double) {}
is fmax(2.0, 3.0), 3.0;
