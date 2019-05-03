use warnings;
use strict;

require "T2_1706005905_RiniJannati_Stemming.pl";

open (FILE, 'hasil-index.csv') or die("can't open the file");
my $lines;
my @index;
my $count = 0;
my $doc;
while($lines = <FILE>){
	my @array = split (",",$lines);
	$doc = @array;
	foreach my $x (0..@array-1) {
		$index[$count][$x]=$array[$x];
	}
	$count++;
}

my $x = @index;
my $y = @{$index[0]};
print "$x. and $y";
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
	shift(@ind);
	@ind = sort @ind;
	foreach(@ind){
		print "$_|";
	}
}
sub cekada{
	my ($input) =@_;
	my @indoc;

	for(my $i=1; $i<@index-1; $i++){
		if($input eq $index[$i][0]){
			for(my $j=1; $j<@{$index[0]}-1; $j++){
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