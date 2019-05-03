#T2_1706005905_RiniJannati_No3.pl
#pada program ini menjawab soal no 3.

#!/usr/bin/perl -w
use warnings;
use strict;
require "T2_1706005905_RiniJannati_Stemming.pl";

my @array;

open (NEWFILE, "dataset-tugas-2/korpusD.txt") or die ("can't open the file");
@array = <NEWFILE>;
close(NEWFILE);
#menggabungkan korpus dalam 1 scalar
my $line = lc join " ",@array;
$line =~ s/[!.,?'"]/ /g;

#menoken seluruh kata
my @word = split /\s+/,$line;
@word = grep (!/[^a-z]/,@word);
@word = grep(/\S/,@word);
foreach my $i (0..@word-1){
	$word[$i] = stempart1($word[$i]);
	if(length($word[$i])>4){
		$word[$i] = cekimbuhan($word[$i]);
		$word[$i] = ceksisipan($word[$i]);
	}
	
}
@word = uniq(@word);
#memisahkan dokumen
my @dokumen = split "</doc>",$line;
#pop @dokumen;
my @tokendokumen;
my @index;

@word = sort @word;
@word = grep(/\S/,@word);

foreach my $i (0..@word-1){
	$index[$i][0] = $word[$i];
}
for(my $i=0; $i<@word; $i++){
	for(my $j=1; $j<=@dokumen; $j++){
		$index[$i][$j]=0;
	}
}
#mengindexkan dokumen
foreach my $x (1..@dokumen) {
	@tokendokumen = grep (!/[^a-z]/,(split/\s+/,$dokumen[$x-1]));
	@tokendokumen = grep (/\S/,@tokendokumen);
	foreach my $i (0..@tokendokumen-1){
		$tokendokumen[$i] = stempart1($tokendokumen[$i]);
		if(length($tokendokumen[$i])>4){
			$tokendokumen[$i] = cekimbuhan($tokendokumen[$i]);
			$tokendokumen[$i] = ceksisipan($tokendokumen[$i]);
		}
	}
	@tokendokumen = sort @tokendokumen;
	foreach my $i (0..@tokendokumen-1){
		for my $j(0..@word-1){
			if($index[$j][0] eq $tokendokumen[$i]){
				$index[$j][$x]++;
			}
		}
	}
	print"proses dokumen ke $x\n";
}
#simpan inde dokumen
open(FILE, '>hasil-index.csv') or die'cannot find the file';

print FILE"Token,";
for(my $i=1; $i<=@dokumen; $i++){
	print FILE"DOC$i,";
}
print FILE"\n";
for(my $i=0; $i< @word; $i++){
	print FILE "$index[$i][0], ";
	for(my $j=1; $j<=@dokumen; $j++){
		print FILE"$index[$i][$j],";
	}
	print FILE"\n";
}

close(FILE);

#menghasilkan list pertoken ada didokumen berapa
open(TFILE, '>list-index.txt') or die'cannot find the file';

print TFILE"Dictionary\tPosting Lists\n";
for(my $i=0; $i<@word; $i++){
	print TFILE "$index[$i][0]\t\t";
	for(my $j=1; $j<=@dokumen; $j++){
		if($index[$i][$j] ne "0"){
			print TFILE "$j|";
		}
		
	}
	print TFILE"\n";
}

close(TFILE);
#soal Boolean retrival
print "Pencarian QUERY\n";
print "Anda dapat mencari dokumen dengan 2 kata sebagai kata kunci\n";
print "Gunakan penghubung antara 2 kata tersebut dengan AND atau OR\n";
print "contoh:\n1. Kata1 AND kata2\n2. Kata1 OR Kata2\n";
print "Silahkan masukkan QUERY: ";
my $input = <STDIN>;
chomp($input);
$input = lc $input;
my @arrayinput = split /\s+/,$input;
foreach(@arrayinput){
	$_ = stempart1($_);
	$_ = cekimbuhan($_);
	$_ = ceksisipan($_);
}
my @ind1 = cekada($arrayinput[0]);;
my @ind2 = cekada($arrayinput[2]);;
my $m = @ind1;
my $n = @ind2;
my @ind;

#memberikan hasil dimana dokumen yang ada kata tsb.
if($arrayinput[1] eq 'and'){
	if($m ne 0 && $n ne 0){
		#mengecek dokumen yang sama
		foreach my $i (0..@ind1-1){
			foreach my $j (0..@ind2-1){
				if($ind1[$i] eq $ind2[$j]){
					push @ind, $ind1[$i];
				}
			}
		}
		printkan();
	}else{
		print "tidak ada yang mengandung kedua query!\n";
	}

}elsif ($arrayinput[1] eq 'or'){
	if($m ne 0 || $n ne 0){
		push @ind, @ind1;
		push @ind,@ind2;
		printkan();
	}else{
		print "tidak ada yang mengandung kedua query!\n";
	}
}else{
	print "anda salah memasukkan perintah!\n";
}

print "\n";

sub printkan{
	print"Query $arrayinput[0] $arrayinput[1] $arrayinput[2] ada pada dokumen ke: ";
	@ind = uniq(@ind);
	@ind = sort @ind;
	foreach(@ind){
		print "$_|";
	}
}
sub cekada{
	my ($input) =@_;
	my @indoc;

	for(my $i=0; $i<@word; $i++){
		if($input eq $index[$i][0]){
			for(my $j=1; $j<=@dokumen; $j++){
				if($index[$i][$j] ne "0"){
					push @indoc, $j;
				}
		
			}		
		}
	}
	@indoc = sort @indoc;
	return @indoc;
}

sub uniq {
    my %seen;
    grep !$seen{$_}++, @_;
}