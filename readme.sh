1. 建立好数据库（使用 SQLite 则不用建立）并记好数据库用户名、数据库密码和数据库名
2. 执行
bash -c "$(curl -L https://github.com/dbr4fr/script/raw/main/vaultwarden-install.sh)"
3. Nginx 配置 SSL 和反向代理，反向代理示例配置如下：

#PROXY-START/
location /
{
    proxy_pass http://127.0.0.1:13080;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header REMOTE-HOST $remote_addr;
    add_header X-Cache $upstream_cache_status;
}

location /notifications/hub
{
    proxy_pass http://127.0.0.1:13012;
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection upgrade;
    proxy_set_header Host $host;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header REMOTE-HOST $remote_addr;
    add_header X-Cache $upstream_cache_status;
}

#PROXY-END/



其中，第 4 行的 13080 为 /etc/vaultwarden.env 中 ROCKET_PORT 的值；第 14 行的 13012 为 /etc/vaultwarden.env 中 WEBSOCKET_PORT 的值。

SSL (https) 一定要配置，不然不能用！

https://vaultwarden.example.com/admin 路径为管理页面，Admin Token 为 /etc/vaultwarden.env 中 ADMIN_TOKEN 的值，在安装时自动生成。

整好了就可以套 Cloudflare 之类的支持 WS 的 CDN 了

5. 更新
curl -L https://github.com/dbr4fr/script/raw/main/vaultwarden-update.sh，赋予执行权限后用 Crontab 设置每日执行一次即可。
