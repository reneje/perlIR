#!/usr/bin/perl -w

sub jaccard{
	my ($inp1, $inp2) = @_;
	my $result;
	my $check =0;
	my @array1;
	my @array2;
	
	if(length($inp1) < 6 && length($inp1) eq length($inp2)){
		@array1 = split (//,$inp1);
		@array2 = split (//,$inp2);

		foreach my $i (0..@array1-1){
			foreach my $j (0..@array2-1){
				if ($array1[$i] eq $array2[$j]){
					$check++;
					$array1[$i] ='0';
					$array2[$j] = '1';
				}
			}
		}
		#print ($check);

	}else{
		@array1 = makebigram($inp1);
		@array2 = makebigram($inp2);
		

		foreach my $i (0..@array1-1){
			foreach my $j (0..@array2-1){
				if ($array1[$i] eq $array2[$j]){
					$check++;
				}
			}
		}
	}
	
	my $arr1 = @array1;
	my $arr2 = @array2;
	
	$result = $check / ($arr1+$arr2-$check);
	#print"$inp2 -> $check / ($arr1+$arr2-$check) = $result\n";
	return $result;
}

sub makebigram{
	my ($inp) =@_;
	my @bigram;

	foreach my $i (0..length($inp)-1){
		$k = substr ($inp,$i,2);
		push @bigram, $k;
	}
	return @bigram;
}

1;