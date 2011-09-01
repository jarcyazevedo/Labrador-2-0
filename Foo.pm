package Foo;
use Class::XSAccessor {
	    accessors => [ qw( md5 sha1 sha224 sha256 sha384 sha512
		                               haval whirlpool ripemd160 crc32 crc16 
					                      crc8 crcccitt mode uid gid nlink inode
							                     mtime atime ctime size blocks dev grow 
									                    filename
											         )]
										 };

										 1;
