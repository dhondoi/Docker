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
docker container create --name <namacontainer> <namaimage>:<tag>
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
docker container start <namacontainer>
```
- untuk menghentikan Container
```bash
docker container stop <namacontainer>
```
- untuk menghapus Container
```bash
docker container rm <nama-container>
```
---
# Docker Container Log
- Untuk melihat log aplikasi di container kita, kita bisa menggunakan perintah
```bash
docker container logs <namacontainer>
```
- Atau jika ingin melihat log secara realtime, kita bisa gunakan perintah
```bash
docker container logs -f <namacontainer>
```
# Docker Container Exec
- Saat kita membuat container, aplikasi yang terdapat di dalam container hanya bisa diakses dari dalam container
- Untuk masuk ke dalam container, gunakan fitur Container Exec. digunakan untuk mengeksekusi kode program yang terdapat di dalam container
- mencoba mengeksekusi program bash script yang terdapat di dalam container dengan bantuan Container Exec
```bash
# misal mau buka bash
docker container exec -i -t <namacontainer> bin/bash
```
# Docker Container Port
- Artinya sistem Host (misal Laptop kita), tidak bisa mengakses aplikasi yang ada di dalam container secara langsung, salah satu caranya adalah harus menggunakan Container Exec untuk masuk ke dalam container nya.
- Docker memiliki kemampuan untuk melakukan port forwarding, yaitu meneruskan sebuah port yang terdapat di sistem Host nya ke dalam Docker Container
- Untuk melakukan port forwarding, kita bisa menggunakan perintah berikut ketika membuat container nya :
```bash
docker container create --name <namacontainer> --publish <posthost>:<portcontainer> <image>:<tag>
```
- Jika kita ingin melakukan port forwarding lebih dari satu, kita bisa tambahkan dua kali parameter --publish
# Docker Container Environment Variable
- Dengan menggunakan environment variable, kita bisa mengubah-ubah konfigurasi aplikasi, tanpa harus mengubah kode aplikasinya lagi
- Untuk menambah environment variable, kita bisa menggunakan perintah --env atau -e, misal :
```bash
docker container create --name <namacontainer> --publish <posthost>:<portcontainer> --env KEY="<value>" --env KEY2="<value>" <image>:<tag>
```
# Docker Container Stats
- Saat menjalankan beberapa container, di sistem Host, penggunaan resource seperti CPU dan Memory hanya terlihat digunakan oleh Docker saja
- Untungnya docker memiliki kemampuan untuk melihat penggunaan resource dari tiap container yang sedang berjalan
```bash
docker container stats
```
# Docker Container Resource Limit
- Saat membuat container, secara default dia akan menggunakan semua CPU dan Memory yang diberikan ke Docker (Mac dan Windows), dan akan menggunakan semua CPU dan Memory yang tersedia di sistem Host (Linux)
- Oleh karena itu, ada baiknya ketika kita membuat container, kita memberikan resource limit terhadap container nya
```bash
docker container create --name <containername> --publish <porthost>:<portcontainer> --cpus <amountcpuusage> --memory <amountmemoryusage><b/k/m/g> nginx:latest
```
# Docker Container Bind Mounts
- Fitur ini sangat berguna ketika misal kita ingin mengirim konfigurasi dari luar container, atau misal menyimpan data yang dibuat di aplikasi di dalam container ke dalam folder di sistem host
- type : mount, bind, dan volume
```bash
docker container create --name <namacontainer> --publish <port-host>:<port-container> --cpus <amountcpuusage> --memory <amountmemoryusage><b/k/m/g> --mount "type=<bind/mount/volume>,source=<folder>,destination=<folder>,readonly" <image>:<tag>
```
# Docker Volume
- Docker Volume mirip dengan Bind Mounts, bedanya adalah terdapat management Volume, dimana kita bisa membuat Volume, melihat daftar Volume, dan menghapus Volume
- Untuk membuat volume, kita bisa gunakan perintah :
```bash
docker volume create <namavolume>
```
- Untuk menghapus volume, kita bisa gunakan perintah :
```bash
docker volume rm <namavolume>
```
# Docker Container Volume
- Volume yang sudah kita buat, bisa kita gunakan di container
- Keuntungan menggunakan volume adalah, jika container kita hapus, data akan tetap aman di volume
- Cara menggunakan volume di container sama dengan menggunakan bind mount, kita bisa menggunakan parameter --mount, namun dengan menggunakan type volume dan source nama volume
```bash
docker container create --name <namacontainer> --publish <porthost>:<portcontainer> --cpus <amountcpuusage> --memory <amountmemoryusage><b/k/m/g> --mount “type=<volume>,source=<namavolume>,destination=<folder>,readonly” <image>:<tag>
```
# Docker Container Backup Volume
- memanfaatkan container untuk melakukan backup data yang ada di dalam volume ke dalam archive seperti zip atau tar.gz
- Melakukan backup secara manual agak sedikit ribet karena kita harus start container terlebih dahulu, setelah backup, hapus container nya lagi
- Kita bisa menggunakan perintah run untuk menjalankan perintah di container dan gunakan parameter --rm untuk melakukan otomatis remove container setelah perintahnya selesai berjalan
```bash
docker container run --rm --name ubuntubackup --mount "type=bind,source=/c/backup,destination=/backup" --mount "type=volume,source=mongodata,destination=/data" ubuntu:latest tar cvf /backup/backup.tar.gz /data
```
# Docker Container Restore Volume
- Buat volume baru untuk lokasi restore data backup
- Buat container baru dengan dua mount, volume baru untuk restore backup, dan bind mount folder dari sistem host yang berisi file backup
- Lakukan restore menggunakan container dengan cara meng-extract isi backup file ke dalam volume
- Isi file backup sekarang sudah di restore ke volume
- Delete container yang kita gunakan untuk melakukan restore
- Volume baru yang berisi data backup siap digunakan oleh container baru
```bash
docker volume create data-restore

