#!/bin/sh
ctags -R --fields=+aimS --languages=javascript --exclude=node_modules --exclude=e2e --exclude=public
