#!/bin/sh
ctags -R --fields=+aimS --languages=php --exclude=vendor/ --exclude=tests
