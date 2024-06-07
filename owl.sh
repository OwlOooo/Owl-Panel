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

# 函数定义
pull_admin() {
    echo -e "${GREEN}拉取最新的 owl_admin 镜像...${NC}"
    docker-compose pull owl_admin
    docker-compose stop owl_admin
    docker-compose rm -f owl_admin
    docker-compose up -d owl_admin
    docker images -f "dangling=true" -q | xargs -r docker rmi
    docker volume prune -f
    docker logs -f owl_admin
}

pull_web() {
    echo -e "${GREEN}拉取最新的 owl_web 镜像...${NC}"
    docker-compose pull owl_web
    docker-compose stop owl_web
    docker-compose rm -f owl_web
    docker-compose up -d owl_web
    docker images -f "dangling=true" -q | xargs -r docker rmi
    docker volume prune -f
    docker logs -f owl_web
}

restart_admin() {
    echo -e "${GREEN}重启 owl_admin 容器...${NC}"
    docker-compose restart owl_admin
}

restart_web() {
    echo -e "${GREEN}重启 owl_web 容器...${NC}"
    docker-compose restart owl_web
}

restart_mysql() {
    echo -e "${GREEN}重启 mysql 容器...${NC}"
    docker-compose restart mysql
}

restart_nginx() {
    echo -e "${GREEN}重启 nginx 容器...${NC}"
    docker-compose restart nginx
}

stop_admin() {
    if [ "$(docker inspect -f '{{.State.Running}}' owl_admin)" == "false" ]; then
        echo -e "${YELLOW}容器已经停止。${NC}"
    else
        echo -e "${GREEN}停止 owl_admin 容器...${NC}"
        docker-compose stop owl_admin
        echo -e "${GREEN}容器已停止。${NC}"
    fi
}

stop_web() {
    if [ "$(docker inspect -f '{{.State.Running}}' owl_web)" == "false" ]; then
        echo -e "${YELLOW}容器已经停止。${NC}"
    else
        echo -e "${GREEN}停止 owl_web 容器...${NC}"
        docker-compose stop owl_web
        echo -e "${GREEN}容器已停止。${NC}"
    fi
}

stop_mysql() {
    if [ "$(docker inspect -f '{{.State.Running}}' mysql)" == "false" ]; then
        echo -e "${YELLOW}容器已经停止。${NC}"
    else
        echo -e "${GREEN}停止 mysql 容器...${NC}"
        docker-compose stop mysql
        echo -e "${GREEN}容器已停止。${NC}"
    fi
}

stop_nginx() {
    if [ "$(docker inspect -f '{{.State.Running}}' nginx)" == "false" ]; then
        echo -e "${YELLOW}容器已经停止。${NC}"
    else
        echo -e "${GREEN}停止 nginx 容器...${NC}"
        docker-compose stop nginx
        echo -e "${GREEN}容器已停止。${NC}"
    fi
}

start_admin() {
    if [ "$(docker inspect -f '{{.State.Running}}' owl_admin)" == "true" ]; then
        echo -e "${YELLOW}容器已经启动。${NC}"
    else
        echo -e "${GREEN}启动 owl_admin 容器...${NC}"
        docker-compose start owl_admin
        echo -e "${GREEN}容器已启动。${NC}"
    fi
}

start_web() {
    if [ "$(docker inspect -f '{{.State.Running}}' owl_web)" == "true" ]; then
        echo -e "${YELLOW}容器已经启动。${NC}"
    else
        echo -e "${GREEN}启动 owl_web 容器...${NC}"
        docker-compose start owl_web
        echo -e "${GREEN}容器已启动。${NC}"
    fi
}

start_mysql() {
    if [ "$(docker inspect -f '{{.State.Running}}' mysql)" == "true" ]; then
        echo -e "${YELLOW}容器已经启动。${NC}"
    else
        echo -e "${GREEN}启动 mysql 容器...${NC}"
        docker-compose start mysql
        echo -e "${GREEN}容器已启动。${NC}"
    fi
}

start_nginx() {
    if [ "$(docker inspect -f '{{.State.Running}}' nginx)" == "true" ]; then
        echo -e "${YELLOW}容器已经启动。${NC}"
    else
        echo -e "${GREEN}启动 nginx 容器...${NC}"
        docker-compose start nginx
        echo -e "${GREEN}容器已启动。${NC}"
    fi
}

log_admin() {
    echo -e "${GREEN}查看 owl_admin 容器日志...${NC}"
    docker logs -f owl_admin
}

log_web() {
    echo -e "${GREEN}查看 owl_web 容器日志...${NC}"
    docker logs -f owl_web
}

log_mysql() {
    echo -e "${GREEN}查看 mysql 容器日志...${NC}"
    docker logs -f mysql
}

log_nginx() {
    echo -e "${GREEN}查看 nginx 容器日志...${NC}"
    docker logs -f nginx
}

download_compose() {
    echo -e "${GREEN}从URL获取docker-compose.yml文件...${NC}"
    curl -o docker-compose.yml ${COMPOSE_URL}
    curl -o .env ${ENV_URL}
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}docker-compose.yml和env文件下载成功，请修改.env配置文件内的信息。${NC}"
    else
        echo -e "${RED}docker-compose.yml和env文件下载失败，请检查URL是否正确。${NC}"
    fi
    read -p "按回车键返回菜单..."
}

