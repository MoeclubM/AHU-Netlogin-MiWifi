# AHU-Netlogin-MiWifi
<p align="center">
<img src="https://github.com/MoeclubM/AHU-Netlogin-WinUI3/blob/main/Assets/logo.png?raw=true" width="200" alt="ahu"/>
</p>
<h2 align="center">AHU NET Client MiWifi</h2>
<h3 align="center">安徽大学(AHU)校园网 小米路由器自动登录脚本</h3>
<p align="center">
<img src="https://img.shields.io/github/v/release/MoeclubM/AHU-Netlogin-MiWifi" alt="">
<img src="https://img.shields.io/github/issues/MoeclubM/AHU-Netlogin-MiWifi?color=rgb%2877%20199%20166%29" alt="">
<img src="https://img.shields.io/github/downloads/MoeclubM/AHU-Netlogin-MiWifi/total?color=ea8f14&label=users" alt="">
<img src="https://img.shields.io/github/license/MoeclubM/AHU-Netlogin-MiWifi" alt="">
</p>

## Why 有线
实测龙河无线很多地方还是wifi4且均无ipv6 又因为ipv4限速，ipv6为校园网500m对等因此寝室下游戏只能这么整

## 文件格式
- ahulogin.sh 登录脚本，延迟8s执行
- ahulogout.sh 登出脚本
- startup_script.sh 通用创建开机自启项脚本(来源恩山 [链接](https://www.right.com.cn/forum/thread-8340357-1-1.html))

## 使用方式
### 1.上传脚本，设置开机自启动
将项目内所有.sh脚本文件上传到路由器/data/目录内，随后执行:
```
# 给脚本运行权限
chmod +x startup_script.sh
chmod +x ahulogin.sh
chmod +x ahulogout.sh
# 设置防火墙指定启动脚本
./startup_script.sh install
```
start_script.sh无需进行更改(如果你还要开机运行其他脚本可以在里面添加，不会的话可参考恩山原作者教程)

### 2.修改账号密码
修改ahulogin.sh内的校园网登录账号和密码为你自己的
可使用vi或者本地改好上传(小米路由器似乎没有nano)
### 3.测试脚本是否可用
路由器wan口连接至校园网(如果是自动检测/可自由配置/多wan的路由器请使用(或手动指定为)第一个口 如果无法正确获取接口信息请自行查看对应网口)
确认连接正确，路由器可正确获取ip地址后运行以下指令
```shell
/data/ahulogin.sh
```
如果成功获取信息并且等待一段时间后输出alive即代表登录成功(无视那个登录失败，懒得改)
登录成功后按ctrl+c退出脚本

### 4.路由器设置
在路由器后台(小米默认192.168.31.1)，点击常用设置->上网设置,第一个上网方式选择DHCP,选择手动配置dns,填写223.5.5.5和119.29.29.29打开下方ipv6设置，上网方式选择NAT6,防火墙关闭,手动配置DNS为2400:3200::1和2400:3200:baba::1 设置完记得保存

## 其他设备
由于本人没有其他路由器因此没法测试，只在小米路由器BE3600测试通过，不同型号配置方式也有所不同，部分老型号可能不支持ipv6
