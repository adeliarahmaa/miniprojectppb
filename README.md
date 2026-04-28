## NAMA : ADELIA RAHMATUS SA'DIA
## NRP : 5025231054
## KELAS : PPB E


## LINK DEMO : https://drive.google.com/drive/folders/12gD2zDA8cSnYUNYsoRW5PPeKxkJzxm2n?usp=sharing


---

# MoodBite App

## Deskripsi Aplikasi

MoodBite adalah aplikasi mobile berbasis Flutter yang digunakan untuk mencatat konsumsi makanan harian serta memantau total kalori berdasarkan mode penggunaan. Aplikasi ini dirancang untuk membantu pengguna mengelola pola makan dengan lebih terstruktur melalui pencatatan makanan, perhitungan kalori, serta integrasi fitur kamera dan notifikasi.

---

## Fitur Aplikasi

### 1. Autentikasi Pengguna

* Login menggunakan email dan password melalui Firebase Authentication
* Registrasi akun pengguna baru
* Logout pengguna

---

### 2. Manajemen Data Makanan (CRUD)

* Menambahkan data makanan
* Menampilkan daftar makanan
* Menghapus data makanan
* Penyimpanan data menggunakan Cloud Firestore

---

### 3. Tracking Kalori Harian

* Perhitungan total kalori secara otomatis
* Mode aplikasi:

  * Diet Mode (target kalori lebih rendah)
  * Normal Mode (target kalori standar)

---

### 4. Kamera dan Upload Gambar

* Mengambil gambar makanan menggunakan kamera perangkat
* Mengunggah gambar ke Firebase Storage

---

### 5. Notifikasi

* Notifikasi saat makanan berhasil ditambahkan
* Notifikasi jika total kalori melebihi batas harian

---

## Tujuan Pengembangan

Aplikasi ini dibuat sebagai implementasi pembelajaran pengembangan aplikasi mobile menggunakan Flutter dengan integrasi Firebase. Fokus utama aplikasi adalah penerapan autentikasi, CRUD, penyimpanan cloud, penggunaan kamera, dan sistem notifikasi.

---

## Teknologi yang Digunakan

* Flutter
* Dart
* Firebase Authentication
* Cloud Firestore
* Firebase Storage
* Local Notifications
* Image Picker

---

## Cara Menjalankan Proyek

```bash
git clone https://github.com/adeliarahmaa/miniprojectppb.git
cd moodbite
flutter pub get
flutter run
```

---

## Mode Aplikasi

Pengguna dapat memilih mode saat menggunakan aplikasi:

* Diet Mode: untuk membatasi asupan kalori harian
* Normal Mode: untuk penggunaan standar tanpa batasan ketat

---


## Pengembangan Selanjutnya

* Fitur update/edit data makanan (CRUD lengkap)
* Grafik konsumsi kalori harian
* Reminder konsumsi makanan
* Rekomendasi makanan berbasis data

---



