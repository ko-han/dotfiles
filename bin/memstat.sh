#!/usr/bin/env bash

# Size：表示该映射区域在虚拟内存空间中的大小。
# Rss：表示该映射区域当前在物理内存中占用了多少空间
# Shared_Clean：和其他进程共享的未被改写的page的大小
# Shared_Dirty： 和其他进程共享的被改写的page的大小
# Private_Clean：未被改写的私有页面的大小。
# Private_Dirty： 已被改写的私有页面的大小。
# Swap：表示非mmap内存（也叫anonymous memory，比如malloc动态分配出来的内存）由于物理内存不足被swap到交换空间的大小。
# Pss：该虚拟内存区域平摊计算后使用的物理内存大小(有些内存会和其他进程共享，例如mmap进来的)。比如该区域所映射的物理内存部分同时也被另一个进程映射了，且该部分物理内存的大小为1000KB，那么该进程分摊其中一半的内存，即Pss=500KB。

PID=$1
MEMTYPE="$2"

[[ -z "$1" ]] && exit 1
[[ -z "$2" ]] && MEMTYPE="rss"

case "$MEMTYPE" in
rss) GREP="^Rss" ;;
share) GREP="^share" ;;
swap) GREP='^Swap' ;;
*) GREP="$MEMTYPE" ;;
esac

grep "$GREP" /proc/"$PID"/smaps | awk '{sum += $2} END {print sum "\tkb"}'
