
# Required to make the "make" files
require 'mkmf'

# Looks up how ruby was compiled
require 'rbconfig'


$LDFLAGS << " -framework CoreServices"

# If the given header file can be found in the standard search path, 
# adds the directive -D HAVE_HEADER to the compile command in the Makefile and returns true.
have_header("CoreServices/CoreServices.h")


# Creates a Makefile for our extension
# If this method is not called, no Makefile is created.
create_makefile('spotlight')
