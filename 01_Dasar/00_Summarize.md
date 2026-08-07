## Ringkasan Materi Dasar Docker

Berikut adalah ringkasan tersusun dari dokumen dasar-dasar Docker yang mencakup konsep utama, perintah dasar, konfigurasi, serta pemeliharaan sistem Docker.

---

### 1. Konsep Utama (Key Points)

| Konsep | Deskripsi |
| --- | --- |
| **Image** | Cetak biru (*installer*) dari sebuah aplikasi. |
| **Container** | Lingkungan isolasi tempat aplikasi hasil *Image* dijalankan. |
| **Port** | Pengaturan penerusan akses (*port forwarding*) dari sistem *host* ke *container*. |
| **Resource Limit** | Pembatasan konsumsi CPU dan memori (*memory*) untuk *container*. |
| **Bind Mounts** | Metode menyimpan data dari *container* langsung ke direktori sistem *host*. |
| **Volume** | Media penyimpanan data yang dikelola penuh di dalam lingkungan Docker. |
| **Network** | Jaringan virtual untuk menghubungkan *container* agar dapat saling berkomunikasi. |

---

### 2. Docker Registry & Image

* **Docker Registry:** Tempat penyimpanan dan pendistribusian *Docker Image* (contoh: Docker Hub).
* **Melihat daftar image:** `docker image ls`
* **Mengunduh image:** `docker image pull <namaimage>:<tag>`
* **Menghapus image:** `docker image rm <namaimage>:<tag>`

> **Catatan:** *Image* yang sedang digunakan oleh suatu *container* tidak dapat dihapus sebelum *container*-nya dihapus terlebih dahulu.

---

### 3. Pengelolaan Docker Container

* **Membuat container:** `docker container create --name <namacontainer> <namaimage>:<tag>`
* **Melihat daftar container:** `docker container ls -a`
* **Menjalankan container:** `docker container start <namacontainer>`
* **Menghentikan container:** `docker container stop <namacontainer>`
* **Menghapus container:** `docker container rm <namacontainer>`

#### Operasi Tambahan Container

* **Log Aplikasi:** `docker container logs <namacontainer>` (tambahkan `-f` untuk *realtime*).
* **Masuk/Exec Container:** `docker container exec -i -t <namacontainer> bin/bash`.
* **Monitoring Resource:** `docker container stats`.

---

### 4. Konfigurasi & Parameter Container

* **Port Forwarding:** Menggunakan opsi `--publish <porthost>:<portcontainer>` saat pembuatan *container*.
* **Environment Variable:** Menggunakan opsi `--env KEY="value"` atau `-e` untuk mengubah konfigurasi tanpa mengubah kode.
* **Resource Limit:** Menggunakan opsi `--cpus <jumlah>` dan `--memory <ukuran>` (misal: `100m` atau `1g`).

---

### 5. Media Penyimpanan Data (Storage)

* **Bind Mounts & Volume:** Diatur menggunakan opsi `--mount "type=<bind/volume>,source=<sumber>,destination=<tujuan>"`.
* **Manajemen Volume:**
* Membuat volume: `docker volume create <namavolume>`
* Menghapus volume: `docker volume rm <namavolume>`


* **Backup & Restore:** Dilakukan dengan memanfaatkan *container* sementara (flag `--rm`) yang menjalankan perintah kompresi (`tar`) untuk mencadangkan atau mengekstrak isi *volume*.

---

### 6. Pengelolaan Jaringan (Docker Network)

* **Driver Network Utama:**
* `bridge`: Driver default untuk komunikasi antar-*container* dalam satu jaringan virtual.
* `host`: Menyamakan jaringan *container* dengan sistem *host* (hanya di Linux).
* `none`: Mengisolasi *container* tanpa akses jaringan.


* **Perintah Network:**
* Membuat jaringan: `docker network create --driver <driver> <namanetwork>`
* Menghubungkan container: `docker network connect <namanetwork> <namacontainer>`
* Memutuskan container: `docker network disconnect <namanetwork> <namacontainer>`



---

### 7. Pemeliharaan & Inspeksi

* **Docker Inspect:** Melihat rincian rinci dari suatu komponen (contoh: `docker container inspect <namacontainer>`).
* **Docker Prune:** Membersihkan *resource* yang sudah tidak digunakan:
* `docker container prune` (container terhenti)
* `docker image prune` (image tidak terpakai)
* `docker volume prune` (volume tidak terikat)
* `docker network prune` (network tidak terpakai)
* `docker system prune` (membersihkan seluruh resource sekaligus)