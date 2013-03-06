#
# runtime/Makefile.  Generated from Makefile.in by configure.
#
# runtime/Makefile.in
# 
# This file is part of the Oxford Oberon-2 compiler
# Copyright (c) 2006 J. M. Spivey
# All rights reserved
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
# 3. The name of the author may not be used to endorse or promote products
#    derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
# OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
# IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
# OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
# WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
# OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
# ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

# Config stuff
CC = gcc
AR = ar
RANLIB = ranlib
CFLAGS = -g -O2 -m32
RTFLAGS = ${CFLAGS} -fno-strict-aliasing
HAVE_X = 1
XYPRIMS = @XYPRIMS@
TCLSH = tclsh
top_srcdir = ..
prefix = /usr/local
exec_prefix = ${prefix}
libdir = ${exec_prefix}/lib/obc
subdir = runtime
SHELL = /bin/sh
DEBUG = 1
VPATH = ../lib
ENABLE_JIT = 1
GC_PAGESIZE = 4096
# End

all :: ppx ppxj pplink

ALL_CFLAGS = $(CFLAGS) -Wall $(INCLUDE)
ALL_RTFLAGS = $(RTFLAGS) -Wall $(INCLUDE)

PPLINK = oblink.o linker.o symtab.o template.o util.o
pplink : $(PPLINK) 
	$(CC) $(CFLAGS) -o $@ $^

$(PPLINK) : %.o : %.c
	$(CC) $(ALL_CFLAGS) -c $< -o $@

COMMON = support.o loader.o gc0.o
OBX = interp.o xmain.o $(COMMON)
JIT = jit.o jitlab.o jitregs.o jitval.o
PACK = $(AR) cr $@ $^ && $(RANLIB) $@

ppx: obx-t.a lib.o 
	$(CC) $(ALL_RTFLAGS) $^ -o $@

ppxj: obx-j.a lib.o 
	$(CC) $(ALL_RTFLAGS) $^ -o $@

lib.o: lib.c
	$(CC) -c $(ALL_RTFLAGS) $< -o $@

obx.a :   $(OBX);						$(PACK)
obx-t.a : interp-t.o xmain-t.o trace.o $(COMMON);		$(PACK)
obx-p.a : interp-p.o xmain-p.o profile.o $(COMMON);		$(PACK)
obx-d.a : interp-d.o xmain-d.o debug.o $(COMMON);		$(PACK)
obx-j.a : $(JIT) vm386.o xmain-j.o decode.o $(COMMON);		$(PACK)

# Cancel default rule
%.o: %.c

vm386.o : %.o : %.c
	$(CC) $(ALL_RTFLAGS) -DCODEPAGE=$(GC_PAGESIZE) $(DEBUGDEF) -c $< -o $@

vmlight.o : %.o : %.c
	$(CC) $(ALL_RTFLAGS) -c -DCODEPAGE=$(GC_PAGESIZE) $(DEBUGDEF) \
		-fno-strict-aliasing -Wno-unused-value -Wno-address $< -o $@

$(OBX) $(JIT) decode.o trace.o profile.o debug.o: %.o : %.c
	$(CC) $(ALL_RTFLAGS) -c $< -o $@

%-n.o : %.c
	$(CC) $(ALL_RTFLAGS) -DNATIVE -c $< -o $@

%-t.o : %.c
	$(CC) $(ALL_RTFLAGS) -DTRACE -c $< -o $@

%-p.o : %.c
	$(CC) $(ALL_RTFLAGS) -DPROFILE -c $< -o $@

%-d.o : %.c
	$(CC) $(ALL_RTFLAGS) -DOBXDEB -c $< -o $@

%-j.o : %.c
	$(CC) $(ALL_RTFLAGS) -DJIT -c $< -o $@

GEN = keiko.h template.c interp.c decode.c

generate : $(GEN)

keiko.h template.c interp.c : iset.tcl keiko.iset iskel.c config.tcl
	$(TCLSH) iset.tcl keiko.iset iskel.c keiko.h template.c interp.c

decode.c : jitgen.tcl keiko.iset
	$(TCLSH) jitgen.tcl keiko.iset decode.c


## Cleanup

# clean: remove all object files
clean:
	rm -f pplink ppx ppxj *.[ao]

# realclean: remove generated source too
realclean: clean
	rm -f $(GEN)

.DELETE_ON_ERROR:

###

support.o interp.o interp-t.o interp-p.o interp-d.o profile.o \
xmain.o xmain-t.o xmain-p.o xmain-d.o xmain-j.o debug.o \
trace.o loader.o jit.o jitlab.o gc0.o: \
	obx.h obcommon.h config.h exec.h

interp.o interp-t.o interp-p.o interp-d.o \
xmain.o xmain-t.o xmain-p.o xmain-d.o debug.o jit.o trace.o: \
	keiko.h

linker.o oblink.o symtab.o template.o util.o: \
	oblink.h obcommon.h config.h exec.h util.h keiko.h

$(JIT) decode.o: decode.h 
jit.o jitval.o decode.o: keiko.h
$(JIT): jit.h vm.h
vm386.o: vm.h
