#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
COMPOSE_URL='https://raw.githubusercontent.com/OwlOooo/owl-panel/main/docker-compose-arm.yml'
ENV_URL='https://raw.githubusercontent.com/OwlOooo/owl-panel/main/.env'

# 标题函数
StartTitle() {
    echo -e '  \033[0;1;36;96m欢迎使用猫头鹰订阅管理面板一键脚本 (ARM版)\033[0m'
}

# 读取 .env 文件
load_env() {
    if [ ! -f .env ]; then
        echo -e "${RED}.env 文件不存在，请先下载 .env 文件。${NC}"
        return 1
    fi
    export $(grep -v '^#' .env | xargs)
}

# 检测 MySQL 端口
check_mysql_port() {
    if ! command -v nc &> /dev/null; then
        sudo apt-get update && sudo apt-get install -y netcat
    fi
    nc -z localhost ${MYSQL_PORT:-3306} || return 1
    return 0
}

# .env 文件检查函数
check_env() {
    if grep -q "127.0.0.1" .env; then
        echo -e "${RED}检测到 .env 文件中的 MYSQL_HOST 或 DOMAIN 包含 127.0.0.1，请先修改为正确的 IP 地址。${NC}"
        read -p "按回车键返回菜单..."
        return 1
    fi
    return 0
}

# 通用函数
manage_service() {
    local action=$1
    local service=$2

    case $action in
        start)
            if docker-compose ps -q ${service} &>/dev/null; then
                echo -e "${YELLOW}${service} 容器已经启动。${NC}"
                docker-compose logs --tail 300 -f ${service}
            else
                echo -e "${GREEN}启动 ${service} 容器...${NC}"
                docker-compose up -d ${service}
                echo -e "${GREEN}${service} 容器已启动。${NC}"
                docker-compose logs --tail 300 -f ${service}
            fi
            ;;
        stop)
            if ! docker-compose ps -q ${service} &>/dev/null; then
                echo -e "${YELLOW}${service} 容器已经停止。${NC}"
            else
                echo -e "${GREEN}停止 ${service} 容器...${NC}"
                docker-compose stop ${service}
                echo -e "${GREEN}${service} 容器已停止。${NC}"
            fi
            ;;
        restart)
            echo -e "${GREEN}重启 ${service} 容器...${NC}"
            docker-compose restart ${service}
            ;;
        pull)
            echo -e "${GREEN}拉取最新的 ${service} 镜像...${NC}"
            docker-compose pull ${service}
            docker-compose up -d --force-recreate ${service}
            docker image prune -f
            docker-compose logs --tail 300 -f ${service}
            ;;
        log)
            echo -e "${GREEN}查看 ${service} 容器日志...${NC}"
            docker-compose logs --tail 300 -f ${service}
            ;;
        *)
            echo -e "${RED}无效操作: ${action}${NC}"
            ;;
    esac
}

download_compose() {
    echo -e "${GREEN}从URL获取docker-compose.yml文件...${NC}"
    curl -o docker-compose.yml ${COMPOSE_URL}
    curl -o .env ${ENV_URL}
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}docker-compose.yml和.env文件下载成功，请修改.env配置文件内的信息。${NC}"
    else
        echo -e "${RED}docker-compose.yml和.env文件下载失败，请检查URL是否正确。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi
    read -p "按回车键返回菜单..."
}

install_mysql() {
    if [ ! -f docker-compose.yml ] || [ ! -f .env ]; then
        echo -e "${RED}未找到必要文件，请先下载docker-compose.yml和.env文件。${NC}"
        read -p "按回车键返回菜单..."
        return
    }
    
    check_env || return
    
    echo -e "${YELLOW}此选项将安装MySQL${NC}"
    read -p "是否继续？ (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo -e "${YELLOW}安装已取消。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi

    load_env

    echo -e "${GREEN}开始安装 MySQL 容器...${NC}"
    docker-compose up -d mysql
    if [ $? -ne 0 ]; then
        echo -e "${RED}MySQL 容器安装过程中发生错误，请检查docker-compose.yml文件是否正确。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi

    echo -e "${YELLOW}等待 MySQL 容器启动...${NC}"
    for i in {1..30}; do
        if check_mysql_port; then
            echo -e "${GREEN}MySQL 容器已成功启动。${NC}"
            break
        fi
        if [ $i -eq 30 ]; then
            echo -e "${RED}MySQL 容器启动超时，请检查日志。${NC}"
            read -p "按回车键返回菜单..."
            return
        fi
        echo -n "."
        sleep 1
    done

    echo -e "${GREEN}MySQL 容器安装并启动成功。${NC}"
    read -p "按回车键返回菜单..."
}

