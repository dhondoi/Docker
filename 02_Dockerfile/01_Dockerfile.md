# Pengenalan Dockerfile
- Pembuatan Docker Image bisa dilakukan dengan menggunakan instruksi yang kita simpan di dalam file Dockerfile
- Dockerfile adalah file text yang berisi semua perintah yang bisa kita gunakan untuk membuat sebuah Docker Image
- Misal berikut adalah contoh cara menggunakan docker build :
```bash
docker build -t <khannedy/app:1.0.0>  <folder-dockerfile>
docker build -t <khannedy/app:1.0.0> -t <khannedy/app:latest> <folder-dockerfile>
```
- Secara sederhana berikut adalah format untuk file Dockerfile :
```dockerfile
# Komentar
INSTRUCTION arguments
```
- `# digunakan untuk menambah komentar, kode dalam baris tersebut secara otomatis dianggap komentar`
- INSTRUCTION adalah perintah yang digunakan di Dockerfile, ada banyak perintah yang tersedia, dan penulisan perintahnya case insensitive, sehingga kita bisa gunakan huruf besar atau kecil. Namun rekomendasinya adalah menggunakan UPPPER CASE
- Arguments adalah data argument untuk INSTRUCTION, yang menyesuaikan dengan jenis INSTRUCTION yang digunakan
# From Instruction
- Saat kita membuat Docker Image, biasanya perintah pertama adalah melakukan build stage dengan instruksi FROM
- FROM digunakan untuk membuat build stage dari image yang kita tentukan
- Biasanya, jarang sekali kita akan membuat Docker Image dari scratch (kosongan), biasanya kita akan membuat Docker Image dari Docker Image lain yang sudah ada
- Untuk menggunakan FROM, kita bisa gunakan perintah :
```dockerfile
FROM image:version
```
# Run Instruction
- RUN adalah sebuah instruksi untuk mengeksekusi perintah di dalam image pada saat build stage. 
- Hasil perintah RUN akan di commit dalam perubahan image tersebut, jadi perintah RUN akan dieksekusi pada saat proses docker build saja, setelah menjadi Docker Image, perintah tersebut tidak akan dijalankan lagi. 
- Jadi ketika kita menjalankan Docker Container dari Image tersebut, maka perintah RUN tidak akan dijalankan lagi.
- Perintah RUN memiliki 2 format :
```dockerfile
RUN command
RUN [“executable”, “argument”, “...”]
```
# Command Instruction
- CMD tidak akan dijalankan ketika proses build, namun dijalankan ketika Docker Container berjalan
- Dalam Dockerfile, kita tidak bisa menambah lebih dari satu instruksi CMD, jika kita tambahkan lebih dari satu instruksi CMD, maka yang akan digunakan untuk menjalankan Docker Container adalah instruksi CMD yang terakhir
- Perintah CMD memiliki beberapa format :
```dockerfile
CMD command param param
CMD [“executable”, “param”, “param”]
CMD [“param”, “param”], akan menggunakan executable ENTRY POINT, yang akan dibahas di chapter terpisah
```
# Label Instruction
- digunakan untuk menambahkan metadata ke dalam Docker Image
- Metadata adalah informasi tambahan, misal seperti nama aplikasi, pembuat, website, perusahaan, lisensi dan lain-lain
- Berikut adalah format instruksi LABEL
```dockerfile
LABEL <key>=<value>
LABEL <key1>=<value1> <key2>=<value2> …
```
# Add Instruction
- digunakan untuk menambahkan file dari source ke dalam folder destination di Docker Image
- Perintah ADD bisa mendeteksi apakah sebuah file source merupakan file kompres seperti tar.gz, gzip, dan lain-lain. Jika mendeteksi file source adalah berupa file kompress, maka secara otomatis file tersebut akan di extract dalam folder destination
- Instruksi ADD memiliki format sebagai berikut :
```dockerfile
ADD source destination
Contoh :
ADD world.txt hello # menambah file world.txt ke folder hello
ADD *.txt hello # menambah semua file .txt ke folder hello
```
# Copy Instruction
- COPY hanya melakukan copy file saja, sedangkan ADD selain melakukan copy, dia bisa mendownload source dari URL dan secara otomatis melakukan extract file kompres
- Namun best practice nya, sebisa mungkin menggunakan COPY, jika memang butuh melakukan extract file kompres, gunakan perintah RUN dan jalankan aplikasi untuk extract file kompres tersebut
- Instruksi COPY memiliki format sebagai berikut :
```dockerfile
COPY source destination
Contoh :
COPY world.txt hello # menambah file world.txt ke folder hello
COPY *.txt hello # menambah semua file .txt ke folder hello
```
# .dockerignore File
- Saat kita melakukan ADD atau COPY dari file source, pertama Docker akan membaca file yang bernama .dockerignore
- File .dockerignore ini seperti file .gitignore, dimana kita bisa menyebutkan file-file apa saja yang ingin kita ignore (hiraukan)
# Expose Instruction
- EXPOSE adalah instruksi untuk memberitahu bahwa container akan listen port pada nomor dan protocol tertentu
- Berikut adalah format untuk instruksi EXPOSE :
```dockerfile
EXPOSE port # default nya menggunakan TCP
EXPOSE port/tcp
EXPOSE port/udp
```
# Environment Variable Instruction
- ENV adalah instruksi yang digunakan untuk mengubah environment variable, baik itu ketika tahapan build atau ketika jalan dalam Docker Container
- ENV yang sudah di definisikan di dalam Dockerfile bisa digunakan kembali dengan menggunakan sintaks ${NAMA_ENV}
- Selain itu, environment variable juga bisa diganti nilainya ketika pembuatan Docker Container dengan perintah docker container create `--env <key>="<value>"`
- Berikut adalah format untuk instruksi ENV :
```dockerfile
ENV key=value 
ENV ke1=value1 key2=value2 …
```
# Volume Instruction
- VOLUME merupakan instruksi yang digunakan untuk membuat volume secara otomatis ketika kita membuat Docker Container
- Semua file yang terdapat di volume secara otomatis akan otomatis di copy ke Docker Volume, walaupun kita tidak membuat Docker Volume ketika membuat Docker Container nya
- Ini sangat cocok pada kasus ketika aplikasi kita misal menyimpan data di dalam file, sehingga data bisa secara otomatis aman berada di Docker Volume
- Berikut adalah format untuk instruksi VOLUME :
```dockerfile
VOLUME /lokasi/folder
VOLUME /lokasi/folder1 /lokasi/folder2 …
VOLUME [“/lokasi/folder1”, “/lokasi/folder2”, “...”]
```
# Working Directory Instruction
- WORKDIR adalah instruksi untuk menentukan direktori / folder untuk menjalankan instruksi RUN, CMD, ENTRYPOINT, COPY dan ADD
- Jika WORKDIR tidak ada, secara otomatis direktorinya akan dibuat, dan selanjutnya setelah kita
- tentukan lokasi WORKDIR nya, direktori tersebut dijadikan tempat menjalankan instruksi selanjutnya
- Jika lokasi WORKDIR adalah relative path, maka secara otomatis dia akan masuk ke direktori dari WORKDIR sebelumnya
- WORKDIR juga bisa digunakan sebagai path untuk lokasi pertama kali ketika kita masuk ke dalam Docker Container
- Berikut adalah format untuk instruksi WORKDIR :
```dockerfile
WORKDIR /app # artinya working directory nya adalah /app
WORKDIR docker # sekarang working directory nya adalah /app/docker
WORKDIR /home/app # sekarang working directory nya adalah /home/app
```
# User Instruction
- USER adalah instruksi yang digunakan untuk mengubah user atau user group ketika Docker Image dijalankan
- Secara default, Docker akan menggunakan user root, namun pada beberapa kasus, mungkin ada aplikasi yang tidak ingin jalan dalam user root, maka kita bisa mengubah user nya menggunakan instruksi USER
Berikut adalah format untuk instruksi USER:
```dockerfile
USER <user> # mengubah user
USER <user>:<group> # mengubah user dan user group
```
# Argument Instruction
- ARG merupakan instruksi yang digunakan untuk mendefinisikan variable yang bisa digunakan oleh pengguna untuk dikirim ketika melakukan proses docker build menggunakan perintah --build-arg key=value
- ARG hanya digunakan pada saat proses build time, artinya ketika berjalan dalam Docker Container, ARG tidak akan digunakan, berbeda dengan ENV yang digunakan ketika berjalan dalam Docker Container
- Cara mengakses variable dari ARG sama seperti mengakses variable dari ENV, menggunakan ${variable_name}
- Berikut adalah format untuk instruksi ARG:
```dockerfile
ARG key # membuat argument variable
ARG key=defaultvalue # membuat argument variable dengan default value jika tidak diisi
```
# Health Check Instruction
- HEALTHCHECK adalah instruksi yang digunakan untuk memberi tahu Docker bagaimana untuk mengecek apakah Container masih berjalan dengan baik atau tidak
- Jika terdapat HEALTHCHECK, secara otomatis Container akan memili status health, dari awalnya bernilai starting, jika sukses maka bernilai healthy, jika gagal akan bernilai unhealty
- Berikut adalah format untuk instruksi HEALTHCHECK :
```dockerfile
HEALTHCHECK NONE # artinya disabled health check
HEALTHCHECK [OPTIONS] CMD command 
OPTIONS :
--interval=DURATION (default: 30s)
--timeout=DURATION (default: 30s)
--start-period=DURATION (default: 0s)
--retries=N (default: 3)
```
# Entrypoint Instruction
- ENTRYPOINT adalah instruksi untuk menentukan executable file yang akan dijalankan oleh container
- Biasanya ENTRYPOINT itu erat kaitannya dengan instruksi CMD
- Saat kita membuat instruksi CMD tanpa executable file, secara otomatis CMD akan menggunakan ENTRYPOINT
```dockerfile
Berikut adalah format untuk instruksi ENTRYPOINT:
ENTRYPOINT [“executable”, “param1”, “param2”]
ENTRYPOINT executable param1 param2
Saat menggunakan CMD [“param1”, “param2”], maka param tersebut akan dikirim ke ENTRYPOINT
```
# Multi Stage Build
- Saat kita membuat Dockerfile dari base image yang besar, secara otomatis ukuran Image nya pun akan menjadi besar juga
- Oleh karena itu, usahakan selalu gunakan base image yang memang kita butuhkan saja, jangan terlalu banyak menginstall fitur di Image padahal tidak kita gunakan
- Sebelumnya kita menggunakan bahasa pemrograman Go-Lang untuk membuat web sederhana.
- Sebenarnya, Go-Lang memiliki fitur untuk melakukan kompilasi kode program Go-Lang menjadi binary file, sehingga tidak membutuhkan Image Go-Lang lagi
- Kita bisa melakukan proses kompilasi di laptop kita, lalu file binary nya yang kita simpan di Image, dan cukup gunakan base image Linux Alpine misal nya
- Namun pada kasus Go-Lang, kita di rekomendasikan melakukan kompilasi file binary di sistem operasi yang sama, pada kasus ini saya menggunakan Mac, sedangkan ingin menggunakan Image Alpine, jadi tidak bisa saya lakukan
- Docker memiliki fitur Multi Stage Build, dimana dalam Dockerfile, kita bisa membuat beberapa Build Stage atau tahapan build
- Seperti kita tahu, bahwa di awal build, biasanya kita menggunakan instruksi FROM, dan di dalam Dockerfile, kita bisa menggunakan beberapa instruksi FROM
- Setiap Instruksi FROM, artinya itu adalah build stage
- Hal build stage terakhir adalah build stage yang akan dijadikan sebagai Image
- Artinya, kita bisa memanfaatkan Docker build stage ini untuk melakukan proses kompilasi kode program Go-Lang kita
# Docker Hub Registry
- Setelah kita selesai membuat Image, selanjutnya hal yang biasa dilakukan adalah mengupload Image tersebut ke Docker Registry
- Salah satu Docker Registry yang gratis contohnya adalah Docker Hub
- https://hub.docker.com/ 
```bash
docker login -u <username>
docker push <image>
```
# Digital Ocean Container Registry
- Digital Ocean adalah salah satu cloud provider yang populer, dan memiliki fitur Docker Registry bernama Container Registry
- Terdapat Free Version untuk ukuran sampai 500MB yang bisa kita gunakan
https://www.digitalocean.com/products/container-registry 
- Silahkan buat Container Registry terlebih dahulu
- Berbeda dengan Docker Hub yang kita diperlukan melakukan login ketika ingin melakukan push ke Registry
- Di Digital Ocean, kita akan menggunakan Docker Config untuk mengirim Image ke Digital Ocean Container Registry
- Ini lebih mudah karena kita bisa dengan gampang push Image dari manapun selama menggunakan config file yang sama
- Secara default, Docker akan membaca config yang terdapat di $HOME/.docker
- Di dalamnya terdapat file config.json yang berisi konfigurasi credential yang sudah kita gunakan - ketika login ke Docker Hub
- Agar tidak mengganggu, khusus untuk Digital Ocean, kita akan buat folder terpisah, misal .docker-digital-ocean
- Selanjunya file creadential yang sudah di download, silahkan ganti namanya menjadi config.json dan simpan di folder .docker-digital-ocean tersebut
- Jika kita menggunakan perintah docker push, secara default itu akan melakukan push ke Container Registry yang teregistrasi di $HOME/.docker
- Karena kita menggunakan lokasi yang berbeda untuk Digital Ocean, jadi ketika melakukan push, kita perlu mengubah default config nya menggunaka perintah :
```bash
docker --config /lokasi/folder/config/ push image
```
