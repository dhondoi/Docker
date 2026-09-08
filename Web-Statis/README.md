## DOCKERFILE

```Dockerfile
# Gunakan image resmi Nginx yang ringan (Alpine Linux)
FROM nginx:latest-slim

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
```

## DOCKER COMPOSE

```yaml
services:
  web:
    build: .
    container_name: contactumkm-app
    ports:
      - "80:80"
    restart: unless-stopped
```
