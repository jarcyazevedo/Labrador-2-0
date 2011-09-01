#! /usr/bin/perl

use 5.10.1;
use strict;
use warnings;
#use diagnostics;
use lib "lib";
use Labrador::Container;
use File::Find;
use Config::Simple;
use DBI;

my $flags = {
	md5  => 0,
	sha1 => 0,
	sha224 => 0,
	sha256 => 0,
	sha384 => 0,
	sha512 => 0,
	haval => 0,
	whirlpool => 0,
	ripemd160 => 0,
	crc64 => 0,
	crc32  => 0,
	crc16 => 0,
	crc8 => 0,
	crcccitt => 0,
	mode => 1,
	gid => 1,
	uid => 1,
	nlink => 1,
	inode => 1,
	mtime =>1,
	atime =>1,
	ctime => 1,
	size => 1,
	blocks => 1,
	dev => 1,
	
};

my $config = new Config::Simple('labrador.conf') or die "O arquivo de configuração labrador.conf não foi encontrado.";

my %conf = $config->vars();
#my $dir = $conf->param('dir');
#my $dir = shift or die "especifique dir";
#say "lendo dir '$dir'... ";
while ((my $key, my $value) = each(%conf)){
	if($key =~ m/^[diretorio\.]/){
		my $dir = $key;
		$dir =~ s/\w+\.//;
		#say $dir ." = ". $value;

		find \&traverse, $dir;

		sub traverse{
			#say $File::Find::name;
			return if -d $File::Find::name;

			my $container = Labrador::Container->new($File::Find::name, $flags);
		}
	}
}

