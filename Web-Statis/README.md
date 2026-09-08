## DOCKERFILE

```Dockerfile
# Gunakan image resmi Nginx yang ringan (Alpine Linux)
FROM nginx:latest-alpine-slim

# Hapus berkas bawaan Nginx
RUN rm -rf /usr/share/nginx/html/*

# Salin seluruh berkas situs web statis dari direktori lokal ke direktori Nginx
COPY . /usr/share/nginx/html

# Expose port 80 agar dapat diakses dari luar kontainer
EXPOSE 80

# Jalankan Nginx di foreground
CMD ["nginx", "-g", "daemon off;"]
```

## DOCKERIGNORE

```.dockerignore
# Mengabaikan berkas Docker sendiri
Dockerfile
docker-compose.yml
.dockerignore

# Mengabaikan Git
.git
.gitignore

# Mengabaikan folder dependency (jika menggunakan React/Vue/Svelte/Node)
node_modules
npm-debug.log

# Mengabaikan berkas dokumentasi & catatan internal
README.md
*.md
.DS_Store
.env*
default.conf
```

## DOCKER COMPOSE

```yaml
services:
  <nama_service>:
    build: .
    container_name: <nama_container>
    restart: unless-stopped
    ports:
      - "80:80"
    volumes:
      - ./default.conf:/etc/nginx/conf.d/default.conf
```

# DEFAULT.CONF

```conf
limit_req_zone $binary_remote_addr zone=one:10m rate=10r/m;
server_tokens off;

server {
    listen       80;
    listen  [::]:80;
    server_name <DOMAIN_KAMU>;

    limit_req zone=one burst=20 nodelay;
    fastcgi_hide_header X-Powered-By;

    #access_log  /var/log/nginx/host.access.log  main;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

    # proxy the PHP scripts to Apache listening on 127.0.0.1:80
    #
    #location ~ \.php$ {
    #    proxy_pass   http://127.0.0.1;
    #}

    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    #location ~ \.php$ {
    #    root           html;
    #    fastcgi_pass   127.0.0.1:9000;
    #    fastcgi_index  index.php;
    #    fastcgi_param  SCRIPT_FILENAME  /scripts$fastcgi_script_name;
    #    include        fastcgi_params;
    #}

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}
```
