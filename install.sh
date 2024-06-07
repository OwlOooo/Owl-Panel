#!/bin/bash

# 定义颜色变量
GREEN='\033[0;32m'
NC='\033[0m'

# 检查操作系统类型
os_type=$(grep -Ei 'centos|red hat|fedora' /etc/*release)

# 根据操作系统类型选择下载URL
if [[ -n "$os_type" ]]; then
    echo -e "${GREEN}检测到CentOS系统，正在获取最新的Owl脚本...${NC}"
    script_url="https://raw.githubusercontent.com/OwlOooo/owl-panel/main/owl.sh"
else
    echo -e "${GREEN}检测到Debian系统，正在获取最新的Owl脚本...${NC}"
    script_url="https://raw.githubusercontent.com/OwlOooo/owl-panel/main/owl_debian.sh"
fi

# 强制获取最新的脚本
if [ -f /usr/local/bin/owl ]; then
    sudo rm /usr/local/bin/owl
fi
sudo curl -o /usr/local/bin/owl $script_url

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
