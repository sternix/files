#!/bin/sh

<<COMMENT

format , static analysis and build go program
with svn revision and build date

requires go files in cwd and main.revision and main.buildTime fields with string type like

package main

import (
	"flag"
	"fmt"
)

var (
	verFlag   = flag.Bool("v", false, "Version Information")
	revision  string
	buildTime string
)

func init() {
	flag.Parse()
}

func main() {
	if *verFlag {
		fmt.Printf("Revision: %s\nBuild Time: %s\n", revision, buildTime)
		return
	}

	fmt.Println("Hello World")
}
COMMENT

SVN=/usr/local/bin/svn
DATE=/bin/date
BUILD_DATE=$( ${DATE} +%Y-%m-%d_%H:%M:%S)
SVN_REVISION=$( ${SVN} info --show-item=revision )
PARAMS="-X main.revision=${SVN_REVISION} -X main.buildTime=${BUILD_DATE}"
gofmt -s -l -w . &&  go vet -all -shadow=true . && go build -ldflags "${PARAMS}" .
