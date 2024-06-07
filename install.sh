#!/bin/bash

# 下载脚本
curl -o /usr/local/bin/owl https://raw.githubusercontent.com/OwlOooo/owl-panel/main/owl.sh

# 检查下载是否成功
if [ $? -ne 0 ]; then
    echo -e "\033[0;31m下载脚本失败，请检查URL是否正确。\033[0m"
    exit 1
fi

# 设置权限
sudo chmod +x /usr/local/bin/owl

# 检查是否成功设置权限
if [ $? -ne 0 ]; then
    echo -e "\033[0;31m设置权限失败。\033[0m"
    exit 1
fi

# 输出成功信息
echo -e "\033[0;32m已安装好脚本，输入owl命令即可使用脚本\033[0m"
