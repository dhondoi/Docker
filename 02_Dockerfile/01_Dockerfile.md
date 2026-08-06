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