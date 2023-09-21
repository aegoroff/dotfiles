#!/bin/bash

target=~/.config/nvim/lua/
[[ -d "$target" ]] && cp -v -r ./nvim/lua/custom/ "$target"
