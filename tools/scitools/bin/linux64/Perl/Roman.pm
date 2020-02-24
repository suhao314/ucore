package Roman;

=head1 NAME

Roman - Perl module for conversion between Roman and Arabic numerals.

=head1 SYNOPSIS

	use Roman;

	$arabic = arabic($roman) if isroman($roman);
	$roman = Roman($arabic);
	$roman = roman($arabic);

=head1 DESCRIPTION

This package provides some functions which help conversion of numeric
notation between Roman and Arabic.

=head1 BUGS

Domain of valid Roman numerals is limited to less than 4000, since
proper Roman digits for the rest are not available in ASCII.

=head1 CHANGES

1997/09/03 Author's address is now <ozawa@aisoft.co.jp>

=head1 AUTHOR

OZAWA Sakuro <ozawa@aisoft.co.jp>

=head1 COPYRIGHT

Copyright (c) 1995 OZAWA Sakuro.  All rights reserved.  This program
is free software; you can redistribute it and/or modify it under the
same terms as Perl itself.

=cut

$RCS = '$Id: Roman.pm 7000 2003-01-23 19:13:48Z dll $';

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw(isroman arabic Roman roman);

BEGIN {
    %roman2arabic = qw(I 1 V 5 X 10 L 50 C 100 D 500 M 1000);
}

sub isroman {
    my($arg) = shift;
    $arg ne '' and
      $arg =~ /^(?: M{0,3})
                (?: D?C{0,3} | C[DM])
                (?: L?X{0,3} | X[LC])
                (?: V?I{0,3} | I[VX])$/ix;
}

sub arabic {
    my($arg) = shift;
    isroman $arg or return undef;
    my($last_digit) = 1000;
    my($arabic);
    foreach (split(//, uc $arg)) {
        my($digit) = $roman2arabic{$_};
        $arabic -= 2 * $last_digit if $last_digit < $digit;
        $arabic += ($last_digit = $digit);
    }
    $arabic;
}

BEGIN {
    %roman_digit = qw(1 IV 10 XL 100 CD 1000 MMMMMM);
    @figure = reverse sort keys %roman_digit;
    grep($roman_digit{$_} = [split(//, $roman_digit{$_}, 2)], @figure);
}

sub Roman {
    my($arg) = shift;
    0 < $arg and $arg < 4000 or return undef;
    my($x, $roman);
    foreach (@figure) {
        my($digit, $i, $v) = (int($arg / $_), @{$roman_digit{$_}});
        if (1 <= $digit and $digit <= 3) {
            $roman .= $i x $digit;
        } elsif ($digit == 4) {
            $roman .= "$i$v";
        } elsif ($digit == 5) {
            $roman .= $v;
        } elsif (6 <= $digit and $digit <= 8) {
            $roman .= $v . $i x ($digit - 5);
        } elsif ($digit == 9) {
            $roman .= "$i$x";
        }
        $arg -= $digit * $_;
        $x = $i;
    }
    $roman;
}

sub roman {
    lc Roman shift;
}

1;
