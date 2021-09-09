VPATH = src

# Common source files
ASM_SRCS =
C_SRCS = main.c

# Object files
OBJS = $(ASM_SRCS:%.s=%.o) $(C_SRCS:%.c=%.o)

%.o: %.s
	as6502 --core=6502 --debug --list-file=$(@:%.o=obj/%.lst) -o obj/$@ $<

%.o: %.c
	cc6502 --core=6502 --debug --list-file=$(@:%.o=obj/%.lst) -o obj/$@ $<

aout.elf: $(OBJS)
	(cd obj ; ln6502 --debug -o ../$@ $^ ../linker.scm clib-6502.a -l --cross-reference --rtattr printf=reduced --semi-hosted)

clean:
	-(cd obj ; rm $(OBJS) $(OBJS:%.o=%.lst))
	-rm aout.elf
