#!/bin/bash

src=~/.config/nvim/lua/custom/
[[ -d "$src" ]] && cp -v -r "$src" ./nvim/lua/