install_all() {
    if [ ! -f docker-compose.yml ]; then
        echo -e "${RED}未找到docker-compose.yml文件，请先下载文件。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi
    
    if [ ! -f .env ]; then
        echo -e "${RED}未找到env文件，请先下载文件。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi
    
    echo -e "${YELLOW}此选项将安装docker，docker-compose，nginx，mysql，owl_admin, owl_web${NC}"
    read -p "是否继续？ (Y/N): " confirm
    if [ "$confirm" != "Y" ]; then
        echo -e "${YELLOW}安装已取消。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi

    echo -e "${GREEN}检查并安装Docker和Docker Compose...${NC}"
    if ! command -v docker &> /dev/null; then
        echo -e "${GREEN}安装Docker...${NC}"
        # 更新系统并安装必要的软件包
        sudo yum update -y
        sudo yum install -y yum-utils

        # 设置Docker的仓库
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

        # 安装最新版本的 Docker CE
        sudo yum install -y docker-ce docker-ce-cli containerd.io

        # 启动 Docker 并设置开机自启
        sudo systemctl start docker
        sudo systemctl enable docker
    else
        echo -e "${YELLOW}Docker已安装。${NC}"
    fi

    if ! command -v docker-compose &> /dev/null; then
        echo -e "${GREEN}安装Docker Compose...${NC}"
        # 获取最新版本的 Docker Compose
        DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

        # 下载最新版本的 Docker Compose
        sudo curl -L "https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

        # 赋予执行权限
        sudo chmod +x /usr/local/bin/docker-compose

        # 创建软链接（可选）
        sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
    else
        echo -e "${YELLOW}Docker Compose已安装。${NC}"
    fi

    echo -e "${GREEN}检测docker-compose.yml中的项目状态...${NC}"
    services=("nginx" "mysql" "owl_admin" "owl_web")
    for service in "${services[@]}"; do
        if [ "$(docker ps -a --filter "name=$service" --format '{{.Names}}')" == "$service" ]; then
            echo -e "${RED}服务 $service 已经存在，请先手动停止并删除容器后再使用一键安装。${NC}"
            read -p "按回车键返回菜单..."
            return
        fi
    done

    echo -e "${GREEN}开始一键安装...${NC}"
    docker-compose up -d
    if [ $? -ne 0 ]; then
        echo -e "${RED}一键安装过程中发生错误，请检查docker-compose.yml文件是否正确。${NC}"
        read -p "按回车键返回菜单..."
        return
    fi
    echo -e "${GREEN}一键安装完成。${NC}"
    read -p "按回车键返回菜单..."
}

# 显示菜单
show_menu() {
    echo -e ""
    echo -e "———————${GREEN}【安装】${NC}—————————"
    echo -e "${GREEN}  1.${NC} 下载 docker-compose.yml 和 env 文件"
    echo -e "${GREEN}  2.${NC} 一键安装"
     echo -e ""
    echo -e "———————${GREEN}【admin】${NC}—————————"
    echo -e "${GREEN}  3.${NC} 更新至admin最新版本"
    echo -e "${GREEN}  4.${NC} 启动 admin"
    echo -e "${GREEN}  5.${NC} 停止 admin"
    echo -e "${GREEN}  6.${NC} 重启 admin"
    echo -e "${GREEN}  7.${NC} 查看 admin 日志"
     echo -e ""
    echo -e "———————${GREEN}【web】${NC}—————————"
    echo -e "${GREEN}  8.${NC} 更新至web最新版本"
    echo -e "${GREEN}  9.${NC} 启动 web"
    echo -e "${GREEN} 10.${NC} 停止 web"
    echo -e "${GREEN} 11.${NC} 重启 web"
    echo -e "${GREEN} 12.${NC} 查看 web 日志"
     echo -e ""
    echo -e "———————${GREEN}【mysql】${NC}—————————"
    echo -e "${GREEN} 13.${NC} 启动 mysql"
    echo -e "${GREEN} 14.${NC} 停止 mysql"
    echo -e "${GREEN} 15.${NC} 重启 mysql"
    echo -e "${GREEN} 16.${NC} 查看 mysql 日志"
     echo -e ""
    echo -e "———————${GREEN}【nginx】${NC}—————————"
    echo -e "${GREEN} 17.${NC} 启动 nginx"
    echo -e "${GREEN} 18.${NC} 停止 nginx"
    echo -e "${GREEN} 19.${NC} 重启 nginx"
    echo -e "${GREEN} 20.${NC} 查看 nginx 日志"
   
    echo -e "———————————————————"
    echo -e "${GREEN}  0.${YELLOW} 退出${NC}"
}

# 主程序逻辑
while true; do
    StartTitle
    show_menu
    read -p "输入选项 [0-20]: " choice
    case "$choice" in
        1)
            download_compose
            ;;
        2)
            install_all
            ;;
        3)
            pull_admin
            ;;
        4)
            start_admin
            ;;
        5)
            stop_admin
            ;;
        6)
            restart_admin
            ;;
        7)
            log_admin
            ;;
        8)
            pull_web
            ;;
        9)
            start_web
            ;;
        10)
            stop_web
            ;;
        11)
            restart_web
            ;;
        12)
            log_web
            ;;
        13)
            start_mysql
            ;;
        14)
            stop_mysql
            ;;
        15)
            restart_mysql
            ;;
        16)
            log_mysql
            ;;
        17)
            start_nginx
            ;;
        18)
            stop_nginx
            ;;
        19)
            restart_nginx
            ;;
        20)
            log_nginx
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
