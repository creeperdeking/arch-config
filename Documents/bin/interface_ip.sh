#!/bin/zsh

ip route | grep '^default' | read -r def via add0 d dev p a s addr m mask; echo "${dev%} ${addr%}/${mask%}"
