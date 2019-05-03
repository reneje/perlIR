#!/usr/bin/perl -w
#Rini Jannati
#1706005905
#Program ini berisikan program untuk menghitung TF, TFIDF, Cossine Similarity dan Unigram Mixture Model.

use warnings;
use strict;
require "T2_1706005905_RiniJannati_Stemming.pl";
require "T2_1706005905_RiniJannati_Soundex.pl";
require "T3_1706005905_RiniJannati_Jaccard.pl";


my $lines; #scalar untuk membaca perbaris
my %document;
my $number;
my @word;
my @doc;
my %docoffile; # %docoffile struktur pada hashnya = Kata, Dokumen_yang_mengandung_kata_tsb, Jumlah_kata_di_dokumen
my %IDFofWord; #nilai idf dari sebuah term(term,log(N/dft))
my %IDFofDoc;
my %count_collection; #struktur hashnya-> kata, Jumlah_kata_di_koleksi
my %TF_kuadrat;
my %TFIDF_kuadrat;
my $TerminCollection;
my %TerminDocument;
my %countkata;
my %query; #id_query,kata-kata_diquery_distemming,jumlah_kata_pada_query
my %IDFofQuery;
my %sigma;
my %sigmaIDF;
my %sim;
my %simIDF;
my %unigram;
my %relevanJ;

my $dokumen_Koleksi = "koleksi.txt";
my $query_dokumen = "query.txt";
my $relavance_judgment = "relevant_judgment.txt";

#ambil koleksi kata dari koleksi dokumen:
open (NEWFILE,$dokumen_Koleksi) or die ("Can't open the file");
while($lines = <NEWFILE>){
	chomp($lines);
	#Mengambil nilai nomor dokumen pada koleksi
	if(grep(/<NO>/,$lines)){
		$lines =~ s/<NO>//;
		$lines =~ s/<\/NO>//;
		$lines =~ s/\s//;
		$number = $lines;
		push @doc, $number;
	}else{
		#mengambil nilai teks dan judul pada koleksi
		if(grep(/<JUDUL>/,$lines) || (grep(!/<TEKS>/,$lines) && grep(!/<\/TEKS>/,$lines) && grep(!/<\/DOK>/,$lines)&& grep(!/<DOK>/,$lines))){
			$lines =~ s/<JUDUL>//;
			$lines =~ s/<\/JUDUL>//;
			$lines =~ tr/[A-Z]/[a-z]/;
			$lines =~ tr/-!?@#$%^&*()~`[]{}:;""'',”<>,._+=\|/ /;
			my @key = split " ", $lines;
			@key = grep (!/[^a-z0-9]/,@key);
			#my @angka = grep (/[0-9]/,@key);
			foreach(@key){
			#$_ = stempart1($_);
				if(length($_)>4){
					$_ = cekimbuhan($_);
					$_ = ceksisipan($_);
				}
				#hitung katanya per kata dalam 1 dokumen
				$document{$_}{$number}++;

			}
			push @word, @key;
			
		}
	}
}
close(NEWFILE);

#jumlah kata dalam koleksi:
$countkata{$_}++ foreach(@word);

#menghitung banyak kata pada koleksi
foreach my $w (sort keys %countkata){
	#print"$w\t$countkata{$w}\n";
	$TerminCollection += $countkata{$w};
}

#mencari TF
open(FILE1, "> hasilTF.csv") or die ("can't open file");
open(FILE2, "> Term.txt") or die ("can't open file");
open(FILE3, "> hasilTFKuadrat.csv") or die ("can't open file");
open(FILE4,"> IDF.txt") or die ("can't open file");


print FILE1 "Term,";
foreach my $d (sort @doc){
	print FILE1"$d,";
	print FILE3"$d,";
}

my $NDoc = @doc;
my %totalKuadrat;
$totalKuadrat{$_} = 0 foreach(@doc);
#TF-IDF kata
my %totalKuadratIDF;
$totalKuadratIDF{$_} = 0 foreach(@doc);

