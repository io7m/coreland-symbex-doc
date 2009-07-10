#!/bin/sh

SOURCE="${HOME}/git/coreland/symbex/"

fatal()
{
  echo "fatal: $1" 1>&2
  exit 1
}

info()
{
  echo "info: $1" 1>&2
}

