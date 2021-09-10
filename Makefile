VPATH = src

C64 = module/calypsi-6502-commodore

# Common source files
ASM_SRCS =
C_SRCS = main.c

C64_LIB = $(C64)/c64.a
C64_LINKER_RULES = $(C64)/linker-files/c64.scm

# Object files
OBJS = $(ASM_SRCS:%.s=obj/%.o) $(C_SRCS:%.c=obj/%.o)
OBJS_DEBUG = $(ASM_SRCS:%.s=obj/%-debug.o) $(C_SRCS:%.c=obj/%-debug.o)

obj/%.o: %.s
	as6502 --core=6502 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%.o: %.c
	cc6502 --core=6502 -O2 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.s
	as6502 --core=6502 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.c
	cc6502 --core=6502 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

hello.elf: $(OBJS_DEBUG)
	ln6502 --debug -o $@ $^ linker.scm clib-6502.a --list-file=hello-debug.lst --cross-reference --rtattr printf=reduced --semi-hosted

hello.prg:  $(OBJS) $(C64_LIB)
	ln6502 -o $@ $^ $(C64_LINKER_RULES) clib-6502.a --output-format=prg --list-file=hello-c64.lst --cross-reference --rtattr printf=reduced --rtattr cstartup=c64

$(C64_LIB):
	(cd $(C64) ; make all)

clean:
	-rm $(OBJS) $(OBJS:%.o=%.lst) $(OBJS_DEBUG) $(OBJS_DEBUG:%.o=%.lst) $(C64_LIB)
	-rm hello.elf hello.prg
	-(cd $(C64) ; make clean)
