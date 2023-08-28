VPATH = src

C64 = module/Calypsi-6502-Commodore

# Common source files
ASM_SRCS =
C_SRCS = main.c

# Object files
OBJS = $(ASM_SRCS:%.s=obj/%.o) $(C_SRCS:%.c=obj/%.o)
OBJS_DEBUG = $(ASM_SRCS:%.s=obj/%-debug.o) $(C_SRCS:%.c=obj/%-debug.o)

obj/%.o: %.s
	as6502 --target=c64 --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%.o: %.c
	cc6502 --target=c64 -O2 --list-file=$(@:%.o=%.lst) -o $@ $< -DCOMMODORE

obj/%-debug.o: %.s
	as6502 --target=c64 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

obj/%-debug.o: %.c
	cc6502 --target=c64 --debug --list-file=$(@:%.o=%.lst) -o $@ $<

hello.elf: $(OBJS_DEBUG)
	ln6502 --target=c64 c64-plain.scm --debug -o $@ $^ --list-file=hello-debug.lst --cross-reference --rtattr printf=reduced --semi-hosted --verbose

hello.prg:  $(OBJS)
	ln6502 --target=c64 c64-plain.scm -o $@ $^  --output-format=prg --list-file=hello-c64.lst --cross-reference --rtattr printf=reduced --rtattr cstartup=c64

$(C64_LIB):
	(cd $(C64) ; make all)

clean:
	-rm $(OBJS) $(OBJS:%.o=%.lst) $(OBJS_DEBUG) $(OBJS_DEBUG:%.o=%.lst) $(C64_LIB)
	-rm hello.elf hello.prg hello-c64.lst hello-debug.lst
	-(cd $(C64) ; make clean)
