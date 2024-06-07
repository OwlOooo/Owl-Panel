#!/bin/bash

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color
COMPOSE_URL='https://raw.githubusercontent.com/OwlOooo/owl-panel/main/docker-compose.yml'
ENV_URL='https://raw.githubusercontent.com/OwlOooo/owl-panel/main/.env'

# 标题函数
StartTitle() {
    echo -e '  \033[0;1;36;96m欢迎使用猫头鹰订阅管理面板一键脚本\033[0m'
}

# 读取 .env 文件
load_env() {
    if [ ! -f .env ]; then
        echo -e "${RED}.env 文件不存在，请先下载 .env 文件。${NC}"
        return 1
    fi
    export $(grep -v '^#' .env | xargs)
}

# 端口检测函数
check_ports() {
    local ports=("$@")
    if ! command -v nc &> /dev/null; then
        echo -e "${GREEN}安装 nc...${NC}"
        sudo yum -y install nc
    fi
    for port in "${ports[@]}"; do
        if ! nc -zv "${SERVER_IP}" "$port" &>/dev/null; then
            echo -e "${RED}端口 $port 未开放，请先开放端口。${NC}"
            return 1
        fi
    done
    return 0
}

# 检测 MySQL 端口
check_mysql_port() {
    if ! nc -zv "${MYSQL_HOST}" "${MYSQL_PORT}" &>/dev/null; then
        echo -e "${RED}MySQL 地址 ${MYSQL_HOST}:${MYSQL_PORT} 未开放，请先开放端口。${NC}"
        return 1
    fi
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
            if [ "$(docker inspect -f '{{.State.Running}}' ${service})" == "true" ]; then
                echo -e "${YELLOW}${service} 容器已经启动。${NC}"
            else
                echo -e "${GREEN}启动 ${service} 容器...${NC}"
                docker-compose start ${service}
                echo -e "${GREEN}${service} 容器已启动。${NC}"
            fi
            ;;
        stop)
            if [ "$(docker inspect -f '{{.State.Running}}' ${service})" == "false" ]; then
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
            docker-compose stop ${service}
            docker-compose rm -f ${service}
            docker-compose up -d ${service}
            docker images -f "dangling=true" -q | xargs -r docker rmi
            docker volume prune -f
            docker logs -f ${service}
            ;;
        log)
            echo -e "${GREEN}查看 ${service} 容器日志...${NC}"
            docker logs -f ${service}
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
        echo -e "${GREEN}docker-compose.yml和env文件下载成功，请修改.env配置文件内的信息。${NC}"
    else
        echo -e "${RED}docker-compose.yml和env文件下载失败，请检查URL是否正确。${NC}"
        read -p "按回车键返回菜单..."
        exit 1
    fi
    read -p "按回车键返回菜单..."
}

install_mysql() {
    if [ ! -f docker-compose.yml ]; then
        echo -e "${RED}未找到docker-compose.yml文件，请先下载文件。${NC}"
        read -p "按回车键返回菜单..."
        exit 1
    fi
    
    if [ ! -f .env ]; then
        echo -e "${RED}未找到env文件，请先下载文件。${NC}"
        read -p "按回车键返回菜单..."
        exit 1
    fi
    
    check_env || exit 1
    
    echo -e "${YELLOW}此选项将安装MySQL${NC}"
    read -p "是否继续？ (Y/N): " confirm
    if [ "$confirm" != "Y" ]; then
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
        exit 1
    fi

    sleep 10 # 等待 MySQL 容器完全启动

    check_mysql_port || {
        echo -e "${RED}MySQL 端口未开放，请检查配置。${NC}"
        read -p "按回车键返回菜单..."
        exit 1
    }

    echo -e "${GREEN}MySQL 容器安装并启动成功。${NC}"
    read -p "按回车键返回菜单..."
}

