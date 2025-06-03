#!/bin/bash

# 自定义URL
export mirror=https://script.kejizero.online

# 私有Gitea
export gitea=git.kejizero.online/zhao

# GitHub镜像
export github="github.com"

## golang 为 1.24.x
rm -rf feeds/packages/lang/golang
git clone --depth=1 https://$github/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

# 替换插件
rm -rf feeds/packages/net/{aria2,ariang,alist,samba4,xray-core,v2ray-core,v2ray-geodata,sing-box}
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/{luci-app-aria2,luci-app-alist,luci-app-argon-config,luci-app-aria2,luci-app-homeproxy,luci-app-openclash,luci-app-passwall,luci-app-sqm}

# aria2 & ariaNG
git clone https://$github/sbwml/ariang-nginx package/new/ariang-nginx
git clone https://$github/sbwml/feeds_packages_net_aria2 -b 22.03 feeds/packages/net/aria2

# samba4 - bump version
git clone https://$github/sbwml/feeds_packages_net_samba4 feeds/packages/net/samba4

# 默认设置
git clone --depth=1 -b mediatek https://$github/zhiern/default-settings package/new/default-settings

# helloworld
git clone -b openwrt-24.10 https://$GITEA_USERTNAME:$GITEA_PASSWORD@$gitea/openwrt_helloworld package/new/helloworld

# argon
git clone --depth=1 https://github.com/jerrykuku/luci-theme-argon.git package/new/luci-theme-argon
curl -s $mirror/Customize/argon/bg1.jpg > package/new/luci-theme-argon/htdocs/luci-static/argon/img/bg1.jpg

# argon-config
git clone --depth=1 https://$github/jerrykuku/luci-app-argon-config.git package/new/luci-app-argon-config
sed -i "s/bing/none/g" package/new/luci-app-argon-config/root/etc/config/argon

# adguardhome
git clone https://$GITEA_USERTNAME:$GITEA_PASSWORD@$gitea/luci-app-adguardhome package/new/luci-app-adguardhome

# alist
git clone https://$github/sbwml/openwrt-alist package/new/alist

# Mosdns
git clone https://$github/sbwml/luci-app-mosdns -b v5 package/new/mosdns

# luci-app-sqm
git clone https://$GITEA_USERTNAME:$GITEA_PASSWORD@$gitea/luci-app-sqm feeds/luci/applications/luci-app-sqm

# OpenAppFilter
git clone https://$GITEA_USERTNAME:$GITEA_PASSWORD@$gitea/OpenAppFilter package/new/OpenAppFilter

# nlbwmon
sed -i 's/services/network/g' feeds/luci/applications/luci-app-nlbwmon/root/usr/share/luci/menu.d/luci-app-nlbwmon.json
sed -i 's/services/network/g' feeds/luci/applications/luci-app-nlbwmon/htdocs/luci-static/resources/view/nlbw/config.js

# 主题设置
sed -i 's#<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a> /#<a class="luci-link" href="https://www.kejizero.online" target="_blank">探索无限</a> /#' package/new/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme <%# vPKG_VERSION %></a>|<a href="https://github.com/zhiern/OpenWRT-Mediatek" target="_blank">OpenWRT-Mediatek</a> |g' package/new/luci-theme-argon/luasrc/view/themes/argon/footer.htm
sed -i 's#<a class="luci-link" href="https://github.com/openwrt/luci" target="_blank">Powered by <%= ver.luciname %> (<%= ver.luciversion %>)</a> /#<a class="luci-link" href="https://www.kejizero.online" target="_blank">探索无限</a> /#' package/new/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm
sed -i 's|<a href="https://github.com/jerrykuku/luci-theme-argon" target="_blank">ArgonTheme <%# vPKG_VERSION %></a>|<a href="https://github.com/zhiern/OpenWRT-Mediatek" target="_blank">OpenWRT-Mediatek</a> |g' package/new/luci-theme-argon/luasrc/view/themes/argon/footer_login.htm

# 版本设置
cat << 'EOF' >> feeds/luci/modules/luci-mod-status/ucode/template/admin_status/index.ut
<script>
function addLinks() {
    var section = document.querySelector(".cbi-section");
    if (section) {
        var links = document.createElement('div');
        links.innerHTML = '<div class="table"><div class="tr"><div class="td left" width="33%"><a href="https://qm.qq.com/q/JbBVnkjzKa" target="_blank">QQ交流群</a></div><div class="td left" width="33%"><a href="https://t.me/kejizero" target="_blank">TG交流群</a></div><div class="td left"><a href="https://openwrt.kejizero.online" target="_blank">固件地址</a></div></div></div>';
        section.appendChild(links);
    } else {
        setTimeout(addLinks, 100); // 继续等待 `.cbi-section` 加载
    }
}

