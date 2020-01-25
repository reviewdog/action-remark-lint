.PHONY: image release clean

all: image

image:
	@docker build -t prologic/action-remark-lint .

release:
	@./tools/release.sh

clean:
	@git clean -f -d -X