install_and_start_all() {
    if [ ! -f .env ]; then
        echo -e "${RED}未找到.env文件，请先下载文件。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi
    
    check_env || return
    load_env
    
    echo -e "${YELLOW}此选项将安装并启动nginx, owl_admin, owl_web${NC}"
    read -p "是否继续？ (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo -e "${YELLOW}安装已取消。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi

    check_mysql_port || {
        echo -e "${RED}MySQL 端口未开放，请检查配置。${NC}"
        read -p "按回车键返回菜单..."
        return
    }

    services=("owl_admin" "owl_web" "nginx")
    for service in "${services[@]}"; do
         docker-compose up -d ${service}
    done
    
    echo -e "${GREEN}所有容器已启动。${NC}"
    manage_service log owl_admin
}

install_docker() {
    echo -e "${YELLOW}此选项将安装docker，docker-compose${NC}"

    echo -e "${GREEN}检查并安装Docker和Docker Compose...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${GREEN}安装Docker...${NC}"
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release
        curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        sudo systemctl start docker
        sudo systemctl enable docker
        echo -e "${YELLOW}Docker安装完毕。${NC}"
    else
        echo -e "${YELLOW}Docker 已经安装。${NC}"
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo -e "${GREEN}安装Docker Compose...${NC}"
        sudo apt-get update
        sudo apt-get install -y python3-pip
        sudo pip3 install docker-compose
        echo -e "${YELLOW}Docker Compose安装完毕。${NC}"
    else
        echo -e "${YELLOW}Docker Compose 已经安装。${NC}"
    fi
}

# 显示菜单
show_menu() {
    echo -e ""
    echo -e "———————${GREEN}【安装】${NC}—————————"
    echo -e "${GREEN}  1.${NC} 下载 docker-compose.yml 和 .env 文件"
    echo -e "${GREEN}  2.${NC} 安装 Docker 和 Docker Compose"
    echo -e "${GREEN}  3.${NC} 安装 MySQL"
    echo -e "${GREEN}  4.${NC} 一键安装并启动"
    echo -e ""
    echo -e "———————${GREEN}【管理】${NC}—————————"
    echo -e "${GREEN}  5.${NC} 更新 admin 至最新版本"
    echo -e "${GREEN}  6.${NC} 更新 web 至最新版本"
    echo -e "${GREEN}  7.${NC} 启动所有服务"
    echo -e "${GREEN}  8.${NC} 停止所有服务"
    echo -e "${GREEN}  9.${NC} 重启所有服务"
    echo -e ""
    echo -e "———————${GREEN}【日志】${NC}—————————"
    echo -e "${GREEN} 10.${NC} 查看 admin 日志"
    echo -e "${GREEN} 11.${NC} 查看 web 日志"
    echo -e "${GREEN} 12.${NC} 查看 mysql 日志"
    echo -e "${GREEN} 13.${NC} 查看 nginx 日志"
    echo -e "———————————————————"
    echo -e "${GREEN}  0.${YELLOW} 退出${NC}"
}

# 主程序逻辑
while true; do
    StartTitle
    show_menu
    read -p "输入选项 [0-13]: " choice
    case "$choice" in
        1) download_compose ;;
        2) install_docker ;;
        3) install_mysql ;;
        4) install_and_start_all ;;
        5) manage_service pull owl_admin ;;
        6) manage_service pull owl_web ;;
        7) docker-compose up -d ;;
        8) docker-compose down ;;
        9) docker-compose restart ;;
        10) manage_service log owl_admin ;;
        11) manage_service log owl_web ;;
        12) manage_service log mysql ;;
        13) manage_service log nginx ;;
        0)
            echo "退出脚本。"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选项，请重新输入。${NC}"
            ;;
    esac
done
