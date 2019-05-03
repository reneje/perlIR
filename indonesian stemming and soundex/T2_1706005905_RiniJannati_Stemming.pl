#this file is part of tugas 2 number 1 and 3
#this file is stemming file
#by Rini Jannati, 1706005905

sub stempart1{
	my ($inp) = @_;
	my @kataulang;
	if($inp =~ m/-/){
		@kataulang = split /-/,$inp;
		$inp = $kataulang[0];
	}else{
		$inp = $inp
	}
	return $inp;
}

sub cekimbuhan{
	my ($inp2) = @_;
	my @partikel = ("kah","lah","tah","pun","ku","mu","nya");
	#cek partikel.
	foreach my $i (0..@partikel-1){
		if(length($inp2)<7 && grep(/^[dmpbkst][ie]/,$inp2)&& grep(/$partikel[$i]$/,$inp2)){
				$inp2 = $inp2;
		}elsif( length($inp2)>5 && grep(/$partikel[$i]$/,$inp2)){
			my $l = length($partikel[$i]);
			$inp2 = substr($inp2,0,length($inp2)-$l);
			#print"$inp2\ttrue\n";
		}else{
			#print"$inp2\tfalse\n";
			$inp2 = $inp2;
		}
	}
	#cek prefiks dan sufiks
	#prefiks = me, pe, di, be, ke, te
	#sufiks = i, an, kan
	#aturan me, pe, di
	if( grep(/^di/,$inp2) ){
		if( grep(/kan$/,$inp2)){
			$inp2 = substr($inp2,0,length($inp2)-3);
			$inp2 = aturan3($inp2);
		}elsif( grep(/i$/,$inp2)){
			$inp2 = aturan3($inp2);
			$inp2 = aturani($inp2);
		}else{			
			$inp2 = aturan3($inp2);
			
		}
	}
	elsif( grep(/^me/,$inp2) ){
		if( grep(/kan$/,$inp2)){
			$inp2 = aturan($inp2);
			$inp2 = substr($inp2,0,length($inp2)-3);
		}elsif( grep(/i$/,$inp2)){
			$inp2 = aturan($inp2);
			$inp2 = aturani($inp2);
		}else{
			if(length($inp2)>5){
				$inp2 = aturan($inp2);
			}else{
				$inp2 = $inp2;
			}
		}
	}elsif( grep(/^pe/,$inp2) ){
		if( grep(/an$/,$inp2)){
			$inp2 = aturan($inp2);
			$inp2 = aturanan($inp2);
		}else{
			if(length($inp2)>5){
				$inp2 = aturan($inp2);
			}else{
				$inp2 = $inp2;
			}
		}
	}#aturan be  || 
	elsif( grep(/belajar/,$inp2)){ #hanya belajar yang memakai awalan bel
				$inp2 = substr ($inp2, 3);
	}
	elsif( grep(/^be[rt]/,$inp2) ){
		if (grep(/an$/,$inp2)) {
			$inp2 = aturan2($inp2);
			$inp2 = aturanan($inp2);
			#memeriksa bahwa an adalah kan
			if (grep(/[^aiueo]k$/,$inp2)) {
				$inp2 = substr($inp2,0,length($inp2)-1);
			}
		} else {
			$inp2 = aturan2($inp2);
		}
	}#aturan ke
	elsif(grep(/^ke/,$inp2)){
		if( grep(/i$/,$inp2)){
			$inp2 = substr($inp2,2);
			$inp2 = aturani($inp2);
		}elsif (grep(/an$/,$inp2)) {
			$inp2 = substr($inp2,2);
			$inp2 = aturanan($inp2);
		}
	}#aturan te
	elsif(grep(/^ter/,$inp2)){
		if(length($inp2)>6){
			$inp2 = substr($inp2,3);
		}else{
			$inp2 = $inp2;
		}
	}#aturan se
	elsif(grep(/^se/,$inp2)){
		if(length($inp2)>4){
			$inp2 = substr($inp2,2);
		}else{
			$inp2 = $inp2;
		}
	}
	else{
		if(length($inp2)>4){
			if( grep(/i$/,$inp2)){
				$inp2 = aturani($inp2);
			}elsif (grep(/an$/,$inp2)) {
				$inp2 = aturanan($inp2);
			#memeriksa bahwa an adalah kan
			if (grep(/[^aiueo]k$/,$inp2)) {
				$inp2 = substr($inp2,0,length($inp2)-1);
			}
			}
		}else{
			$inp2 = $inp2;
		}
	}
	return $inp2;
}
#cek per
sub ceksisipan{
	my ($inp3) = @_;
	my @sisipan = ("el","er","em","in","ah");
	my $inp2;
	foreach(@sisipan){
		if(grep(/^[^aiueo]$_[aiueo]/,$inp3)){
			$inp2 = substr ($inp3,3);
			substr($inp3,1) = $inp2;
		}
	}
	return $inp3;
}
#aturan me dan pe
sub aturan{
	my($inp) =@_;
	my $inp2;
	$inp = substr ($inp, 2);
	if(grep(/^[lnqrw][aiueo]/,$inp)){
 		$inp = $inp;
 	#print "true\n";
	}elsif(grep(/^m[bfv]/,$inp)){
		$inp = substr ($inp, 1);
	}elsif(grep(/^n[cdjt]/,$inp)){
		$inp = substr ($inp, 1);
	}elsif(grep(/^ng[g]/,$inp)){
		$inp = substr ($inp, 2);
	}elsif(grep(/^m[aiueo]/,$inp)){ #peluruhan  p
		$inp2 = substr($inp,1);
		$inp = "p";
		substr($inp,1)=$inp2;
	}elsif(grep(/^ng[aiueo]/,$inp)){ #peluruhan k
		$inp2 = substr($inp,2);
		$inp = "k";
		substr($inp,1)=$inp2;
	}elsif(grep(/^ng[^aiueo]/,$inp)){ #peluruhan k
		$inp2 = substr($inp,4);
	}elsif(grep(/^n[aiueo]/,$inp)){ #peluruhan t
		$inp2 = substr($inp,2);
		$inp = "t";
		substr($inp,1)=$inp2;
	}elsif(grep(/^ny[aiueo]/,$inp)){ #peluruhan s
		$inp2 = substr($inp,2);
		$inp = "s";
		substr($inp,1)=$inp2;
	}elsif(length($inp)>6){
		if(grep(/^mper/,$inp)){
			$inp = substr($inp,4);
		}elsif(grep(/^mber/,$inp)){
			$inp = substr($inp,4);
		}elsif(grep(/^mer[^aiueo]/,$inp)){
			$inp = substr($inp,3);
		}
	}
	else{
		$inp = $inp;
	}
	return $inp;
}
#aturan untuk be
sub aturan2{
	my($inp) = @_;
	#karena rata-rata kata yang memiliki awalan ber jika ditotalkan ukuran katanya lebih dari
	if(length($inp)>5){
		$inp = substr ($inp, 2);
		if(grep(/^r[^aiueo]/,$inp)){
			$inp = substr ($inp, 1);
			if(length($inp)>5){
				if(grep(/^ke[^aiueon]/,$inp)){
					if(grep(/^ke[m][^aiueo]/,$inp)){
						$inp = $inp;
					}else{
						$inp = substr ($inp, 2);
					}
					
				}elsif(grep(/^pen[^aiueog]/,$inp)){
					$inp = substr ($inp, 3);
				}elsif(grep(/^pen[aiueo]/,$inp)){
					my $inp2 = substr($inp,3);
					$inp = "t";
					substr($inp,1)=$inp2;
				}elsif(grep(/^peng/,$inp)){
					$inp = substr ($inp, 4);
				}
			}
		}elsif(grep(/^r[aiueo][brdl]/,$inp)){
			$inp = substr ($inp, 1);
		}elsif(length($inp)>=6 && grep(/^r[aiueo][^aiueo][^aiueo]/,$inp)){
			$inp = substr ($inp, 1);
		}		
			
	}
	else{
		$inp = $inp;
	}
	return $inp;
}
#aturan untuk di
sub aturan3{
	my ($inp) = @_;
	
	if(grep(/^didi/,$inp)){
		if(length($inp)>5){
			$inp = substr($inp,2);
		}
		else{
			$inp =$inp;
		}	
	}elsif(grep(/^din[^aiueoy]/,$inp)){ #tidak ada awalan di untuk huruf ng
		$inp = $inp;
	}
	else{
		if(length($inp)>4){
			$inp = substr($inp,2);
			if(length($inp)>5 && grep(/^ke[^aiueo][aiueo]/,$inp)){
				$inp = substr ($inp,2);
			}elsif(length($inp)>5 && grep(/^per/,$inp)){
				$inp = substr ($inp,3);
			}elsif(length($inp)>5 && grep(/^ber/,$inp)){
				$inp = substr ($inp,3);
			}
		}else{
			$inp = $inp;
		}	
	}
	
	return $inp;
}
#aturan i
sub aturani{
	my ($inp) =@_;

	if(length($inp)<5){
		$inp = $inp;
	}elsif(length($inp)%2 !=0 && grep(/^[^aiueo]/,$inp) && grep(/[aiueo][aiueo]i$/,$inp)){
		$inp = substr($inp,0,length($inp)-1);
	}elsif(length($inp) >5 && grep(/^[^aiueodm]/,$inp) && grep(/[aiueo][^aiueo]i$/,$inp)){
		$inp = substr($inp,0,length($inp)-1);
	}elsif((length($inp)>6 || length($inp)%2 ==1) && grep(/^[^aiueo]/,$inp) && grep(/[^aiueo][aiueo]i$/,$inp)){
		$inp = substr($inp,0,length($inp)-1);
	}elsif(length($inp)%4==0 && grep(/^[^aiueo]/,$inp) && grep(/[^aiueog]i$/,$inp)){
		$inp = $inp;
	}elsif(length($inp)>5 && grep(/^[aiueo]/,$inp) && grep(/[s]i$/,$inp)){ #asosiasi dll
		$inp = $inp;
	}elsif(length($inp)>5 &&  grep(/[s]i$/,$inp)){
		$inp = $inp;
	}elsif(grep(/[^aiueo][^aiueog]i$/,$inp)){
		$inp = $inp;
	}elsif((length($inp)<6 || length($inp)%2 ==0) && grep(/^[^aiueo]/,$inp) && grep(/[^aiueo][aiueo]i$/,$inp)){
		$inp = $inp;
	}else{
		$inp = substr($inp,0,length($inp)-1);
	}
	return $inp;
}
sub aturanan{
	my ($inp) =@_;

	if(length($inp)>5 && grep(/^[^aiueo]/,$inp)){
		$inp = substr($inp,0,length($inp)-2);
		
	}elsif(length($inp)>=5 && grep(/^[aiueo]/,$inp)){
		$inp = substr($inp,0,length($inp)-2);
		
	}
	return $inp;
}
1;