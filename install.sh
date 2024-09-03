#!/bin/sh

# 定义颜色变量
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

# 检查操作系统类型
if grep -Eqi "debian|ubuntu" /etc/os-release; then
    os_type="debian"
elif grep -Eqi "centos|red hat|fedora" /etc/os-release; then
    os_type="centos"
else
    os_type="unknown"
fi

# 调试信息
echo "${YELLOW}Debug: Detected OS type is $os_type${NC}"

# 根据操作系统类型选择下载URL
if [ "$os_type" = "centos" ]; then
    echo "${GREEN}检测到CentOS系统，正在获取最新的Owl脚本...${NC}"
    script_url="https://raw.githubusercontent.com/OwlOooo/owl-panel/main/owl.sh"
elif [ "$os_type" = "debian" ]; then
    echo "${GREEN}检测到Debian系统，正在获取最新的Owl脚本...${NC}"
    script_url="https://raw.githubusercontent.com/OwlOooo/owl-panel/main/owl_debian.sh"
else
    echo "${RED}不支持的操作系统。${NC}"
    exit 1
fi

# 显示选择的URL
echo "${YELLOW}Debug: Selected script URL is $script_url${NC}"

# 强制获取最新的脚本
if [ -f /usr/local/bin/owl ]; then
    echo "${GREEN}旧的脚本存在，删除它...${NC}"
    sudo rm -f /usr/local/bin/owl
fi

# 添加时间戳参数
timestamp=$(date +%s)

echo "${GREEN}下载最新的脚本...${NC}"
sudo curl -H "Cache-Control: no-cache, no-store, must-revalidate" -H "Pragma: no-cache" -H "Expires: 0" -o /usr/local/bin/owl -L "${script_url}?t=${timestamp}"

# 检查下载是否成功
if [ $? -ne 0 ]; then
    echo "${RED}下载脚本失败，请检查URL是否正确。${NC}"
    exit 1
fi

# 设置权限
echo "${GREEN}设置脚本权限...${NC}"
sudo chmod +x /usr/local/bin/owl

# 检查是否成功设置权限
if [ $? -ne 0 ]; then
    echo "${RED}设置权限失败。${NC}"
    exit 1
fi

# 输出成功信息
echo "${GREEN}已安装好脚本，输入owl命令即可使用脚本${NC}"
