#! /usr/bin/perl

use 5.10.1;
use strict;
use warnings;
#use diagnostics;
use lib "lib";
use Labrador::Container;
use File::Find;
use Config::Simple;

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
	mode => 0,
	gid => 0,
	uid => 0,
	nlink => 0,
	inode => 0,
	mtime =>0,
	atime =>0,
	ctime => 0,
	size => 0,
	blocks => 0,
	dev => 0,
	
};

my $config = new Config::Simple('labrador.conf') or die "O arquivo de configuração labrador.conf não foi encontrado: $!";

my %conf = $config->vars();

my $valor;
while ((my $chave, $valor) = each(%conf)){
	if($chave =~ m/^[diretorio\.]/){
		my $dir = $chave;
		$dir =~ s/\w+\.//;

		find \&traverse, $dir;
	}
}

sub traverse{
	#say $File::Find::name;
	return if -d $File::Find::name;
	
	my $container = Labrador::Container->new($File::Find::name, $flags, $valor);
}
