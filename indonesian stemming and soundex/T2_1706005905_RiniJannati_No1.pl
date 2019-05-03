#main program dari soal no 1 mengenai stemming
# by Rini Jannati, 1706005905

#!/usr/bin/perl w-

use warnings;
use strict;

my $line;
my @array;
my %data;
my @datastem;
my %hasil;
my @hasilstem;

require "T2_1706005905_RiniJannati_Stemming.pl";

open (NEWFILE, "dataset-tugas-2/gold_standard_stemming_part.txt") or die ("can't open the file");
while ($line = <NEWFILE>) {
	chomp($line);
	@array = split' ',$line;
	chomp (@array);
	$data{$array[0]} = $array[2];
	push @datastem, $array[0];
}

close(NEWFILE);

#file distemming per index
foreach my $i (0..@datastem-1){
	$hasilstem[$i] = stempart1($datastem[$i]);
	$hasilstem[$i] = cekimbuhan($hasilstem[$i]);
	$hasilstem[$i] = ceksisipan($hasilstem[$i]);
	$hasil{$datastem[$i]} = $hasilstem[$i];
}
my %katasalah;
my $count = 0;
my $length = @datastem;
open(FILE, "> hasil-stemming.csv") or die ("Can't Open File");
print FILE "Kata Berimbuhan, Kata Dasar, Hasil Stemming\n";
foreach my $i (sort keys %data){
	if($data{$i} eq $hasil{$i}){
		$count++;
	}else{
		$katasalah{$i} = $hasil{$i};
	}
	print "$i\t $data{$i}\t $hasil{$i}\n";
	print FILE "$i, $data{$i}, $hasil{$i}\n";
}
close(FILE);
my $total = @datastem;
my $akurasi = ($count/$total) * 100;
print "akurasi = $akurasi %\n";
foreach my $i (sort keys %katasalah){
	
	print "$i\t $katasalah{$i}\n";
}