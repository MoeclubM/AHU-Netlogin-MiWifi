#!/bin/ash

# 获取当前 eth0.1 接口的 IP 地址
WLAN_USER_IP=$(ifconfig eth0.1 | grep "inet " | awk '{print $2}' | sed 's/addr://')

# 获取 eth0.1 接口的 MAC 地址并去除冒号
WLAN_USER_MAC=$(ifconfig eth0.1 | grep "HWaddr" | awk '{print $5}' | sed 's/://g')

# 打印获取到的 IP 和 MAC 地址
echo "WLAN User IP: $WLAN_USER_IP"
echo "WLAN User MAC: $WLAN_USER_MAC"

# 登出请求的URL
LOGOUT_URL="http://172.16.253.3:801/eportal/?c=Portal&a=logout&callback=dr1004&login_method=1&user_account=drcom&user_password=123&ac_logout=0&register_mode=1&wlan_user_ip=$WLAN_USER_IP&wlan_user_ipv6=&wlan_vlan_id=0&wlan_user_mac=000000000000&wlan_ac_ip=172.16.253.1&wlan_ac_name=&jsVersion=3.3.2&v=3484"

# 打印构造的登出URL
echo "Logout URL: $LOGOUT_URL"

# 发送GET请求进行登出
RESPONSE=$(wget -qO- "$LOGOUT_URL")

# 打印服务器响应
echo "Response: $RESPONSE"

# 解析返回结果
if echo "$RESPONSE" | grep -q "result\":1"; then
    echo "Logout successful"
else
    echo "Logout failed"
fi