#!/usr/bin/perl

if(! -x "/usr/bin/cflow"){print "\'cflow\' not installed.\n"; exit;}
$in=join " ",@ARGV;
my @color=qw(#eecc80 #ccee80 #80ccee #eecc80 #80eecc);
my @shape=qw(box ellipse octagon hexagon diamond);
my $pref="./cflow";
my $exts="svg png pdf";

if (index($in, "-d") == -1){
	$in="-d 5 $in";
	print "GG";
}

foreach (`/usr/bin/cflow -l $in | grep '<'`){
# foreach (`/usr/bin/cflow -l $in`){
	chomp;
	s/\(.*$//; s/^\{\s*//; s/\}\s*/\t/;
	my($n,$f)=split /\t/,$_;
	$index[$n]=$f;
	if($n){
	$_="$index[$n-1]->$f";
# 	$_="$index[$n-1]->$f\n$last_f->$f";
	$last_f=$f;
	push @output,"node [color=\"$color[$n-1]\" shape=$shape[$n]];edge [color=\"$color[$n-1]\"];\n$_\n" if(! $count{$_}++);
	}
	else{push @output,"$f [shape=box];\n";$last_f=$f;}
}

$fn="";
foreach (`/usr/bin/cflow -l $in | grep '<'`){
	my($n,$f)=split /:/,$_;
	my($n,$f)=split / at /,$n;
	if (index($fn,$f)==-1){
	$fn="$fn $f";
	}
}

#print @output; exit;
unshift @output,"digraph G {\ngraph [ dpi = 240 ];\nnode [peripheries=2 style=\"filled,rounded\" fontname=\"Vera Sans YuanTi Mono\" color=\"$color[0]\"];\nrankdir=LR;\nlabel=\"$fn\"\n";
push @output,"}\n";
open FILE,'>',"$pref.dot"; print FILE @output;close FILE;
print "dot output to $pref.dot.\n";
open (STDERR, ">/dev/null");
if(-x "/usr/bin/dot"){
foreach (split / /,$exts) {
$_,$ext=$_;
`dot -T$ext "$pref.dot" -o $pref.$ext`;
print "$ext output to $pref.$ext.\n";
# if(-x "/usr/bin/eog"){`eog $pref.$ext`;}
}
}
if(-x "/usr/bin/feh"){`feh $pref.png`;}
else{print "\'dot(graphviz)\' not installed.\n"}
close STDERR;
