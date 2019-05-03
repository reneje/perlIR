use strict;
use warnings;

#use CGI ':standard';
use GD::Graph::lines;
use strict;

my @file = "TOP50.csv" or die "Usage: $0 FILE\n";
open (my $fh, '<', @file) or die "Could not open '@file' $!";
# Both the arrays should same number of entries.
my @data;
my (@x,@y);
while (my $line = <$fh>){
   @data= split ",",$line;
   my $kata = $data[2];
   my $frek = $data[1];
   push @x, $kata;
   push @y, $frek;
}   
my $mygraph = GD::Graph::lines->new(800, 350);
$mygraph->set(
   x_label     => 'Word',
   y_label     => 'Frequency',
   title       => 'Word Frequency Distribution',
   # Draw datasets in 'solid', 'dashed' and 'dotted-dashed' lines
   line_types  => [1, 2, 4],
   # Set the thickness of line
   line_width  => 2,
   # Set colors for datasets
   dclrs       => ['blue']
) or warn $mygraph->error;

$mygraph->set_legend_font(GD::gdMediumBoldFont);
$mygraph->set_legend('Kata');
my @dt = (\@x,\@y);
my $myimage = $mygraph->plot(\@dt) or die $mygraph->error;

print "Content-type: image/png\n\n";
open (IMG, ">grafik frekuensi.png")or die "gak terprint";
binmode IMG;
print IMG $myimage->png;
close IMG;