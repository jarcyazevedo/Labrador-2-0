package Labrador::Container;

use 5.10.1;
use strict;
use warnings;
#use diagnostics;
use Digest;
use Digest::MD5;
use Digest::SHA;
use Digest::Haval256;
use Digest::Whirlpool;
use Digest::CRC;
use Crypt::RIPEMD160;
use File::stat;
use autodie;
use Try::Tiny;
use Class::XSAccessor {
	accessors => [ qw( md5 sha1 sha224 sha256 sha384 sha512
                           haval whirlpool ripemd160 crc32 crc16 
			   crc8 crcccitt mode uid gid nlink inode
			   mtime atime ctime size blocks dev grow 
			   filename
	 )]
};

sub new {
	my ($class, $filename, $flags, $dir_flag) = @_;
	my $self = bless {}, $class;

	say "lendo arquivo '$filename'... ";
	eval {
		open ARQ, '<', $File::Find::name;
	};
	return if $@;

	binmode ARQ;

	# Atualizando as flags para cada arquivo
	atualiza_flags ($flags, $dir_flag);

	if ($flags->{md5}){
		my $hash = Digest::MD5->new->addfile(*ARQ)->hexdigest;
		say "(md5) $hash   -    $filename";
	}
	if( $flags->{sha1} ) {
		my $hash = Digest::SHA->new('sha1')->addfile(*ARQ)->hexdigest;
		say "(sha1) $hash   -    $filename";
	}
	if( $flags->{sha224} ) {
		my $hash = Digest::SHA->new('sha224')->addfile(*ARQ)->hexdigest;
		say "(sha224) $hash   -    $filename";
	}
	if( $flags->{sha256} ) {
		my $hash = Digest::SHA->new('sha256')->addfile(*ARQ)->hexdigest;
		say "(sha256) $hash   -    $filename";
	}
	if( $flags->{sha384} ) {
		my $hash = Digest::SHA->new('sha384')->addfile(*ARQ)->hexdigest;
		say "(sha384) $hash   -    $filename";
	}
	if( $flags->{sha512} ) {
		my $hash = Digest::SHA->new('sha512')->addfile(*ARQ)->hexdigest;
		say "(sha512) $hash   -    $filename";
	}
	if( $flags->{haval} ) {
		my $digest = Digest::Haval256->new->addfile(*ARQ);
		my $hash = $digest->hexdigest;
		say "(haval) $hash   -    $filename";
	}
	if( $flags->{ripemd160} ) {
		my $digest = new Crypt::RIPEMD160;
		$digest->addfile(*ARQ);
		my $hash = $digest->digest();
		print("(ripemd160) " . unpack("H*", $hash) . "\n");
	}
	### NAO SEI PQ A SAIDA EH SEMPRE 0 PARA O CRC64
	### CODIGO EM ACORDO C/ PERLDOC
	#
	#if( $flags->{crc64} ) {
	#	my $digest = Digest::CRC->new( type => 'crc64' )->addfile(*ARQ);
	#	my $hash = $digest->hexdigest;
	#	say "(crc64) $hash   -   $filename";
	#}
	if( $flags->{crc32} ) {
		my $digest = Digest::CRC->new( type => 'crc32' )->addfile(*ARQ);
		my $hash = $digest->hexdigest;
		say "(crc32) $hash   -   $filename";
	}
	if( $flags->{crc16} ) {
		my $digest = Digest::CRC->new( type => 'crc16' )->addfile(*ARQ);
		my $hash = $digest->hexdigest;
		say "(crc16) $hash   -   $filename";
	}
	if( $flags->{crc8} ) {
		my $digest = Digest::CRC->new( type => 'crc8' )->addfile(*ARQ);
		my $hash = $digest->hexdigest;
		say "(crc8) $hash   -   $filename";
	}
	if( $flags->{crcccitt} ) {
		my $digest = Digest::CRC->new( type => 'crcccitt' )->addfile(*ARQ);
		my $hash = $digest->hexdigest;
		say "(crcccitt) $hash   -   $filename";
	}
	if( $flags->{whirlpool} ) {
		my $digest = Digest->new('Whirlpool')->add(*ARQ);
		my $hash = $digest->hexdigest;
		say "(Whirlpool) $hash  -  $filename";
	}
	# File::stat (ou soh "stat" (perldoc -f lstat) para uid, gid, etc)
	#perldoc -f -X
	if( $flags->{mode} ) {
		my $st_mode = stat(*ARQ)->mode;
		say "(mode) $st_mode  -  $filename";
	}
	if( $flags->{gid} ) {
		my $st_gid = stat(*ARQ)->gid;
		say "(gid) $st_gid  -  $filename";
	}
	if( $flags->{uid} ) {
		my $st_uid = stat(*ARQ)->uid;
		say "(uid) $st_uid  -  $filename";
	}
	if( $flags->{nlink} ) {
		my $st_nlink = stat(*ARQ)->nlink;
		say "(nlink) $st_nlink  -  $filename";
	}
	if( $flags->{inode} ) {
		my $st_inode = stat(*ARQ)->ino;
		say "(inode) $st_inode  -  $filename";
	}
	if( $flags->{mtime} ) {
		my $st_mtime = stat(*ARQ)->mtime;
		say "(mtime) $st_mtime  -  $filename";
	}
	if( $flags->{atime} ) {
		my $st_atime = stat(*ARQ)->atime;
		say "(atime) $st_atime  -  $filename";
	}
	if( $flags->{ctime} ) {
		my $st_ctime = stat(*ARQ)->ctime;
		say "(ctime) $st_ctime  -  $filename";
	}
	if( $flags->{size} ) {
		my $st_size = stat(*ARQ)->size;
		say "(size) $st_size  -  $filename";
	}
	if( $flags->{blocks} ) {
		my $st_blocks = stat(*ARQ)->blocks;
		say "(blocks) $st_blocks  -  $filename";
	}
	if( $flags->{dev} ) {
		my $st_dev = stat(*ARQ)->dev;
		say "(dev) $st_dev  -  $filename";
	}	
	close ARQ;

}

# atualiza as flags ativas para cada dir especificado no .conf
sub atualiza_flags{
	my ($flags, $dir_flag) = @_;
	
	my @valores = split (",", $dir_flag);
	if ($valores[0] ne "!"){
		foreach my $key (%$flags){
			$flags->{$key} = 0;
		}
		foreach my $valor(@valores){
			$flags->{$valor} = 1;
		}
	}
	else{
		foreach my $key (%$flags){
			$flags->{$key} = 1;
		}
		shift @valores;
		foreach my $valor(@valores){
			$flags->{$valor} = 0;
		}
	}
	
}

1;