foreach my $w (sort keys %countkata){
	print FILE1"$w,";
	print FILE2 "$w dalam seluruh dokumen dengan total kata: ";
	print FILE3"$w,";
	print FILE4"$w ";

	#mencari IDF
	my $nDTF = keys %{$document{$w}};
	#IDF per kata
	$IDFofWord{$w} = log($NDoc/$nDTF);
	print FILE4"$IDFofWord{$w} \n";
	
	#normalisasi dokumen
	foreach my $d (@doc){
		if($document{$w}{$d}){
			$docoffile{$w}{$d} = $document{$w}{$d};
			

		}else{
			$docoffile{$w}{$d}=0;
			
		}
		$TerminDocument{$d} += $docoffile{$w}{$d};
		$TF_kuadrat{$w}{$d} = $docoffile{$w}{$d} ** 2;
		$totalKuadrat{$d} += $TF_kuadrat{$w}{$d};

		$IDFofDoc{$w}{$d} = $docoffile{$w}{$d} * $IDFofWord{$w};
		$TFIDF_kuadrat{$w}{$d} = $IDFofDoc{$w}{$d} ** 2;
		$totalKuadratIDF{$d} += $TFIDF_kuadrat{$w}{$d};
		print FILE1"$docoffile{$w}{$d},";
		print FILE3"$TF_kuadrat{$w}{$d},";
		
	}
	print FILE1"\n";
	print FILE2"$countkata{$w}\n";
	print FILE3"\n";
	
}
close (FILE1);
close (FILE2);
close (FILE3);
close (FILE4);

open(FILE5, "> totalkuadratdoc.txt") or die ("can't open file");
open(FILE3, "> TermIDFkuadrat.txt") or die ("can't open file");

foreach my $d (sort @doc){
	print FILE5"total kata di doc: $TerminDocument{$d} $d\t$totalKuadrat{$d}\t";
	print FILE3"otal kata di doc: $TerminDocument{$d} $d\t$totalKuadratIDF{$d}\t";
	
	#panjang vektor per document
	$totalKuadrat{$d} = sqrt($totalKuadrat{$d});
	$totalKuadratIDF{$d} = sqrt($totalKuadratIDF{$d});
	
	print FILE5"$totalKuadrat{$d}\n";
	print FILE3"$totalKuadratIDF{$d}\n";

}

close (FILE5);
close(FILE3);

#Print hasil TF dan TFIDF
open(FILE1, "> hasilTFIDF.csv") or die ("can't open file");
open(FILE2, "> hasilTFKuadrat.csv") or die ("can't open file");

foreach my $d (sort @doc){
	print FILE1"$d,";
	print FILE2"$d,";
}
foreach my $w (sort keys %docoffile){
	print FILE1"$w,";
	print FILE2"$w,";
	foreach my $d(sort keys %{$docoffile{$w}}){
		print FILE1"$IDFofDoc{$w}{$d},";
		print FILE2"$TFIDF_kuadrat{$w}{$d},";
	}
	print FILE1"\n";
	print FILE2"\n";
	
}
close(FILE1);
close(FILE2);

#membuat soundex:
open(File,">soundex.csv") or die ("can't make a file");
print File "Term,Soundex\n";
my %soundexkata;
foreach my $i (sort keys %countkata){
	if(grep/[a-z]/,$i){
		my $sound = soundex($i);
		$soundexkata{$i} = $sound;
		print File "$i,$sound\n";
	}
	
} 

#Query nilainya:
open(FILE,$query_dokumen) or die ("Can't open the file");
while($lines = <FILE>){
	my @array = split/\t/,$lines;
	$array[1] =~ tr/-!?@#$%^&*()~`[]{}:;""'',”<>,._+=\|/ /;
	$array[1] =~ tr/[A-Z]/[a-z]/;
	my @wordarray = split " ",$array[1];

	foreach(@wordarray){
		#$_ = stempart1($_);
		if(length($_)>4){
			$_ = cekimbuhan($_);
			$_ = ceksisipan($_);
		}
		$query{$array[0]}{$_}++;
		#print($_);
	}
	$sigma{$array[0]}{$_} = 0 foreach(@doc);
	$sigmaIDF{$array[0]}{$_} = 0 foreach(@doc);
}

close(File);

#correction Query
open(FILE,"> QUERY PROSES.txt") or die ("Can't make a file");

my %totalquery;
foreach my $q(sort keys %query){
	foreach my $w(sort keys %{$query{$q}}){
		#HITUNG BAGIAN QUERY
		#correction issue
		if(!$countkata{$w}){
			my %jcc;
			my @array;
			
			#cari soundex yang sama
			my $soundquery = soundex($w);
			foreach my $i (sort keys %soundexkata){
				if($soundquery eq $soundexkata{$i}){
					
					#mencari susunan kata yang sama
					$jcc{$i} = jaccard($w,$i);
				}
			}
			
			#ambil nilai skor jaccard dengan mengurutkan dari nilai terbesar
			 @array = sort {$jcc{$b} <=> $jcc{$a}} keys %jcc;
			my $y = 0;
			foreach my $x (0..@array-1){
				$y = $array[0];
			}
			
			# #hapus kata yang dikoreksi.
			delete $query{$q}{$w};
			
			#ambil nilai terbesar
			$query{$q}{$y}++;
		}
	}
	
}

