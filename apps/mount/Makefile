################################################################################
#
#   Copyright (c) 2012 Minoca Corp. All Rights Reserved
#
#   Binary Name:
#
#       mount
#
#   Abstract:
#
#       This executable implements the mount application. It is used to mount
#       block devices, directories, devices, and files onto other directories
#       or files.
#
#   Author:
#
#       Chris Stevens 30-Jul-2013
#
#   Environment:
#
#       User
#
################################################################################

BINARY = mount

BINPLACE = bin

BINARYTYPE = app

INCLUDES += $(SRCROOT)/os/apps/libc/include; \

OBJS = mount.o \

DYNLIBS = -lminocaos

include $(SRCROOT)/os/minoca.mk

postbuild:
	@mkdir -p $(BINROOT)/skel/bin
	@if test $(BINROOT)/$(BINARY) -nt $(BINROOT)/skel/bin/$(BINARY); then \
	    $(STRIP) -o $(BINROOT)/skel/bin/$(BINARY) $(BINROOT)/$(BINARY); \
	fi
