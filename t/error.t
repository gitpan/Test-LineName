use strict;
use warnings;

use Test::More tests => 5;

eval 'use Test::LineName;';
like $@, qr/Test::LineName must be use\(\)ed with two args/,
     "bare use";

eval 'use Test::LineName "foo";';
like $@, qr/Test::LineName must be use\(\)ed with two args/,
     "1arg use";

eval 'use Test::LineName "---", "foo";';
like $@, qr/Invalid Test::LineName line naming pragma \[---\]/,
     "bad pragma";

eval 'use Test::LineName foo => 12;';
like $@, qr/2nd arg to 'use Test::LineName' must be a hashref/,
     "bad hashref";

eval 'my %x; use Test::LineName Carp => \%x;';
like $@, qr/Test::LineName pragma \[Carp\] clashes with the Carp module/,
     "pragma clash";
