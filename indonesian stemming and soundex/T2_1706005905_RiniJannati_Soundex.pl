#!/usr/bin/perl -w
#this file is sub of soundex
#part file tugas 2 soal number 2
# by Rini Jannati, 1706005905

sub soundex{
	my ($inp) = @_;
	#normalisasi text
	$inp = uc $inp;
	#mengubah huruf selain huruf pertama menjadi angka
	my $str = substr($inp,1);	
	$str =~tr/[AEIOUHWY]/0/;
	$str =~tr/[BFPV]/1/;
	$str =~tr/[CGJKQSXZ]/2/;
	$str =~tr/[DT]/3/;
	$str =~tr/[L]/4/;
	$str =~tr/[MN]/5/;
	$str =~tr/[R]/6/;

	#menggabungkan huruf pertama dan huruf-huruf yang sudah diganti jadi angka
	substr($inp, 1) = $str; 

	#menghapus angka yang berurutan, tetapi saya mengubahnya menjadi 0
	foreach my $i (1.. length($inp)-2){
		if((substr $inp, $i,1) eq (substr $inp, $i+1, 1)){
			substr ($inp, $i,1) = "0";
		}
	}

	#menghapus semua angka 0 dari string
	$inp =~ s/[0]//g;

	#mengisi string menjadi 0 (jadi jika panjang string kurang dari 4 akan diberikan nilai 0)
	my $l = length($inp);
	substr ($inp, $l) = "0000";

	#hasilnya yang menjadi 4 karakter
	$inp = substr $inp,0,4;

	return $inp;
}

1;