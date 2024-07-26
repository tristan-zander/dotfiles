#!/usr/bin/env bash

shell=$(grep "^$USER:" /etc/passwd | cut -f 7 -d ':')
exec $shell --login $@
