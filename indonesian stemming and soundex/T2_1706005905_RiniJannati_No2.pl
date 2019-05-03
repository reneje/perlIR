# Tugas 2
# 1706005905 Rini Jannati
# Soundex Algorithm
# Contoh: soundex(bang) = soundex(bank) = B520

#!/usr/bin/perl -w

use warnings;
use strict;

require "T2_1706005905_RiniJannati_Soundex.pl";


	print "Inputkan sebuah kata: ";
	my $inp = <STDIN>;
	chomp $inp;

	$inp = soundex ($inp);

	print"Soundex: $inp\n";


