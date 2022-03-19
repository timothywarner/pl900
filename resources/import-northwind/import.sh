#!/bin/sh

agens -v cwd="$(pwd)/" -f import.sql postgres
