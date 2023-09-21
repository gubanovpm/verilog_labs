TARGET:=BTN_WRP

all:
	@iverilog *.v -o $(TARGET).out && vvp $(TARGET).out
	@echo "Make $(TARGET) complete"
clean:
	@rm -f *.out *.vcd
	@echo "Clean $(TARGET) complete"
