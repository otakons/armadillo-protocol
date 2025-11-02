.PHONY: build run

build:
	godot --headless --export-release "Linux" game/project.godot armadillo-protocol

run: build
	steam-run ./build.x86_64

clean:
	rm -f game/armadillo-protocol
	rm -f game/armadillo-protocol.pck
