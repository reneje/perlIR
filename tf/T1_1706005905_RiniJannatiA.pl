#!/usr/bin/perl -w
# NPM: 1706005905
# Nama: Rini Jannati
# Jawaban Tugas A
use strict;

#open file
my $filename = "wikipedia.txt";
my @array;
my $line;
my $count;
my $string = "jakarta";
my @arraykalimat;
my @arraysome;
my @joinarray;

open(DATA, $filename) or die ("Can't open file");
#save data to array, open data and insert into scalar
while ($line = <DATA>){
	$line = lc $line;
	#cut value from scalar into a piece of word, delete no alphabet, normalisation to lowercase and insert into array
	$line =~ s/[-:]/ /g;
	push @array, grep (!/[^a-z]/,(split/\s+/,$line));
	#insert sentence who has $string word into array.
	if(index ($line, $string)!= -1){
		push @arraykalimat, $line;
		#make some bigrams
		@arraysome = (split/\s+/, $line);
		my $word = @arraysome;
		for(my $i=0; $i<$word;$i++){
			if($i==0){
    			push @joinarray, join(" ","<start>",$arraysome[$i]);
  			}else{
   				if($i==$word-1){
   					push @joinarray, join(" ",$arraysome[$i],"<end>");
   			 	}else{
    				push @joinarray, join(" ",$arraysome[$i-1],$arraysome[$i]);
    			}
  			}
		}
	}
}
close (DATA);

#counting the word from array
my %countkata;
$countkata{$_}++ foreach sort @array;

open (FILE, '>>jawabanAA.txt');
#counting how many distinct words
my $distinct = keys %countkata;
print FILE "1. jumlah distinct word = $distinct\n";
print "1. jumlah distinct word = $distinct\n";

my @result;
#sort frekuensi from high to low
open (MYFILE, '>>distinctword.csv');
print FILE "2. hasil keseluruhan: \n";
print "2. hasil keseluruhan: \n<ranking>\t<frekuensi>\t<kata>\n";
print MYFILE"<ranking>,<frekuensi>,<kata>\n";

$count = 1;
foreach my $i (sort {$countkata{$b} <=> $countkata{$a}} keys %countkata){
	print MYFILE "$count,$countkata{$i},$i\n";
	print FILE "$count\t$countkata{$i}\t$i\n";
	print "$count\t$countkata{$i}\t$i\n";
	$result[$count-1][0]=$countkata{$i};
	$result[$count-1][1]=$i;
	
	$count++;
}
close(MYFILE);
#sort top 30
print FILE "3. Top 30 Kata sering muncul: \n";
print "3. Top 30 Kata sering muncul: \n<ranking>\t<frekuensi>\t<kata>\n";
$count = 1;
foreach my $i (sort {$countkata{$b} <=> $countkata{$a}} keys %countkata){
	print FILE "$count\t$countkata{$i}\t$i\n";
	print "$count\t$countkata{$i}\t$i\n";
	if($count<30){
		$count++;	
	}else{
		last;
	}	
}

#print less word in the text
print FILE "4. 20 Kata jarang muncul: \n";
print "4. 20 Kata sering muncul: \n<ranking>\t<frekuensi>\t<kata>\n";
$count = 1;
foreach my $i (sort {$countkata{$a} <=> $countkata{$b}} keys %countkata){
	print FILE "$count\t$countkata{$i}\t$i\n";
	print "$count\t$countkata{$i}\t$i\n";
	if($count<20){
		$count++;	
	}else{
		last;
	}	
}

#hukum zipf's law frekuensi = konstanta/ranking,
#ambil angka tengah
my $angka = 1000;
my $konstanta = $result[$angka][0] * $angka;
#ambil sembarang ranking:
my $angka2 = 500;
my $frekuensi = $konstanta / $angka2;
print FILE "5. Bukti hukum zipf's law berlaku:\nJika kata $result[$angka][1] 
muncul sebanyak $result[$angka][0] kali pada peringkat $angka, 
maka kata $result[$angka2][1] pada peringkat $angka2 yaitu lebih kurang $frekuensi (kenyataannya 
muncul sebanyak $result[$angka2][0]) kali\n";
print "5. Bukti hukum zipf's law berlaku:\nJika kata $result[$angka][1] 
muncul sebanyak $result[$angka][0] kali pada peringkat $angka, 
maka kata $result[$angka2][1] pada peringkat $angka2 yaitu lebih kurang $frekuensi (kenyataannya 
muncul sebanyak $result[$angka2][0]) kali\n";

#print how many sentence which is contained the string
my $sentence = @arraykalimat;
print FILE "7. Banyak kalimat yang mengandung kata $string= $sentence\n";
print "7. Banyak kalimat yang mengandung kata $string= $sentence\n";

#count bigram every sentence
print FILE "8. Top 40 kata bigram dari kalimat yang mengandung $string: \n";
print "8. Top 40 kata bigram dari kalimat yang mengandung $string: \n";
print "<ranking>\t<frekuensi>\t<kata>\n";
my %countbigram;
$countbigram{$_}++ foreach sort @joinarray;
$count=1;
foreach my $i (sort {$countbigram{$b} <=> $countbigram{$a}} keys %countbigram){
  print FILE "$count\t$countbigram{$i}\t$i\n";
  print "$count\t$countbigram{$i}\t$i\n";
  if($count<40){
    $count++; 
  }else{
    last;
  }
  
}

close(FILE);
print"DONE\n";