docker container run --rm --name ubunturestore --mount "type=bind,source=/c/backup,destination=/backup" --mount "type=volume,source=data-restore,destination=/data" ubuntu:latest bash -c "cd /data && tar xvf /backup/backup.tar.gz --strip 1"

docker container create --name mongistore --publish 2331:27017 --mount "type=volume,source=data-restore,destination=/data" mongo:latest
```

# Docker Network
- Dengan menggunakan Network, kita bisa mengkoneksikan container dengan container lain dalam satu Network yang sama
- Jika beberapa container terdapat pada satu Network yang sama, maka secara otomatis container tersebut bisa saling berkomunikasi
- Perlu menentukan driver yang ingin kita gunakan, ada banyak driver yang bisa kita gunakan, tapi kadang ada syarat sebuah driver network bisa kita gunakan.
- bridge, yaitu driver yang digunakan untuk membuat network secara virtual yang memungkinkan container yang terkoneksi di bridge network yang sama saling berkomunikasi
- host, yaitu driver yang digunakan untuk membuat network yang sama dengan sistem host. host hanya jalan di Docker Linux, tidak bisa digunakan di Mac atau Windows
- none, yaitu driver untuk membuat network yang tidak bisa berkomunikasi

- Untuk melihat network di Docker, kita bisa gunakan perintah :
```bash
docker network ls
```
- Untuk membuat network baru, kita bisa menggunakan perintah :
```bash
docker network create --driver <namadriver> <namanetwork>
```
- Untuk menghapus Network, kita bisa gunakan perintah :
```bash
docker network rm <namanetwork>
```
# Docker Container Network
- Setelah kita membuat Network, kita bisa menambahkan container ke network
- Container yang terdapat di dalam network yang sama bisa saling berkomunikasi (tergantung jenis driver network nya)
- Container bisa mengakses container lain dengan menyebutkan hostname dari container nya, yaitu nama container nya
- Untuk menambahkan container ke network, kita bisa menambahkan perintah --network ketika membuat container, misal :
```bash
docker container create --name namacontainer --publish <porthost>:<portcontainer> --cpus <amountcpuusage> --memory <amountmemoryusage><b/k/m/g> --mount "type=<bind/mount/volume>,source=<folder>,destination=<folder>,readonly" --network <namanetwork> image:tag
```
```bash
docker network connect <namanetwork> <namacontainer>
```
- Jika diperlukan, kita juga bisa menghapus container dari network dengan perintah :
```bash
docker network disconnect <namanetwork> <namacontainer>
```
# Docker Inspect
- Setelah kita men-download image, atau membuat network, volume dan container. Kadang kita ingin melihat detail dari tiap hal tersebut
- Untuk melihat detail dari image, gunakan : `docker image inspect <namaimage>`
- Untuk melihat detail dari container, gunakan : `docker container inspect <namacontainer>`
- Untuk melihat detail dari volume, gunakan : `docker volume inspect <namavolume>`
- Untuk melihat detail dari network, gunakan : `docker network inspect <namanetwork>`
# Docker Prune
- Saat kita menggunakan Docker, kadang ada kalanya kita ingin membersihkan hal-hal yang sudah tidak digunakan lagi di Docker, misal container yang sudah di stop, image yang tidak digunakan oleh container, atau volume yang tidak digunakan oleh container
- Fitur untuk membersihkan secara otomatis di Docker bernama prune
- Hampir di semua perintah di Docker mendukung prune
- Untuk menghapus semua container yang sudah stop, gunakan : `docker container prune`
- Untuk menghapus semua image yang tidak digunakan container, gunakan : `docker image prune`
- Untuk menghapus semua network yang tidak digunakan container, gunakan : `docker network prune`
- Untuk menghapus semua volume yang tidak digunakan container, gunakan : `docker volume prune`
- Atau kita bisa menggunakan satu perintah untuk menghapus container, network dan image yang sudah tidak digunakan menggunakan perintah : `docker system prune`



# Dummy
```bash
docker container create --name nginx-container --publish 80:80 --cpus 1 --memory 100m nginx:latest

docker container create --name nginx-container --publish 80:8080 --cpus 1 --memory 100m --mount "type=bind,source=/C/Users/dhondoi/Documents/mariadb/html-lokal,destination=/usr/share/nginx/html,readonly" --env NGINX_PORT=8080 --network nginx-network image:tag nginx:latest

```
