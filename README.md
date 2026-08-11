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
