#!/usr/bin/perl

use strict;
use warnings;
use feature qw|say|;

#package Class;
#use Alpha;

#package Child;
#use Alpha;
#use parent -norequire, 'Class';

package main;
use Data::Dumper;
$Data::Dumper::Indent = 1;
use Getopt::Std;

INIT {}

RUN: {
	MAIN(options());
}

sub options {
	my @opts = (
		['h' => 'help'],
		['i:' => 'input file (path)']
	);
	getopts (join('',map {$_->[0]} @opts), \my %opts);
	if (! %opts || $opts{h}) {
		say join ' - ', @$_ for @opts;
		exit; 
	}
	$opts{$_} || die "required opt $_ missing\n" for qw||;
	-e $opts{$_} || die qq|"$opts{$_}" is an invalid path\n| for qw||;
	return \%opts;
}

sub MAIN {
	my $opts = shift;
	
	dls_data_tsv($opts->{i});
}

sub dls_data_tsv {
	my $file = shift;
	
	open my $in,'<',$file;
	open OUT,'>',$file.'.tsv';
	say $file.'.tsv';
	local $/;
	for (<$in> =~ /(<tr>.*?<\/tr>)/g) {
		my @record = split /<.*?>/, $_;
		my $id = $record[3];
		my @row = $id;
		for (8..$#record) {
			push @row, $record[$_] if $_ % 2 == 0;
		}
		say OUT join "\t", @row;
	}
	#seek $out,0,0;
	close OUT;
	open OUT,'<',$file.'.tsv';
	
	return *OUT;
}

END {}

__DATA__