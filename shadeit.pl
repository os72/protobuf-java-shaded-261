use strict;
use warnings;
use File::Path;

mkdir "java/src/main/java/com/github";
mkdir "java/src/main/java/com/github/os72";
mkdir "java/src/main/java/com/github/os72/protobuf261";
mkdir "java/src/test/java/com/github";
mkdir "java/src/test/java/com/github/os72";
mkdir "java/src/test/java/com/github/os72/protobuf261";

shadeit("src/google/protobuf", "src/google/protobuf", ".proto");
shadeit("java/src/main/java/com/google/protobuf", "java/src/main/java/com/github/os72/protobuf261", ".java");
shadeit("java/src/test/java/com/google/protobuf", "java/src/test/java/com/github/os72/protobuf261", ".java");
shadeit("java/src/test/java/com/google/protobuf", "java/src/test/java/com/github/os72/protobuf261", ".proto");

rmtree "java/src/main/java/com/google" or die $!;
rmtree "java/src/test/java/com/google" or die $!;

sub shadeit
{
	my($dir_in, $dir_out, $suffix) = @_;
	opendir(DIR, $dir_in) or die $!;
	while (my $file = readdir(DIR)) {
		next unless ($file =~ m/$suffix$/);		
		print "$dir_in/$file\n";
		
		open(FIN, "<$dir_in/$file");
		open(FOUT, ">$dir_out/$file.tmp");
		while (my $line = <FIN>) {
			$line =~ s/com\.google\.protobuf/com.github.os72.protobuf261/g;
			$line =~ s/com\/google\/protobuf/com\/github\/os72\/protobuf261/g;
			print FOUT $line;
		}
		close(FIN);
		close(FOUT);
		
		rename "$dir_out/$file.tmp", "$dir_out/$file" or die $!;
	}
	closedir(DIR);
}
