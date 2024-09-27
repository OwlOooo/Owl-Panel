# Owl-Panel

**猫头鹰订阅管理面板**

Owl-Panel 是一个用于管理代理节点的面板，后端对接3x-ui面板，支持3x-ui面板所有协议，让您轻松地管理和订阅各种节点。


#### 联系方式

TG交流群：[点击这里](https://t.me/+BRD15JUPyhxhZDFh)

#### 支持系统定制

联系：@Owl_8888

#### 支持系统

- **Centos 7.6+**
- **Debian 11+**
- **Ubuntu**
- **内存至少2G**

#### 支持架构

- **amd64**
- **arm64**

  
#### 3X-UI

- **版本 v2.2.7+**

#### 安装步骤

1. 使用以下命令下载安装脚本：

   ```bash
   curl -sSL https://raw.githubusercontent.com/OwlOooo/owl-panel/main/install.sh -H "Cache-Control: no-cache, no-store, must-revalidate" -H "Pragma: no-cache" -H "Expires: 0" -o  install.sh && sh install.sh


#### 使用说明

- 安装完脚本后，在终端中输入 `owl` 即可打开操作菜单。

- 在菜单中选择序号 `1` 下载 `docker-compose.yml` 和 `.env` 文件。请注意，在下载完后，您需要修改 `.env` 文件中的信息，文件默认下载到 `/owl` 目录下。



  ```markdown
   mysql 换成mysql的地址
   MYSQL_HOST=127.0.0.1

   mysql用户名
   MYSQL_USERNAME=root

   mysql端口,记得开放端口
   MYSQL_PORT=8206

   mysql密码，请修改为复杂的密码
   MYSQL_ROOT_PASSWORD=123456

   mysql初始化数据库--无需更改
   MYSQL_DATABASE=nginx

   owl数据库
   OWL_DATABASE=owl_database

   owl后台管理端口
   ADMIN_PORT=8989

   owl客户端面板端口
   WEB_PORT=8281

   owl后台管理api地址,api url就是服务器IP加后台管理端口，如果后端换成域名后，改为域名，加了https后这里也要改
   API_URL=http://127.0.0.1:8989/api

#### 安装MySQL

- 在菜单中选择序号 `2` 安装MySQL，安装完后切记打开MySQL端口号,默认为`8206`。

#### 一键部署系统

- 在菜单中选择序号 `3` 一键安装并启动，会安装`owl_admin` `owl_web` `Nginx Proxy Manager`。

`owl_admin`是面板后端服务,端口默认为`8989`,默认账号密码为`admin`和`admin`

`owl_web`是面板客户端服务,端口默认为`8281`

`Nginx Proxy Manager`是反向代理可视化工具，默认端口为`81`,默认账号密码为`admin@example.com`和`changeme`

---

#### 3X-UI设置

- 一定要按照下图所示进行更改，其中`面板设置->常规-面板 url 根路径` 和 `面板设置->订阅设置->URI 路径`可自定义，会在猫头鹰面板上添加服务器时用到。
  
![image](https://github.com/OwlOooo/Owl-Panel/assets/171789662/008051cd-97f1-4b34-a60d-4bdf2e78f89e)

![image](https://github.com/OwlOooo/Owl-Panel/assets/171789662/0c78c8eb-46e0-4919-99bc-210b3551c288)

---

#### 后台截图
![image](https://github.com/OwlOooo/Owl-Panel/assets/171789662/046f71d9-eea4-4b74-8e5c-ac5136aa9aaa)
![image (1)](https://github.com/OwlOooo/Owl-Panel/assets/171789662/7388a032-3159-43f7-9461-a6ce90251ff4)
![image (2)](https://github.com/OwlOooo/Owl-Panel/assets/171789662/e1c06f54-424d-41e0-9f1e-24e3991825db)




#### 前台截图
![image (3)](https://github.com/OwlOooo/Owl-Panel/assets/171789662/a2246623-9eed-43e8-93b1-28eb4811e1f6)
![image (4)](https://github.com/OwlOooo/Owl-Panel/assets/171789662/08c5c763-59cc-4d63-8060-f7ebfa9d14df)
![image (5)](https://github.com/OwlOooo/Owl-Panel/assets/171789662/f251c6a7-b2b9-441a-b7ef-e1c6c7fe8aee)




