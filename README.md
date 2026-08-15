Berikut adalah *cheatsheet* perintah (command) Docker yang disusun secara bertahap dari tingkat dasar hingga manajemen tingkat lanjut.

---

### Tahap 1: Perintah Dasar & Informasi Sistem

Digunakan untuk memeriksa status instalasi, versi, dan informasi sistem Docker.

```bash
docker version           # Menampilkan versi Docker Client & Server
docker info              # Menampilkan detail konfigurasi & statistik sistem
docker help              # Menampilkan bantuan command Docker

```

---

### Tahap 2: Manajemen Container (Basic Lifecycle)

Perintah untuk membuat, menjalankan, menghentikan, dan melihat status container.

```bash
docker run -d --name <nama_container> -p <port_host>:<port_container> <nama_image>
                         # Menjalankan container di background (detached) dengan port mapping

docker ps                # Menampilkan daftar container yang sedang berjalan
docker ps -a             # Menampilkan semua container (termasuk yang mati/stopped)

docker stop <container>  # Menghentikan container secara halus (SIGTERM)
docker start <container> # Menjalankan kembali container yang terhenti
docker restart <container> # Merestart container
docker rm <container>    # Menghapus container yang terhenti
docker rm -f <container> # Menghapus container secara paksa (walau sedang berjalan)

```

---

### Tahap 3: Debugging & Monitoring

Digunakan untuk melihat log, masuk ke dalam container, dan memantau penggunaan resource.

```bash
docker logs <container>          # Menampilkan log dari container
docker logs -f <container>       # Menampilkan log secara real-time (follow)

docker exec -it <container> bash # Masuk ke dalam terminal container (menggunakan bash)
docker exec -it <container> sh   # Masuk ke dalam terminal container (menggunakan sh)

docker stats                     # Memantau penggunaan CPU, Memory, dan Network secara real-time
docker top <container>           # Melihat proses yang sedang berjalan di dalam container
docker inspect <container>       # Menampilkan konfigurasi & detail lengkap container (JSON)

```

---

### Tahap 4: Manajemen Image

Perintah untuk mengunduh, membuat, melihat, dan menghapus Docker Image.

```bash
docker images                    # Menampilkan daftar image lokal
docker pull <nama_image>         # Mengunduh image dari Docker Hub
docker build -t <nama_image>:<tag> . 
                                 # Membangun image dari Dockerfile di direktori saat ini
docker rmi <nama_image>          # Menghapus image dari lokal
docker tag <image_lama> <image_baru>:<tag> 
                                 # Membuat tag baru untuk image
docker push <nama_image>:<tag>   # Mengunggah image ke registry (Docker Hub)

```

---

### Tahap 5: Manajemen Network & Volume (Data Persistence)

Digunakan untuk mengatur konektivitas antar-container dan penyimpanan data permanen.

**Docker Volume:**

```bash
docker volume ls                 # Menampilkan daftar volume
docker volume create <nama_vol>  # Membuat volume baru
docker volume inspect <nama_vol> # Melihat rincian volume
docker volume rm <nama_vol>      # Menghapus volume

```

**Docker Network:**

```bash
docker network ls                # Menampilkan daftar network
docker network create <nama_net> # Membuat network kustom (bridge)
docker network connect <net> <container> # Menghubungkan container ke network
docker network inspect <nama_net> # Melihat detail IP dan container pada network

```

---

### Tahap 6: Pembersihan Sistem (Prune)

Digunakan untuk menghemat kapasitas disk dengan menghapus resource yang tidak terpakai.

```bash
docker container prune   # Menghapus semua container yang terhenti
docker image prune       # Menghapus image yang tidak bertag (dangling images)
docker volume prune      # Menghapus volume yang tidak digunakan container mana pun
docker network prune     # Menghapus network yang tidak digunakan
docker system prune -a   # Menghapus SEMUA container mati, image tak terpakai, dan network (Hati-hati!)

```

# Docker Cheatsheet Command

```bash

# mengambil image tertentu (pull) jika belum ada. membuat dan menjalankan container dengan nama tertentu
docker run --name <nama_container> -d -p <port_keluar>:<port_dalam> <nama_image>:<tag>

# mengambil image tertentu
docker pull <nama_image>:<tag>

# melihat image
docker image ls
docker images

# melihat layer image tertentu
docker image history [--no-trunc] <nama_image> 

# membuat image
docker build -t <username>/<repositoryname>:<tag> <path_dockerfile>

# jika lupa tambah tag
docker tag <username>/<repositoryname> <username>/<repositoryname>:<tag>

# push ke docker hub
docker push <username>/<repositoryname>:<tag>

# membuat dan menjalankan container
docker run --name <name_container> -ti <nama_image>
# -ti adalah mode interaktif dan tty

# save changes was made to another image
docker container commit -m "<message>" <name_container> <new_name_container>
docker container commit -c "<Intruction <argument>>" -m "<message>" app-container sample-app
# -c <Intruction <argument>> : apply dockerfile instruction, -m <message> : commit message

# menghapus container
docker rm -f <name_container>

# docker compose
# membuat/mengambil image ,membuat dan menjalankan container dengan nama tertentu
# note : terminal harus berada pada direktori project
docker compose up -d --build
# hentikan dan hapus container dan network
docker compose down
# hentikan dan hapus container, network, dan volume
docker compose down --volumes

```
