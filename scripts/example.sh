#!/bin/bash
# Example script with simple animation

text="Hello from MakeZ!"

# Typing animation
for ((i=0; i<${#text}; i++)); do
    printf "%s" "${text:$i:1}"
    sleep 0.05
done
echo ""
