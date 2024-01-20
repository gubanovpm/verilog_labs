all: build_dir Gen_ce1us_tb main_tb

build_dir:
	@mkdir -p build

%_tb:
	iverilog $@.v -o ./build/$@.out && vvp ./build/$@.out
	mv $@.vcd ./build/
	@echo "-----------Make $@ complete-----------"

clean:
	@rm -rf build
	@echo "-----------Clean complete-----------"