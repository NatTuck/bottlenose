#!/bin/bash
lxc launch bn-d10 bn-demo -e \
    -c "limits.cpu.allowance=20ms/60ms" \
    -c "limits.memory=1024MB" \
    -c "limits.processes=64"
