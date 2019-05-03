use strict;
use warnings;

my $line;
my $string ="<DOC>";
my @array1;
my $countDoc=0;
my @arraykata;
my @bigram;
my @array;
#simpan seluruh korpus menjadi 1 korpus
open (NEWFILE, ">> korpusbaru.txt")or die ("Can't open file") ;
	open(A, "corpus_berita/korpusA.txt");
	while($line = <A>){
		print NEWFILE $line;
	}
	open(A, "corpus_berita/korpusB.txt");
	while($line = <A>){
		print NEWFILE $line;
	}
	open(A, "corpus_berita/korpusC.txt");
	while($line = <A>){
		print NEWFILE $line;
	}
	open(A, "corpus_berita/korpusD.txt");
	while($line = <A>){
		print NEWFILE $line;
	}
	close(NEWFILE);

open(NEWFILE, "korpusbaru.txt")or die ("Can't open file");

	while($line = <NEWFILE>){
		chomp $line;
		#calculate how many sentence which have bigram metro jaya
		if(index(lc $line, "metro jaya")!= -1){
			push @array1, $line;
		}
		#calculate how many doc with tag <DOC>
		if(index($line, $string)!= -1){
			$countDoc++;
		}

	}
	
close(NEWFILE);

my $banyak1 = @array1;
print "9. Banyak kata metro dan jaya: $banyak1 kalimat\n";

print "10. Banyak dokumen pada korpus: $countDoc dokumen\n";

#menghitung banyak kalimat
my $linekal;
my @arraykal;
open my $FILEHANDLE1, "korpusbaru.txt" 
     or die "Can't open file 'new.txt' for reading: $!";
     #chomp;
     while($linekal = <$FILEHANDLE1>){
     	chomp $linekal;
     	$linekal = lc $linekal;
     	#delete condition 2.000.000
     	$linekal =~ s/[0-9].[0-9]//g;
     	#$linekal =~ s/dr. //g;
     	#get only the sentence
     	push @arraykal, grep(!/[<>]/,(split/[.?!]+/,$linekal));
     }

close $FILEHANDLE1;
#delete empty value.
@arraykal = grep(/\S/,@arraykal);
my $countkalimat = @arraykal;
my $ratakalimat = $countkalimat/$countDoc;

print "11. Jumlah rata-rata kalimat adalah $ratakalimat kalimat\n";

#menghitung top 20 Collocations.
#counting the word from array

my $count;
#make bigram from sentence.
foreach my $i (0..@arraykal-1){
	#cut file corpus to a piece of word and store in array
	push @arraykata, grep(!/[^a-z]/,(split/\s+/, $arraykal[$i])) ;
	#cut file corpus/line sentence
	my @arraypecah = grep(!/[^a-z]/,(split/\s+/, $arraykal[$i]));
	#@arraypecah = grep(/\S/,@arraypecah);
	foreach my $j (0..@arraypecah-2){
		push @bigram, join (" ", $arraypecah[$j], $arraypecah[$j+1]);
	}
}
my $jlhtoken = @arraykata;
#count word from array
my %countkata;
$countkata{$_}++ foreach sort @arraykata;
#count bigram 
my %countbigram;
$countbigram{$_}++ foreach sort @bigram;

$count = 1;
my %PMI;
my @nilaiPMI;
my @bigramnya;
my $x;
my $y;
my @pecah;
#$pecah[2];
#count bigram to search frekuensi
foreach my $i (sort keys %countbigram){
	#print "$count\t$countbigram{$i}\t$i\n";
	@pecah = split /\s+/,$i;
#		print"$count $pecah[0]\t$pecah[1]\n";
	#search frekuensi a piece of bigram word in countkata hash
	$x = $countkata{$pecah[0]};
	$y = $countkata{$pecah[1]};
	my $xy = $countbigram{$i};
	my $pm = log(($xy*$jlhtoken)/($x*$y));
#		print "$count $pm = log(($xy*$jlhtoken)/($x*$y))\n";
	push @bigramnya, $i;
	push @nilaiPMI, $pm;
	
	$count++;
}
#get all of PMI Keys & Values
@PMI{@bigramnya}= @nilaiPMI;
$count=1;
foreach my $i (sort {$PMI{$b} <=> $PMI{$a}} keys %PMI){
	print "$count\t$PMI{$i}\t$i\n";
	if($count<30){
		$count++;	
	}else{
		last;
	}
}
print "DONE\n";