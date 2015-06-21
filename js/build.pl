#!/usr/bin/perl

use File::Slurp;
use autodie;

my @files = qw(
    helpers.js
    noise.js
    Building.js
    Tree.js
    Mountains.js
    Sky.js
    setup.js
);

my $content = "";

for my $file (@files) {
    $content .= read_file("src/$file") . "\n\n";
}


open my $condensed, ">", "frontier.js";
print $condensed $content;
close $condensed;

#remove comments
$content =~ s|//.*$||mg;
$content =~ s|/\*.*?\*/||mg;

#condense whitespace
$content =~ s/\s+/ /mg;

open my $minified, ">", "frontier.min.js";
print $minified $content;
close $minified;


