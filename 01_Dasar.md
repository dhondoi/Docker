---
# Instalasi
- download [docker](https://docs.docker.com/get-started/get-docker/) dan install
- cek apakah sudah terinstal dengan perintah
  ```cmd
  docker version
  ```
---
# Docker Registry
- tempat menyimpan Docker Image
- salah satunya adalah [Docker Hub](https://hub.docker.com/)
- Buat Akun. Done.
---
# Docker Image
- mirip installer aplikasi
- sebelum menjalankan aplikasi di Docker, miliki Docker Image.
- untuk melihat Docker Image dalam Docker Daemon
```bash
docker image ls
```
- Untuk download Docker Image dari Docker Registry, kita bisa gunakan perintah
```bash
docker image pull <namaimage>:<tag>
```
- Kita bisa mencari Docker Image yang ingin kita download di [Docker Hub](https://hub.docker.com/)
- contoh
```bash
docker image pull nginx:latest
```
- untuk menghapus image
```bash
docker image rm <namaimage>:<tag>
```
---
# Docker Container
- Docker Container mirip seperti aplikasi hasil Docker Image (Installer)
- membuat container
```bash
docker container create --name <nama-container> <nama-image>:<tag>
```
- Docker Image yang digunakan tidak bisa dihapus jika sudah dibuat Docker Containernya
```bash
# coba hapus image yang sebelumnya digunakan untuk membuat container 
docker image rm <namaimage>:<tag>
```
- saat Container sudah dibuat, tidak otomatis berjalan
- tidak bisa membuat container dengan nama yang sama dari image yang sama
- untuk melihat Container
```bash
docker container ls -a
```
- untuk menjalankan Container
```bash
docker container start <nama-container>
```
- untuk menghentikan Container
```bash
docker container stop <nama-container>
```
- untuk menghapus Container
```bash
docker container rm <nama-container>
```
---
# Container Log
- Untuk melihat log aplikasi di container kita, kita bisa menggunakan perintah
```bash
docker container logs <nama-container>
```
- Atau jika ingin melihat log secara realtime, kita bisa gunakan perintah
```bash
docker container logs -f <nama-container>
```
# Container Exec
- Saat kita membuat container, aplikasi yang terdapat di dalam container hanya bisa diakses dari dalam container
- Untuk masuk ke dalam container, gunakan fitur Container Exec. digunakan untuk mengeksekusi kode program yang terdapat di dalam container
- mencoba mengeksekusi program bash script yang terdapat di dalam container dengan bantuan Container Exec
```bash
# misal mau buka bash
docker container exec -i -t <nama-container> bin/bash
```
