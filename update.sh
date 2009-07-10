#!/bin/sh
make clean html-split css txt package release &&
  rsync -avz --delete release/ www:/sites/waste/doc/symbex-doc-release/
