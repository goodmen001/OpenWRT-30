#!/bin/bash

# 时间函数
CURRENT_DATE=$(date +%s)

cd $OPENWRT_PATH
mkdir -p ota
OTA_URL="https://github.com/zhiern/OpenWRT/releases/download"
SHA256=$(sha256sum bin/targets/x86/64*/*-generic-squashfs-combined-efi.img.gz | awk '{print $1}')
cat > ota/fw.json <<EOF
{
  "x86_64": [
    {
      "build_date": "$CURRENT_DATE",
      "sha256sum": "$SHA256",
      "url": "$OTA_URL/x86_64-OpenWrt/zerowrt-vip-plus-x86-64-generic-squashfs-combined-efi.img.gz"
    }
  ]
}
EOF
