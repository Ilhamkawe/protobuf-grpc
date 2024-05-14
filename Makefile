# Replace this with your own github.com/<username>/<repository>
GO_MODULE := github.com/Ilhamkawe/protobuf-grpc

.PHONY: clean
clean:
ifeq ($(OS), Windows_NT)
	if exist "protogen" rd /s /q protogen
	mkdir protogen\go
else
	rm -fR ./protogen 
	mkdir -p ./protogen/go
	ls
endif


.PHONY: protoc-go
protoc-go:
	protoc --go_opt=module=${GO_MODULE} --go_out=. \
	--go-grpc_opt=module=${GO_MODULE} --go-grpc_out=. \
	./proto/hello/*.proto \

.PHONY: build
build: clean protoc-go


.PHONY: pipeline-init
pipeline-init:
	sudo apt-get install -y protobuf-compiler golang-goprotobuf-dev
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest


.PHONY: pipeline-build
pipeline-build: pipeline-init build

## gateway ##

.PHONY: clean-gateway
clean-gateway:
ifeq ($(OS), Windows_NT)
	if exist "protogen\gateway" rd /s /q protogen\gateway
	mkdir protogen\gateway\go
	mkdir protogen\gateway\openapiv2
else
	rm -fR ./protogen/gateway 
	mkdir -p ./protogen/gateway/go
	mkdir -p ./protogen/gateway/openapiv2
endif


.PHONY: protoc-go-gateway
protoc-go-gateway:
	protoc -I .\ ./proto/hello/*.proto  


.PHONY: protoc-openapiv2-gateway
protoc-openapiv2-gateway:
	protoc -I .\ ./proto/hello/*.proto 



.PHONY: build-gateway
build-gateway: clean-gateway protoc-go-gateway 


.PHONY: pipeline-init-gateway
pipeline-init-gateway:
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest


.PHONY: pipeline-build-gateway
pipeline-build-gateway: pipeline-init-gateway build-gateway protoc-openapiv2-gateway
