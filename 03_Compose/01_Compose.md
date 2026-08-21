# INSTALL 
```bash
curl -SL https://github.com/docker/compose/releases/download/v5.5.0/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
```
apply permission
```bash
chmod +x /usr/local/bin/docker-compose
```
check path if `docker-compose` fails, check path and create sybolic link
```bash
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
```
- alternatif install
```bash
sudo apt-get install docker-compose-plugin
```
# Yaml
- Yaml adalah sebuah jenis file yang biasa digunakan untuk menyimpan konfigurasi
- Yaml mirip seperti JSON, hanya saja tidak menggunakan kurung kurawal
- Yaml akan memiliki attribute dan value
- https://yaml.org/ 
# Membuat Container 
- Sebelumnya untuk membuat container, kita selalu menggunakan perintah docker create
- Namun sekarang kita bisa buat container hanya menggunakan configuration file di Docker Compose
- Pada file yaml, kita bisa tambahkan bagian services untuk menentukan container-nya
- Dalam service tersebut, kita bisa tentukan container name dan image untuk docker container yang akan kita buat
- Setelah membuat konfigurasi file, Container tidak langsung jadi, kita harus membuatnya dengan menggunakan Docker Compose, yaitu dengan perintah :
```bash
docker compose create
```
# Melihat Container
- Biasanya, saat kita ingin melihat Container, kita biasanya gunakan perintah docker container ls
- Namun menggunakan perintah itu, akan melihatkan semua container, baik itu yang dibuat oleh Docker Compose, atau dibuat manual
- Jika kita ingin melihat status Container yang hanya terdapat di konfigurasi file Docker Compose, kita bisa gunakan perintah :
```bash
docker compose ps
```
# Menghentikan Container
- Untuk menghentikan Container, kita bisa menggunakan perintah :
```bash
docker compose stop
```
- Menghentikan Container hanya men-stop Container, tidak akan menghapus Container nya
# Menghapus Container
- Jika kita sudah tidak butuh lagi container yang terdapat di file konfigurasi, kita bisa menghapusnya
- Kita bisa hapus secara manual menggunakan perintah docker container rm, atau menggunakan Docker Compose
- Untuk menghapus container menggunakan Docker Compose, kita bisa gunakan perintah :
```bash
docker compose down
```
- Secara otomatis semua Container dan Network dan Volume yang digunakan oleh Container tersebut akan dihapus
# Project Name
- Seperti yang sudah dijelaskan di awal, saat kita menggunakan Docker Compose, informasi konfigurasi Docker Compose akan disimpan dalam project
- Secara default nama project-nya adalah nama folder lokasi file docker-compose.yaml
- Untuk melihat daftar project yang sedang berjalan, kita bisa gunakan perintah :
```bash
docker compose ls
```
# Port
- Saat membuat Container, kita bisa mengekspose port di Container keluar menggunakan Port Forwarding
- Kita juga bisa melakukan hal tersebut di konfigurasi file Docker Compose dengan menggunakan attribute ports
- Attribute ports berisi array object port
# Environment Variable
- Saat membuat container, kita juga menambahkan environment variable untuk digunakan di dalam container
- Saat menggunakan konfigurasi file Docker Compose, kita bisa tambahkan environment variable dengan menggunakan attribute environment
# Bind Mount
- Untuk melakukan bind mount, kita juga bisa lakukan di konfigurasi file Docker Compose
- Kita bisa gunakan attribute volumes di services
- Kita bisa tambahkan satu atau lebih bind mount jika kita mau
# Volume
- Docker Compose juga tidak hanya bisa digunakan untuk membuat container, tapi bisa juga digunakan untuk membuat volume
- Kita bisa menggunakan attribute volumes pada konfigurasi file
- Saat kita menggunakan perintah docker compose down, yang dihapus hanyalah Container dan Network saja
- Volume tidak akan dihapus, hal ini agar jangan sampai kita tidak sengaja menghapus volume
- Jika ingin menghapus volume, kita bisa lakukan manual dengan perintah 
```bash
docker volume rm <nama-volume>
```
# Network
- Selain membuat Container dan Volume, kita juga bisa menggunakan Docker Compose untuk membuat Network secara otomatis
- Saat kita menjalankan file menggunakan Docker Compose, secara default semua container akan dihubungkan dalam sebuah Network bernama nama-project_default
- Jadi sebenarnya kita tidak perlu membuat Network secara manual
- Silahkan inspect container yang sudah berjalan menggunakan Docker Compose, lalu lihat pada bagian Network
- Tapi jika kita ingin membuat Network secara manual, kita juga bisa menggunakan Docker Compose
- Kita bisa buat satu atau lebih Network menggunakan attribute networks, dimana kita perlu tentukan :
```yaml
name: Nama network
driver: Driver network seperti bridge, host atau none
```
# Depends On
- Saat membuat file Docker Compose yang berisi banyak Container
- Kadang kita membuat Container yang butuh Container lain sebelum berjalan
- Atau sederhananya, kita ingin ada urutan Container berjalan
- Secara default, Docker Compose akan menjalankan semua Container secara bersamaan, tanpa ada urutan pasti
- Kita bisa membuat urutan menjalankan Container dengan menggunakan attribute depends_on
- Kita bisa sebutkan pada Container, bahwa Container ini hanya bisa berjalan, kalo Container yang lain sudah berjalan
- Kita bisa sebutkan satu atau lebih Container lainnya pada attribute depends_on
# Restart
- Secara default, saat Container mati, maka Docker tidak akan menjalankan lagi Container nya
- Kita harus menjalankan lagi Container nya secara manual
- Kita bisa memaksa sebuah container untuk selalu melakukan restart jika misal terjadi masalah pada Container nya
- Kita bisa tambahkan attribute restart, dengan beberapa value :
1. no: default nya tidak pernah restart
2. always: selalu restart jika container berhenti, tapi jika di hentikan manual, dia akan restart ketika pertama kali docker restart
3. on-failure: restart jika container error dengan indikasi error ketika exit
4. unless-stopped: selalu restart container, kecuali ketika dihentikan manual
- Untuk melihat kejadian apa saja yang terjadi di Docker secara realtime, kita bisa menggunakan perintah :
docker events
- Contohnya kita bisa memonitor kejadian yang terjadi pada sebuah contanier dengan perintah :
```bash
docker events --filter 'container=<nama>'
```
# Resource Limit
- Kita juga bisa menggunakan file konfigurasi Docker Compose untuk mengatur Resource Limit untuk CPU dan Memory dari tiap Container yang akan kita buat
- Kita bisa menggunakan attribute deploy, lalu didalamnya menggunakan attribute resources
- Di dalam attribute resources kita bisa tentukan limit dan reservations
- reservation adalah resource yang dijamin bisa digunakan oleh container
- limit adalah limit maksimal untuk resource yang diberikan ke container, namun ingat bisa saja limit ini rebutan dengan container lain
# Dockerfile
- Ketika kita ingin membuat Container dari Dockerfile, kita tidak menggunakan attribute image lagi di service nya
- Kita harus menggunakan attribute build, dimana terdapat attribute :
1. context: berisi path ke file Dockerfile
2. dockerfile: nama file Dockerfile, bisa diganti jika mau
3. args: argument yang dibutuhkan ketika melakukan docker build
- Secara default, Docker Compose akan membuat Image dengan nama random ketika melakukan build Dockerfile
- Jika kita ingin menentukan namanya, kita bisa tambahkan attribute image pada service, secara otomatis Docker Compose akan membuat image dengan nama sesuai dengan itu
- Ketika kita menggunakan perintah docker compose start, secara otomatis Docker Compose akan melakukan build terlebih dahulu jika Image nya belum terbuat
- Tapi jika kita hanya ingin melakukan build Image saja, tanpa membuat Container, kita juga bisa menggunakan perintah : `docker compose build`
# Health Check
- Kita pernah bahas tentang Container Health Check di materi Docker Dockerfile
- Secara default Container yang dibuat, baik itu secara manual ataupun menggunakan Docker Compose, pasti akan selalu menggunakan Health Check yang dibuat di Dockerfile
- Namun, jika kita ingin mengubah Health Check tersebut, itu juga bisa kita lakukan
- Kita bisa ubah di file konfigurasi Docker Compose pada attribute healthcheck di services
- Health Check memiliki banyak attribute, seperti
1. test: berisikan cara melakukan test health check
2. interval: interval melakukan health check
3. timeout: timeout melakukan health check
4. retries: total retry ketika gagal
5. start_period: waktu mulai melakukan health check
6. Hampir mirip dengan ketika kita membuat Health Check di Dockerfile
- Jika kita tidak mau ada health check, kita juga bisa menonaktifkan nya
- Secara otomatis health check bawaan dari Docker Image nya pun tidak akan diaktifkan
- Cukup di attribute healthcheck, tambahkan attribute `disabled: true`
# Extend Service
- Saat membuat aplikasi menggunakan Docker, kadang kita ingin menjalankan aplikasi tersebut ke beberapa server
- Baik itu di local laptop, di server development, atau server production
- Kadang ada kalanya beberapa hal berbeda, misal konfigurasi misalnya
- Pada kasus ini, mau tidak mau kita harus membuat banyak file konfigurasi Docker Compose, misal untuk di local, di development dan di production
- Docker Compose memiliki fitur bernama extend service, dimana kita bisa melakukan merge beberapa file konfigurasi sekaligus
- Dengan begitu, kita bisa membuat file konfigurasi umum, dan spesial untuk setiap jenis environment misalnya
- Saat menjalankan Docker Compose, kita bisa gunakan perintah -f namafile.yaml jika ingin menggunakan nama file yang bukan docker-compose.yaml
