# Owl-Panel

**猫头鹰订阅管理面板**

Owl-Panel 是一个用于管理订阅的面板，让您轻松地管理和订阅各种资源。

#### 安装步骤

1. 使用以下命令下载安装脚本：

   ```bash
   curl -sSL https://raw.githubusercontent.com/OwlOooo/owl-panel/main/install.sh -o install.sh && sh install.sh

#### 支持系统

- **Centos 7.6+**
- **内存至少2G**
  
#### 3X-UI

- **版本 v2.2.7+**


#### 使用说明

- 安装完脚本后，在终端中输入 `owl` 即可打开操作菜单。

- 在菜单中选择序号 `1` 下载 `docker-compose.yml` 和 `.env` 文件。请注意，在下载完后，您需要修改 `.env` 文件中的信息。



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

#### 安装MySQL

- 在菜单中选择序号 `2` 安装MySQL，安装完后切记打开MySQL端口号,默认为`8206`。

#### 一键部署系统

- 在菜单中选择序号 `3` 一键安装并启动，会安装`owl_admin` `owl_web` `Nginx Proxy Manager`。

`owl_admin`是面板后端服务,端口默认为`8989`

`owl_web`是面板客户端服务,端口默认为`8281`

`Nginx Proxy Manager`是反向代理可视化工具，默认端口为`81`,默认账号密码为`admin@example.com`和`changeme`

---

#### 3X-UI设置

- 一定要按照下图所示进行更改，其中面板设置->常规-面板 url 根路径 和 面板设置->订阅设置->URI 路径可自定义，会在猫头鹰面板上添加服务器时用到。
  
![image](https://github.com/OwlOooo/Owl-Panel/assets/171789662/008051cd-97f1-4b34-a60d-4bdf2e78f89e)

![image](https://github.com/OwlOooo/Owl-Panel/assets/171789662/0c78c8eb-46e0-4919-99bc-210b3551c288)


#### 版本对比说明

| 功能                | 社区版           | VIP版          |
|--------------------|-----------------|----------------|
| 用户数量            | 5               | 不限            |
| 服务器数量          | 3               | 不限            |
| 中转节点数量        | 3               | 不限            |
| 产品数量            | 2               | 不限            |
| 自定义站点名称      | 不可以           | 可以            |
| 技术支持            | 无               | 7*24小时        |
| 价格            | 免费               | 联系客服咨询 |


#### 联系方式

Tg：https://t.me/+BRD15JUPyhxhZDFh
