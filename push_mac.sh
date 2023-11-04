#!/bin/bash
target=~/.config/nvim/lua/custom/
[[ -d "$target" ]] && cp -v -r ./nvim/lua/custom/ "$target"
