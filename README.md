

### Owl-Panel

**猫头鹰订阅管理面板**

Owl-Panel 是一个用于管理订阅的面板，让您轻松地管理和订阅各种资源。

#### 安装步骤

1. 使用以下命令下载安装脚本：

   ```bash
   curl -sSL https://raw.githubusercontent.com/OwlOooo/owl-panel/main/install.sh -o install.sh && sh install.sh

#### 支持系统

- **Centos 7.6+**

#### 使用说明

- 安装完脚本后，在终端中输入 `owl` 即可打开操作菜单。

- 在菜单中选择序号1以下载 `docker-compose.yml` 和 `.env` 文件。请注意，在下载完后，您需要修改 `.env` 文件中的信息（红色字体标明）。



  ```markdown
  - 服务器IP，换成自己的服务器IP或者域名，如果加了SSL，改成https
   SERVER_IP=127.0.0.1

   mysql 换成mysql的地址
   MYSQL_HOST=127.0.0.1

   mysql用户名
   MYSQL_USERNAME=root

   mysql端口,记得开放端口
   MYSQL_PORT=8206

   mysql密码，请修改为复杂的密码
   MYSQL_ROOT_PASSWORD=123456

   mysql初始化数据库
   MYSQL_DATABASE=nginx

   owl数据库
   OWL_DATABASE=owl_database

   owl后台管理端口
   ADMIN_PORT=8989

   owl客户端面板端口
   WEB_PORT=8281

   owl后台管理api地址
   DOMAIN=http://${SERVER_IP}:${ADMIN_PORT}/api

 
