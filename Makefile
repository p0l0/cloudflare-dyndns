GO111MODULE=on

DESTDIR=../build
SRCDIR=src

.PHONY: all test coverage racetest

all:
	$(info Compiling binaries (v$(VERSION))...)
	@cd $(SRCDIR); go get github.com/mitchellh/gox ; CGO_ENABLED=0 gox -osarch="linux/amd64 darwin/amd64 linux/arm" -output="$(DESTDIR)/cloudflare-dyndns-$(VERSION)-{{.OS}}_{{.Arch}}" -ldflags="-X 'main.Version=v$(VERSION)'"

test:
	$(info Running tests...)
	@cd $(SRCDIR); go test -v -coverprofile .coverage.txt
	@cd $(SRCDIR); go tool cover -func .coverage.txt

coverage: test
	@cd $(SRCDIR); go tool cover -html=.coverage.html

racetest:
	$(info Running tests...)
	@cd $(SRCDIR); go test -race -v -coverprofile .coverage.txt
	@cd $(SRCDIR); go tool cover -func .coverage.txt