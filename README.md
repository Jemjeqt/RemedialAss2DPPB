# SmartJob Mobile

Platform Portal Lowongan Kerja Berbasis Mobile Flutter untuk Dinas Tenaga Kerja Kabupaten Bandung.

## 📋 Deskripsi

SmartJob Mobile adalah aplikasi mobile yang menghubungkan pencari kerja dengan perusahaan lokal di Kabupaten Bandung. Aplikasi ini dibangun menggunakan Flutter dan menyediakan fitur:

- **Halaman Utama (Home)** - Menampilkan informasi selamat datang dan navigasi utama
- **Daftar Lowongan** - Menampilkan lowongan pekerjaan dalam bentuk ListView/GridView
- **Riwayat Lamaran** - Menampilkan riwayat lamaran pengguna
- **Profil Pengguna** - Menampilkan informasi profil
- **Pengaturan** - Mengatur preferensi notifikasi dan tampilan

## 🚀 Cara Menjalankan

### Prerequisites

- Flutter SDK (>=3.10.0)
- Dart SDK
- Android Studio / VS Code
- Node.js (untuk API backend)

### Langkah-langkah

1. **Clone/Extract Project**

   ```bash
   cd smartjob_mobile
   ```

2. **Install Flutter Dependencies**

   ```bash
   flutter pub get
   ```

3. **Jalankan API Backend** (Opsional - untuk fitur autentikasi)

   ```bash
   cd api
   npm install
   npm start
   ```

   API akan berjalan di `http://localhost:3000`

4. **Jalankan Aplikasi Flutter**
   ```bash
   flutter run
   ```

## 📁 Struktur Project

```
smartjob_mobile/
├── lib/
│   ├── main.dart                    # Entry point aplikasi
│   ├── data/
│   │   └── dummy_data.dart          # Data dummy lowongan & lamaran
│   ├── pages/
│   │   ├── home_page.dart           # Halaman utama
│   │   ├── lowongan_page.dart       # Daftar lowongan pekerjaan
│   │   ├── lamaran_page.dart        # Riwayat lamaran
│   │   ├── profile_page.dart        # Profil pengguna
│   │   ├── settings_page.dart       # Pengaturan
│   │   ├── login_page.dart          # Halaman login
│   │   ├── register_page.dart       # Halaman registrasi
│   │   └── apply_job_page.dart      # Form lamaran pekerjaan
│   ├── widgets/
│   │   └── main_navigation.dart     # Bottom Navigation Bar
│   └── services/
│       ├── auth_service.dart        # Service autentikasi API
│       └── lamaran_service.dart     # Service CRUD lamaran
├── api/
│   ├── server.js                    # RESTful API Server (Node.js)
│   └── package.json                 # Dependencies API
├── assets/
│   └── images/                      # Folder untuk gambar
└── pubspec.yaml                     # Flutter dependencies
```

## 🛣️ Named Routes

| Route       | Page           | Deskripsi                                 |
| ----------- | -------------- | ----------------------------------------- |
| `/`         | MainNavigation | Bottom nav dengan Home, Lowongan, Lamaran |
| `/profile`  | ProfilePage    | Halaman profil pengguna                   |
| `/settings` | SettingsPage   | Halaman pengaturan                        |
| `/login`    | LoginPage      | Halaman login                             |
| `/register` | RegisterPage   | Halaman registrasi                        |
| `/apply`    | ApplyJobPage   | Form lamaran pekerjaan                    |

## 🔌 API Endpoints

### Authentication

- `POST /api/auth/register` - Registrasi pengguna baru
- `POST /api/auth/login` - Login pengguna
- `POST /api/auth/logout` - Logout
- `GET /api/auth/profile` - Ambil profil pengguna

### Lowongan

- `GET /api/lowongan` - Ambil semua lowongan
- `GET /api/lowongan/:id` - Ambil detail lowongan

### Lamaran (CRUD)

- `POST /api/lamaran` - Tambah lamaran baru (dengan upload CV)
- `GET /api/lamaran` - Ambil semua lamaran user
- `GET /api/lamaran/:id` - Ambil detail lamaran
- `PUT /api/lamaran/:id` - Update lamaran
- `DELETE /api/lamaran/:id` - Hapus lamaran

### Upload

- `POST /api/upload/cv` - Upload file CV
- `GET /api/download/:filename` - Download file

## 👤 Demo User

```
Email: mahasiswa@email.com
Password: password123
```

## 🎨 Tema Warna

- **Primary**: `#1565C0` (Blue)
- **Secondary**: `#42A5F5` (Light Blue)
- **Surface**: White
- **Background**: `#F5F5F5`

## ✨ Fitur Utama

1. **Bottom Navigation Bar** - 3 menu: Home, Lowongan, Lamaran
2. **ListView/GridView** - Menampilkan data lowongan dengan Card
3. **ListView.builder** - Menampilkan riwayat lamaran
4. **Switch/Checkbox** - Pengaturan notifikasi dan mode gelap
5. **Named Routes** - Navigasi dengan route name
6. **RESTful API** - Backend dengan autentikasi JWT
7. **File Upload** - Upload CV (PDF, DOC, DOCX)

## 📱 Screenshots

Aplikasi menampilkan:

- Halaman Home dengan banner, tombol navigasi, dan statistik
- Daftar lowongan dengan filter berdasarkan tipe
- Riwayat lamaran dengan status (Diproses, Diterima, Ditolak)
- Profil dengan avatar dan informasi user
- Settings dengan toggle notifikasi dan mode gelap

## 📝 Catatan

- Data lowongan dan lamaran menggunakan dummy data hardcoded
- API backend menggunakan in-memory storage (data hilang saat server restart)
- Untuk production, ganti dengan database yang sesuai (MySQL, PostgreSQL, MongoDB)

## 👨‍💻 Dibuat Untuk

Asesmen Praktikum DPPB 2 - Platform Portal Lowongan Kerja Berbasis Web Flutter

---