install_and_start_all() {
    if [ ! -f .env ]; then
        echo -e "${RED}未找到env文件，请先下载文件。${NC}"
        read -p "按回车键返回菜单..."
        exit 1
    fi
    
    check_env || exit 1
    load_env
    
    echo -e "${YELLOW}此选项将安装并启动nginx，mysql，owl_admin, owl_web${NC}"
    read -p "是否继续？ (Y/N): " confirm
    if [ "$confirm" != "Y" ]; then
        echo -e "${YELLOW}安装已取消。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi

    check_mysql_port || {
        echo -e "${RED}MySQL 端口未开放，请检查配置。${NC}"
        read -p "按回车键返回菜单..."
        exit 1
    }

    services=("owl_admin" "owl_web" "nginx")
    for service in "${services[@]}"; do
        manage_service start ${service}
    done
    
    echo -e "${GREEN}所有容器已启动。${NC}"
    read -p "按回车键返回菜单..."
}

# 显示菜单
show_menu() {
    echo -e ""
    echo -e "———————${GREEN}【安装】${NC}—————————"
    echo -e "${GREEN}  1.${NC} 下载 docker-compose.yml 和 env 文件"
    echo -e "${GREEN}  2.${NC} 安装 MySQL"
    echo -e "${GREEN}  3.${NC} 一键安装并启动"
    echo -e ""
    echo -e "———————${GREEN}【admin】${NC}—————————"
    echo -e "${GREEN}  4.${NC} 更新至最新版本"
    echo -e "${GREEN}  5.${NC} 启动 admin"
    echo -e "${GREEN}  6.${NC} 停止 admin"
    echo -e "${GREEN}  7.${NC} 重启 admin"
    echo -e "${GREEN}  8.${NC} 查看 admin 日志"
    echo -e ""
    echo -e "———————${GREEN}【web】${NC}—————————"
    echo -e "${GREEN}  9.${NC} 更新至最新版本"
    echo -e "${GREEN} 10.${NC} 启动 web"
    echo -e "${GREEN} 11.${NC} 停止 web"
    echo -e "${GREEN} 12.${NC} 重启 web"
    echo -e "${GREEN} 13.${NC} 查看 web 日志"
    echo -e ""
    echo -e "———————${GREEN}【mysql】${NC}—————————"
    echo -e "${GREEN} 14.${NC} 启动 mysql"
    echo -e "${GREEN} 15.${NC} 停止 mysql"
    echo -e "${GREEN} 16.${NC} 重启 mysql"
    echo -e "${GREEN} 17.${NC} 查看 mysql 日志"
    echo -e ""
    echo -e "———————${GREEN}【nginx】${NC}—————————"
    echo -e "${GREEN} 18.${NC} 启动 nginx"
    echo -e "${GREEN} 19.${NC} 停止 nginx"
    echo -e "${GREEN} 20.${NC} 重启 nginx"
    echo -e "${GREEN} 21.${NC} 查看 nginx 日志"
    echo -e "———————————————————"
    echo -e "${GREEN}  0.${YELLOW} 退出${NC}"
}

# 主程序逻辑
while true; do
    StartTitle
    show_menu
    read -p "输入选项 [0-21]: " choice
    case "$choice" in
        1)
            download_compose
            ;;
        2)
            install_mysql
            ;;
        3)
            install_and_start_all
            ;;
        4)
            manage_service pull owl_admin
            ;;
        5)
            manage_service start owl_admin
            ;;
        6)
            manage_service stop owl_admin
            ;;
        7)
            manage_service restart owl_admin
            ;;
        8)
            manage_service log owl_admin
            ;;
        9)
            manage_service pull owl_web
            ;;
        10)
            manage_service start owl_web
            ;;
        11)
            manage_service stop owl_web
            ;;
        12)
            manage_service restart owl_web
            ;;
        13)
            manage_service log owl_web
            ;;
        14)
            manage_service start mysql
            ;;
        15)
            manage_service stop mysql
            ;;
        16)
            manage_service restart mysql
            ;;
        17)
            manage_service log mysql
            ;;
        18)
            manage_service start nginx
            ;;
        19)
            manage_service stop nginx
            ;;
        20)
            manage_service restart nginx
            ;;
        21)
            manage_service log nginx
            ;;
        0)
            echo "退出脚本。"
            exit 0
            ;;
        *)
            echo -e "${RED}无效选项，请重新输入。${NC}"
            ;;
    esac
done