#QUERY
my %totalqueryIDF;
foreach my $q(sort keys %query){
	foreach my $w(sort keys %{$query{$q}}){
		#QUERY
		print FILE "$q\t$w\t$query{$q}{$w}\n";
		$totalquery{$q} += $query{$q}{$w} ** 2;
		#IDF QUERY
		$IDFofQuery{$q}{$w} = $query{$q}{$w} * $IDFofWord{$w};
		$totalqueryIDF{$q} += $IDFofQuery{$q}{$w} ** 2;
		print FILE "IDF $q\t$w\t$IDFofQuery{$q}{$w}\n"
	}
	print FILE "$totalquery{$q} ";
	$totalquery{$q} = sqrt ($totalquery{$q});
	print FILE "$totalquery{$q}\n";

	print FILE "$totalqueryIDF{$q} ";
	$totalqueryIDF{$q} = sqrt ($totalqueryIDF{$q});
	print FILE "$totalqueryIDF{$q}\n";
}

close(FILE);

my %cobahasil;
#perkalian cossine similarity
open(File,"> querysimilarity.txt") or die ("can't open file");
foreach my $q(sort keys %query){
	print File "$q\n";
	foreach my $d(sort @doc){
		print File "$d\n";
		#mencari total perkalian query dan document
		foreach my $w(sort keys %{$query{$q}}){
		#sigma Q(w) * D(w)
			my $x = $query{$q}{$w} * $docoffile{$w}{$d};
			$sigma{$q}{$d} += $query{$q}{$w} * $docoffile{$w}{$d};
			print File "TF $x = $query{$q}{$w} * $docoffile{$w}{$d}\n";
			my $y = $IDFofQuery{$q}{$w} * $IDFofDoc{$w}{$d};
			$sigmaIDF{$q}{$d} += $IDFofQuery{$q}{$w} * $IDFofDoc{$w}{$d};
			print File "IDF $y = $IDFofQuery{$q}{$w} * $IDFofDoc{$w}{$d}\n";
		}
		print File "TF: $sigma{$q}{$d}\t";
		print File "TFIDF: $sigmaIDF{$q}{$d}\n";
		
		#count all: dengan kondisi kata pada dokumen tidak 0

		if($TerminDocument{$d} != 0){
			$sim{$q}{$d} = $sigma{$q}{$d}/($totalquery{$q} * $totalKuadrat{$d});
			print File "$sim{$q}{$d} = $sigma{$q}{$d}/($totalquery{$q} * $totalKuadrat{$d})\n";
			$simIDF{$q}{$d} = $sigmaIDF{$q}{$d}/($totalqueryIDF{$q} * $totalKuadratIDF{$d});
			print File "$simIDF{$q}{$d} = $sigmaIDF{$q}{$d}/($totalqueryIDF{$q} * $totalKuadratIDF{$d})\n\n";

			#unigram language model dengan mixture model
			for(my $lmd=0.3; $lmd<0.9; $lmd+=0.1){
				my $equal =1;
				foreach my $w(sort keys %{$query{$q}}){
					my $probabil = mixturemodel($lmd, $docoffile{$w}{$d},$TerminDocument{$d}, $countkata{$w},$TerminCollection);
					$equal *= $probabil;
				}
				$unigram{$lmd}{$q}{$d} = $equal;
			}

			#hanya menggunakan probabilitas
			my $temp =1;
			foreach my $w(sort keys %{$query{$q}}){
				my $peluang = ($IDFofDoc{$w}{$d})/$TerminDocument{$d};
				$temp += $peluang;
			}
			$cobahasil{$q}{$d} = $temp;

		}
	}
	print File"\n";
}

close(File);

#Relevansi Judgment
open (NEWFILE,$relavance_judgment) or die ("Can't open the file");

while($lines = <NEWFILE>){
	my @array = split /\s+/, $lines;
	$relevanJ{$array[0]}{$array[1]} = $array[2];
}
close(NEWFILE);


open(FILE,"> Mean Average Precision.txt") or die ("can't open file");

relevanceJudgment("sim.csv","hasil relevans.csv",%sim);
relevanceJudgment("simTF.csv","hasil relevans IDF.csv",%simIDF);
relevanceJudgment("probabilitas.csv","hasil relevans eksperiment.csv",%cobahasil);

