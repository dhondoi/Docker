Berikut adalah ringkasan tersusun dari dokumen dasar-dasar **Dockerfile**, mencakup konsep dasar, instruksi penting, pengelolaan berkas, variabel, hingga optimasi dan *registry*.

---

## Ringkasan Materi Dockerfile

### 1. Pengenalan Dockerfile & Perintah Build

* **Dockerfile:** Berkas teks berisi kumpulan instruksi untuk membuat *Docker Image* secara otomatis.
* **Format Penulisan:** Berformat `INSTRUCTION arguments`. Nama instruksi bersifat *case-insensitive*, tetapi direkomendasikan menggunakan huruf kapital (*UPPERCASE*). Baris yang diawali dengan tanda `#` dianggap sebagai komentar.
* **Perintah Build:** 
```bash
docker build -t <nama_image:tag> <folder_dockerfile>
Opsi `-t` dapat digunakan lebih dari sekali untuk memberikan beberapa *tag* sekaligus.

```



---

### 2. Ringkasan Instruksi Utama Dockerfile

| Instruksi | Fungsi Utama | Tahap Eksekusi |
| --- | --- | --- |
| **`FROM`** | Menentukan *base image* atau *build stage* awal. | Build |
| **`RUN`** | Mengeksekusi perintah di dalam *image* dan merekam perubahannya ke dalam *image*. | Build |
| **`CMD`** | Menjalankan perintah utama aplikasi ketika *container* dinyalakan. Hanya instruksi `CMD` terakhir yang berlaku. | Runtime |
| **`ENTRYPOINT`** | Menentukan berkas eksekusi (*executable*) utama *container*. `CMD` dapat bertindak sebagai argumen default untuk `ENTRYPOINT`. | Runtime |
| **`LABEL`** | Menambahkan metadata (seperti nama aplikasi, pembuat, lisensi) pada *image*. | Build |
| **`WORKDIR`** | Menentukan direktori kerja eksekusi instruksi `RUN`, `CMD`, `ENTRYPOINT`, `COPY`, dan `ADD`. | Build & Runtime |
| **`USER`** | Mengubah *user* atau *user group* default (menggantikan akun `root`). | Runtime |
| **`EXPOSE`** | Menginformasikan port dan protokol (TCP/UDP) yang didengarkan oleh *container*. | Runtime (Dokumentasi) |
| **`HEALTHCHECK`** | Menentukan mekanisme pemantauan status kesehatan (*healthy/unhealthy*) *container*. | Runtime |

---

### 3. Pengelolaan Berkas (`COPY` vs `ADD` & `.dockerignore`)

* **`COPY`:** Menyalin berkas atau folder dari *host* ke dalam *image* (*best practice* standar).
* **`ADD`:** Selain menyalin, dapat mengunduh berkas via URL serta mengagregasi/mengekstrak berkas arsip terkompresi (`.tar.gz`, dll.) secara otomatis.
* **`.dockerignore`:** Berkas khusus yang digunakan untuk mengabaikan berkas/folder agar tidak tersalin ke *build context* (mirip `.gitignore`).

---

### 4. Variabel dan Penyimpanan Data (`ARG`, `ENV`, `VOLUME`)

* **`ARG` (Build Argument):**
* Variabel yang dikirim saat proses *build* (`docker build --build-arg key=value`).
* Hanya tersedia pada tahap *build time* dan tidak tersimpan saat *container* berjalan.


* **`ENV` (Environment Variable):**
* Variabel lingkungan yang aktif pada tahap *build* maupun saat *container* berjalan.
* Nilainya dapat diubah kembali saat pembuatan *container* (`docker create --env`).


* **`VOLUME`:**
* Membuat *volume* otomatis di dalam *container* untuk mengamankan data persistent yang dihasilkan oleh aplikasi.



---

### 5. Multi-Stage Build

* **Konsep:** Fitur untuk menggunakan beberapa instruksi `FROM` dalam satu Dockerfile.
* **Manfaat:** Memisahkan tahap kompilasi (*build stage*) dengan tahap distribusi (*final stage*).
* **Hasil:** Hanya artefak hasil kompilasi (seperti berkas biner) yang disalin ke *image* akhir (misalnya menggunakan *base image* minimal seperti Alpine Linux), sehingga menghasilkan ukuran *image* yang sangat kecil dan aman.

---

### 6. Pengunggahan ke Image Registry

* **Docker Hub:**
* Login dengan perintah `docker login -u <username>`.
* Unggah *image* menggunakan perintah `docker push <image>`.


* **DigitalOcean Container Registry:**
* Menggunakan berkas konfigurasi kredensial khusus (`config.json`) yang disimpan dalam folder terpisah.
* Perintah pengunggahan dilakukan dengan mengarahkan *config path*:
```bash
docker --config /lokasi/folder/config/ push <image>

```