document.addEventListener("DOMContentLoaded", addLinks);
</script>
EOF

# 翻译
echo -e "\nmsgid \"Control\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"控制\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

echo -e "\nmsgid \"NAS\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po
echo -e "msgstr \"网络存储\"" >> feeds/luci/modules/luci-base/po/zh_Hans/base.po

# 取消bootstrap为默认主题
sed -i '/set luci.main.mediaurlbase=\/luci-static\/bootstrap/d' feeds/luci/themes/luci-theme-bootstrap/root/etc/uci-defaults/30_luci-theme-bootstrap
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci-nginx/Makefile

# 更改主机名
sed -i "s/hostname='.*'/hostname='ZeroWrt'/g" package/base-files/files/bin/config_generate

# 修改默认ip
sed -i "s/192.168.6.1/10.0.0.1/g" package/base-files/files/bin/config_generate

# 加入作者信息
sed -i "s/DISTRIB_DESCRIPTION='*.*'/DISTRIB_DESCRIPTION='ZeroWrt-$(date +%Y%m%d)'/g"  package/base-files/files/etc/openwrt_release
sed -i "s/DISTRIB_REVISION='*.*'/DISTRIB_REVISION=' By OPPEN321'/g" package/base-files/files/etc/openwrt_release

# WiFi
sed -i "s/MT7986_AX6000_2.4G/ZeroWrt-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b0.dat
sed -i "s/MT7986_AX6000_5G/ZeroWrt/g" package/mtk/drivers/wifi-profile/files/mt7986/mt7986-ax6000.dbdc.b1.dat

sed -i "s/MT7981_AX3000_2.4G/ZeroWrt-2.4G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b0.dat
sed -i "s/MT7981_AX3000_5G/ZeroWrt-5G/g" package/mtk/drivers/wifi-profile/files/mt7981/mt7981.dbdc.b1.dat

# New WiFi
sed -i "s/ImmortalWrt-2.4G/ZeroWrt-2.4G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh
sed -i "s/ImmortalWrt-5G/ZeroWrt-5G/g" package/mtk/applications/mtwifi-cfg/files/mtwifi.sh

# TTYD
sed -i 's/services/system/g' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i '3 a\\t\t"order": 50,' feeds/luci/applications/luci-app-ttyd/root/usr/share/luci/menu.d/luci-app-ttyd.json
sed -i 's/procd_set_param stdout 1/procd_set_param stdout 0/g' feeds/packages/utils/ttyd/files/ttyd.init
sed -i 's/procd_set_param stderr 1/procd_set_param stderr 0/g' feeds/packages/utils/ttyd/files/ttyd.init

# ZeroWrt Options Menu
mkdir -p files/bin
mkdir -p root
curl -so files/root/version.txt $mirror/openwrt/files/root/mediatek.txt
curl -so files/bin/ZeroWrt $mirror/openwrt/files/bin/ZeroWrt_mtk
chmod +x files/bin/ZeroWrt
chmod +x files/root/version.txt

# key-build.pub
curl -so files/root/key-build.pub $mirror/openwrt/files/root/key-build.pub
chmod +x files/root/key-build.pub

# profile
sed -i 's#\\u@\\h:\\w\\\$#\\[\\e[32;1m\\][\\u@\\h\\[\\e[0m\\] \\[\\033[01;34m\\]\\W\\[\\033[00m\\]\\[\\e[32;1m\\]]\\[\\e[0m\\]\\\$#g' package/base-files/files/etc/profile
sed -ri 's/(export PATH=")[^"]*/\1%PATH%:\/opt\/bin:\/opt\/sbin:\/opt\/usr\/bin:\/opt\/usr\/sbin/' package/base-files/files/etc/profile
sed -i '/PS1/a\export TERM=xterm-color' package/base-files/files/etc/profile

# 切换bash
sed -i 's#ash#bash#g' package/base-files/files/etc/passwd
sed -i '\#export ENV=/etc/shinit#a export HISTCONTROL=ignoredups' package/base-files/files/etc/profile
mkdir -p files/root
curl -so files/root/.bash_profile $mirror/openwrt/files/root/.bash_profile
curl -so files/root/.bashrc $mirror/openwrt/files/root/.bashrc
