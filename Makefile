ASFLAGS += -W
CFLAGS += -O1 -masm=intel -fno-asynchronous-unwind-tables

fibonacci: fibonacci.s
	$(CC) $(CPPFLAGS) $(CFLAGS) -g -o $@ $^

.PHONY: clean

clean:
	rm -f ./fibonacci
