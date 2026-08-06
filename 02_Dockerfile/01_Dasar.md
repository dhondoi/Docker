# Pengenalan Dockerfile
- Pembuatan Docker Image bisa dilakukan dengan menggunakan instruksi yang kita simpan di dalam file Dockerfile
- Dockerfile adalah file text yang berisi semua perintah yang bisa kita gunakan untuk membuat sebuah Docker Image
- Saat membuat Docker Image dengan docker build, nama image secara otomatis akan dibuat random, dan biasanya kita ingin menambahkan nama/tag pada image nya, kita bisa mengubahnya dengan menambahkan perintah -t
- Misal berikut adalah contoh cara menggunakan docker build :
```bash
docker build -t khannedy/app:1.0.0  folder-dockerfile
docker build -t khannedy/app:1.0.0 -t khannedy/app:latest folder-dockerfile
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