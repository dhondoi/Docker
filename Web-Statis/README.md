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
# Zona Rate Limiting (20 request/detik)
limit_req_zone $binary_remote_addr zone=one:10m rate=20r/s;

# Sembunyikan versi Nginx untuk keamanan
server_tokens off;

server {
    listen      80;
    listen      [::]:80;
    
    # Perbaikan: Hanya sertakan nama domain saja
    server_name <nama_domain>;

    # Sembunyikan header X-Powered-By
    fastcgi_hide_header X-Powered-By;

    location / {
        limit_req zone=one burst=30 nodelay;
        limit_req_status 429;
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    # Halaman error 50x
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```
