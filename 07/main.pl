#! /usr/bin/perl
use Data::Dumper;

if (scalar @ARGV != 2) {
	print Dumper(@ARGV);
	die "incorrect number of arguments"
}

if (@ARGV[0] eq "part01") {
	calc(\&diff_simple);
} elsif (@ARGV[0] eq "part02") {
	calc(\&diff_sum);
} else {
	print "invalid part specified"
}

sub diff_simple {
	return abs(@_[0] - @_[1]);
}

sub diff_sum {
	my $v = abs(@_[0] - @_[1]);
	return ($v + 1) * $v / 2;
}

sub calc {
	my ( $diff ) = @_;
	open(FH, '<', @ARGV[1]) or die $!;
	my @crabs = split /,/, <FH>;
	my $max_crab = 0;

	foreach $num (@crabs) {
		$max_crab = $num if $num > $max_crab;
	}

	my $best_pos = -1;
	my $best_pos_value;
	for ($i = 0; $i <= $max_crab; $i++) {
		my $val = 0;
		foreach $num (@crabs) {
			$val = $val + $diff->($num, $i);
		}

		if ($best_pos == -1) {
			$best_pos = 0;
			$best_pos_value = $val;
		} elsif ($val < $best_pos_value) {
			$best_pos = $i;
			$best_pos_value = $val;
		}
	}

	print "$best_pos: $best_pos_value\n";

}
