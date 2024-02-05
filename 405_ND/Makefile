all: build_dir aviasales_tb

build_dir:
	@mkdir -p build

%_tb:
	iverilog $@.v -o ./build/$@.out && vvp ./build/$@.out
	mv $@.vcd ./build/
	@echo "-----------Make $@ complete-----------"

clean:
	@rm -rf build
	@echo "-----------Clean complete-----------"