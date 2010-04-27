use strict;
use warnings;

use Carp;
use Test::More tests => 7;

{
    my %Line;
    use Test::LineName linename => \%Line;

    eval {
        die "oops";   use linename 'foo';
    };

    is $@, "oops at $0 line $Line{foo}.\n", "SYNOPSIS example";
}

{
    my %Line;
    use Test::LineName linename => \%Line;

    eval {                use linename 'eval';
        outer_sub();      use linename 'outer_call';
    };

    is $@, <<END, "DESCRIPTION example";
woo at $0 line $Line{confess}
\tmain::inner_sub() called at $0 line $Line{inner_call}
\tmain::outer_sub() called at $0 line $Line{outer_call}
\teval {...} called at $0 line $Line{eval}
END

    sub outer_sub {
        inner_sub();      use linename 'inner_call';
    }

    sub inner_sub {
        confess "woo";    use linename 'confess';
    }
}

{
    my %Line;
    use Test::LineName linename => \%Line;

    eval {                use linename 'eval';
        outer_sub2();     use linename 'outer_call';
    };

    is $@, <<END, "DESCRIPTION example repeated";
woo at $0 line $Line{confess}
\tmain::inner_sub2() called at $0 line $Line{inner_call}
\tmain::outer_sub2() called at $0 line $Line{outer_call}
\teval {...} called at $0 line $Line{eval}
END

    sub outer_sub2 {
        inner_sub2();     use linename 'inner_call';
    }

    sub inner_sub2 {
        confess "woo";    use linename 'confess';
    }
}

{
    my %Line;
    use Test::LineName linename => \%Line;

    eval {
        die 'foo'; use linename 'foo';
    };
    like $@, qr/ line $Line{foo}\./, "linename on same line";

    eval {
        die 'bar';
        use linename 'bar', -1;
    };
    like $@, qr/ line $Line{bar}\./, "linename on line below";

    eval {
        use linename 'baz', +1;
        die 'baz';
    };
    like $@, qr/ line $Line{baz}\./, "linename on line above";
}

{
    my %Line;
    use Test::LineName linename => \%Line;

    sub foo {
        return 17;  use linename 'fooreturn';
    }

    is foo(), 17, "linename doesn't interfere with return value";
}

