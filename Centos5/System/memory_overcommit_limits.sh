#!/bin/bash

sysctl -w vm.overcommit_memory=2
sysctl -w kernel.panic=15

