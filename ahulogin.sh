#!/bin/ash

# 启动前等待 8 秒确保正常获取ip地址
sleep 8

# 配置账号和密码
    USER_ACCOUNT="账号"
    USER_PASSWORD="密码"

    # 获取当前 eth0.1 接口的 IP 地址
    WLAN_USER_IP=$(ifconfig eth1 | grep "inet " | awk '{print $2}' | sed 's/addr://')

    # 获取 eth0.1 接口的 MAC 地址并去除冒号
    WLAN_USER_MAC=$(ifconfig eth1 | grep "HWaddr" | awk '{print $5}' | sed 's/://g')

    # URL 编码函数
    urlencode() {
        # 将字符串转换为 URL 编码
        local STRING="$1"
        local ENCODED=""
        local CHAR
        local HEX
        local i

        # 使用 while 循环替代 for 循环
        i=0
        while [ $i -lt ${#STRING} ]; do
            CHAR="${STRING:$i:1}"
            case "$CHAR" in
                [a-zA-Z0-9._~-]) ENCODED="$ENCODED$CHAR" ;;  # 拼接字符
                *) HEX=$(printf '%02X' "'$CHAR") && ENCODED="$ENCODED%$HEX" ;;  # 拼接编码字符
            esac
            i=$((i + 1))
        done
        echo "$ENCODED"
    }

    # 对密码进行URL编码
    URL_ENCODED_PASSWORD=$(urlencode "$USER_PASSWORD")

    # 打印获取到的 IP 和 MAC 地址
    echo "WLAN User IP: $WLAN_USER_IP"
    echo "WLAN User MAC: $WLAN_USER_MAC"

    # 登录请求的URL
    LOGIN_URL="http://172.16.253.3:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=$USER_ACCOUNT&user_password=$URL_ENCODED_PASSWORD&wlan_user_ip=$WLAN_USER_IP&wlan_user_ipv6=&wlan_user_mac=$WLAN_USER_MAC&wlan_ac_ip=172.16.253.1&wlan_ac_name=&jsVersion=3.3.2&v=4946"

    # 打印构造的登录URL
    echo "Login URL: $LOGIN_URL"

    # 发送GET请求进行登录
    RESPONSE=$(wget -qO- "$LOGIN_URL")

    # 打印服务器响应
    echo "Response: $RESPONSE"

    # 解析返回结果
    if echo "$RESPONSE" | grep -q "ret_code\":2"; then
        echo "Already logged in"
    elif echo "$RESPONSE" | grep -q "result\":1"; then
        echo "Login successful"
    else
        echo "Login failed"
    fi

    # 掉线检测循环
    while true; do
        # 检测到无法 ping 通外部网络
        if ! ping -c 3 -w 3 223.5.5.5 >/dev/null 2>&1; then
            echo "Network disconnected, attempting to log in..."
            # 重新获取 IP 和 MAC 地址
            WLAN_USER_IP=$(ifconfig eth1 | grep "inet " | awk '{print $2}' | sed 's/addr://')
            WLAN_USER_MAC=$(ifconfig eth1 | grep "HWaddr" | awk '{print $5}' | sed 's/://g')
            # 构造登录 URL
            LOGIN_URL="http://172.16.253.3:801/eportal/?c=Portal&a=login&callback=dr1003&login_method=1&user_account=$USER_ACCOUNT&user_password=$URL_ENCODED_PASSWORD&wlan_user_ip=$WLAN_USER_IP&wlan_user_ipv6=&wlan_user_mac=$WLAN_USER_MAC&wlan_ac_ip=172.16.253.1&wlan_ac_name=&jsVersion=3.3.2&v=4946"
            # 发送GET请求进行登录
            RESPONSE=$(wget -qO- "$LOGIN_URL")
            # 打印服务器响应
            echo "Response: $RESPONSE"
            # 检查登录结果
            if echo "$RESPONSE" | grep -q "result\":1"; then
                echo "Login successful"
            else
                echo "Login failed"
            fi
            # 每次请求后等待5秒
            sleep 5
        fi
        echo "Alive"
        # 每隔 3 秒检查一次网络连接状态
        sleep 3
    done