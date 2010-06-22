# Required to make the "make" files
require 'mkmf'

# Looks up how ruby was compiled
require 'rbconfig'

$LDFLAGS += ' -framework CoreFoundation -framework CoreServices'

# If the given header file can be found in the standard search path, 
# adds the directive -D HAVE_HEADER to the compile command in the Makefile and returns true.
have_header('md_item_native')

# Creates a Makefile for an extension named target. 
# If this method is not called, no Makefile is created.
create_makefile('md_item_native')