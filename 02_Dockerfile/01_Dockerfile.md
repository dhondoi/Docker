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