open (FILE2, "> unigram precision.csv") or die ("can't open file");
open (FILE3, "> unigram.csv") or die ("can't open file");

print FILE3 "Lamda,Query,Rank,Document,Score\n";

print FILE2 "Lamda, Query,Precision, Recall, Average Precision, Document Retrieved, Document Relevant\n";

foreach my $lmd (sort keys %unigram){
	my %preR;
	my $averageP;
	my $n = keys %query;
	foreach my $q (sort keys %{$unigram{$lmd}}){
		my $count1 =1;
		my $relevanD= keys %{$relevanJ{$q}};
		my $retrieved=0;
		my $nrelevant=0;
		my $relevant =0;
		my $getdoc;
		my $precision;
		my $recall;
		my $p;
		foreach my $d (sort {$unigram{$lmd}{$q}{$b} <=> $unigram{$lmd}{$q}{$a}} keys %{$unigram{$lmd}{$q}}){
			if($count1 <= 50){
				print FILE3"$lmd, $q, $count1, $d, $unigram{$lmd}{$q}{$d}\n";
				$retrieved++;

				if($relevanJ{$q}{$d}){
					$relevant++;
					$getdoc = $d;
					$precision = $relevant/($relevant+$nrelevant);
					$recall = $relevant/($relevanD);
					#print "$q\t$d\t$getdoc\t$precision\t$recall\n";
					$preR{$q} += $precision;
				}else{
					$nrelevant++;
				}
				
			}else{
				last;
			}
			
			$count1++;
		}
		$preR{$q} = $preR{$q} / $relevant;
		#print "precision average $preR{$q} dokumen relevan: $relevant\n\n";
		$averageP += $preR{$q};
		$p = $relevant/$retrieved;
		print"Precision: $p\nRecall: $recall\nAverage Precision: $preR{$q}\n";
		print FILE2 "$lmd,$q,$p,$recall,$preR{$q},$relevant,$relevanD\n";
	
	}

	$averageP= $averageP/$n *100;
	print"Mean Average precision unigram model pada lamda $lmd = $averageP %\n\n";
	print FILE "Mean Average precision unigram model pada lamda $lmd = $averageP %\n\n";

}

close(FILE3);
close(FILE);
close(FILE2);

sub relevanceJudgment{
	my($namefile,$namafile2,%hash) = @_;
	open (FILE1, ">",$namefile) or die ("can't open file");
	open (FILE2, ">",$namafile2) or die ("can't open file");
	
	my %Pr;
	my $nquery = keys %query;
	my $average;
	print FILE1"Query,Rank,Document,Score\n";
	print FILE2 "Query,Precision, Recall, Average Precision, Document Retrieved, Document Relevant\n";
	
	foreach my $q (sort keys %hash){
		my $count1 =1;
		my $relevanD= keys %{$relevanJ{$q}};
		my $retrieved=0;
		my $nrelevant=0;
		my $relevant =0;
		my $getdoc;
		my $precision;
		my $recall;
		my $pp;
		foreach my $d(sort {$hash{$q}{$b} <=> $hash{$q}{$a}} keys %{$hash{$q}}){
			if($count1 <= 50){
				print FILE1 "$q,$count1,$d,$sim{$q}{$d}\n";
				$retrieved++;
				if($relevanJ{$q}{$d}){
					$relevant++;
					$getdoc = $d;
					$precision = $relevant/($relevant+$nrelevant);
					$recall= $relevant/($relevanD);
					#print "$q\t$d\t$getdoc\t$precision\t$recall\n";
					$Pr{$q} += $precision;
				
				}else{
					$nrelevant++;
				}
			
			}
		
			$count1++;
		}
		$Pr{$q} = $Pr{$q}/$relevant;
		$pp = $relevant/$retrieved;
		print "Precision: $pp\n Recall: $recall\n";
		print "Precision average: $Pr{$q} dokumen relevan: $relevant\n\n";
		print FILE2 "$q,$pp,$recall,$Pr{$q},$relevant,$relevanD\n";
		$average += $Pr{$q};

	}

	$average = ($average/$nquery)*100;
	print"Mean Average precision = $average %\n\n";
	print FILE "Mean Average precision cossine similarity pada = $average %\n\n";
	close(FILE1);
	close(FILE2);
}

#unigram language dengan mixture model
sub mixturemodel{
	my ($lamda, $TFword, $LD, $CFword, $TD) = @_;
	my $prob;
	#print"$TD\n";
	$prob = ($lamda * ($TFword/$LD)) + ((1-$lamda)*($CFword/$TD));

	return $prob;
}
