# 📋 LAPORAN ASESMEN PRAKTIKUM DPPB 2

**Nama:** Azhar Khairu Hafidz  
**NIM:** 707012400102  
**Kelas:** D4SIKC 4801

## SmartJob Mobile - Platform Portal Lowongan Kerja Berbasis Flutter

---

## 1. PENDAHULUAN

### 1.1 Latar Belakang

Dinas Tenaga Kerja Kabupaten Bandung membutuhkan sistem **SmartJob** sebagai platform portal lowongan kerja yang menghubungkan pencari kerja dengan perusahaan lokal. Aplikasi ini dibangun menggunakan **Flutter** untuk platform mobile (Android/iOS/Web).

Praktikum ini bertujuan untuk mengimplementasikan aplikasi mobile Flutter dengan menerapkan konsep-konsep yang telah dipelajari seperti Widget, Layout, Navigation, State Management, dan integrasi dengan RESTful API.

---

## 2. TUJUAN PRAKTIKUM

Tujuan dari praktikum ini adalah:

1. **Memahami struktur project Flutter** - Mampu membuat dan mengorganisasi project Flutter dengan baik
2. **Mengimplementasikan MaterialApp** - Menerapkan tema, named routes, dan konfigurasi aplikasi
3. **Menerapkan Navigation** - Menggunakan Named Routes dan BottomNavigationBar untuk navigasi antar halaman
4. **Membangun UI dengan Widget** - Menggunakan berbagai widget Flutter seperti ListView, Card, Form, dll
5. **Mengelola State** - Menerapkan state management dengan StatefulWidget dan setState()
6. **Membuat RESTful API** - Membangun backend API dengan Node.js/Express untuk autentikasi dan CRUD
7. **Mengintegrasikan File Upload** - Mengimplementasikan fitur upload file CV menggunakan file_picker

---

## 3. ALAT DAN BAHAN

### 3.1 Software yang Digunakan

| No  | Alat/Software             | Versi   | Fungsi                                       |
| --- | ------------------------- | ------- | -------------------------------------------- |
| 1   | Flutter SDK               | ^3.10.0 | Framework utama pengembangan aplikasi mobile |
| 2   | Dart                      | ^3.0.0  | Bahasa pemrograman untuk Flutter             |
| 3   | Visual Studio Code        | Latest  | Code editor / IDE                            |
| 4   | Node.js                   | ^18.0.0 | Runtime untuk backend API                    |
| 5   | npm                       | ^9.0.0  | Package manager untuk Node.js                |
| 6   | Chrome Browser            | Latest  | Testing aplikasi web                         |
| 7   | Android Studio / Emulator | Latest  | Testing aplikasi Android                     |
| 8   | Git                       | Latest  | Version control                              |

### 3.2 Dependencies Flutter (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0 # HTTP client untuk API calls
  file_picker: ^6.1.1 # Upload file CV
  shared_preferences: ^2.2.2 # Penyimpanan lokal
  path: ^1.8.3 # Manipulasi path file
```

### 3.3 Dependencies Node.js (package.json)

```json
{
  "dependencies": {
    "express": "^4.18.2", // Web framework
    "cors": "^2.8.5", // Cross-origin resource sharing
    "jsonwebtoken": "^9.0.2", // JWT authentication
    "multer": "^1.4.5-lts.1", // File upload handling
    "uuid": "^9.0.0" // Generate unique ID
  }
}
```

---

## 4. LANGKAH-LANGKAH PRAKTIKUM

### 4.1 Inisialisasi Project

```bash
# Langkah 1: Buat project Flutter baru
flutter create smartjob_mobile

# Langkah 2: Masuk ke direktori project
cd smartjob_mobile

# Langkah 3: Install dependencies
flutter pub get
```

### 4.2 Konfigurasi pubspec.yaml

Menambahkan dependencies yang dibutuhkan:

- `http` - untuk koneksi API
- `file_picker` - untuk upload file CV
- `shared_preferences` - untuk penyimpanan lokal
- `path` - untuk manipulasi path file

### 4.3 Struktur Folder Project

```
smartjob_mobile/
├── lib/
│   ├── main.dart                 # Entry point aplikasi
│   ├── data/
│   │   └── dummy_data.dart       # Data dummy lowongan & lamaran
│   ├── pages/
│   │   ├── home_page.dart        # Halaman utama
│   │   ├── lowongan_page.dart    # Daftar lowongan
│   │   ├── lamaran_page.dart     # Riwayat lamaran
│   │   ├── profile_page.dart     # Profil pengguna
│   │   ├── settings_page.dart    # Pengaturan
│   │   ├── login_page.dart       # Halaman login
│   │   ├── register_page.dart    # Halaman registrasi
│   │   └── apply_job_page.dart   # Form lamaran + upload
│   ├── widgets/
│   │   └── main_navigation.dart  # BottomNavigationBar
│   └── services/
│       ├── auth_service.dart     # Service autentikasi
│       └── lamaran_service.dart  # Service CRUD lamaran
├── api/
│   └── server.js                 # Backend RESTful API
└── pubspec.yaml                  # Konfigurasi dependencies
```

### 4.4 Langkah-Langkah Implementasi

| No  | Langkah           | File                   | Deskripsi                            |
| --- | ----------------- | ---------------------- | ------------------------------------ |
| 1   | Setup MaterialApp | `main.dart`            | Konfigurasi theme, routes, title     |
| 2   | Buat Data Dummy   | `dummy_data.dart`      | List lowongan & lamaran hardcoded    |
| 3   | Buat HomePage     | `home_page.dart`       | Sambutan, deskripsi, tombol navigasi |
| 4   | Buat BottomNavBar | `main_navigation.dart` | Navigasi 3 tab                       |
| 5   | Buat LowonganPage | `lowongan_page.dart`   | ListView dengan Card                 |
| 6   | Buat LamaranPage  | `lamaran_page.dart`    | ListView.builder riwayat             |
| 7   | Buat ProfilePage  | `profile_page.dart`    | CircleAvatar, info user              |
| 8   | Buat SettingsPage | `settings_page.dart`   | Switch & Checkbox                    |
| 9   | Buat API Backend  | `api/server.js`        | RESTful API Node.js                  |
| 10  | Integrasi API     | `services/*.dart`      | HTTP client Flutter                  |

### 4.5 Detail Implementasi Setiap File

#### A. main.dart (Entry Point)

- Membuat MaterialApp dengan konfigurasi tema Material 3
- Mendefinisikan Named Routes untuk navigasi
- Set initial route ke MainNavigation

#### B. dummy_data.dart (Data Dummy)

- Membuat List lowonganList berisi 8 data lowongan kerja
- Membuat List lamaranList berisi riwayat lamaran
- Membuat Map userProfile untuk data profil pengguna

#### C. HomePage (Halaman Utama)

- Menampilkan sambutan dan deskripsi aplikasi
- Tombol navigasi ke fitur utama menggunakan InkWell dan ElevatedButton
- Layout menggunakan Column dan Container

#### D. MainNavigation (BottomNavigationBar)

- Implementasi BottomNavigationBar dengan 3 item (Home, Lowongan, Lamaran)
- State management untuk \_selectedIndex
- Perpindahan halaman dengan IndexedStack

#### E. LowonganPage (Daftar Lowongan)

- ListView.builder untuk menampilkan daftar lowongan
- Card widget untuk setiap item lowongan
- Tombol "Lamar" untuk navigasi ke form lamaran

#### F. LamaranPage (Riwayat Lamaran)

- ListView.builder menampilkan riwayat lamaran user
- Status lamaran dengan warna berbeda (pending, accepted, rejected)

#### G. ProfilePage (Profil Pengguna)

- CircleAvatar untuk foto profil
- Informasi user (nama, email, telepon)
- Tombol navigasi ke settings dan logout

#### H. SettingsPage (Pengaturan)

- SwitchListTile untuk toggle notifikasi dan dark mode
- CheckboxListTile untuk filter jenis lowongan
- State management dengan setState()

#### I. ApplyJobPage (Form Lamaran)

- TextFormField untuk input data lamaran
- File picker untuk upload CV (PDF/DOC/DOCX)
- Validasi form dan submit ke lamaranList

#### J. API Backend (server.js)

- Express.js server dengan CORS enabled
- JWT authentication untuk login/register
- CRUD endpoints untuk lamaran
- Multer untuk file upload

---

## 5. HASIL DAN DOKUMENTASI PROGRAM

### 5.1 Screenshot Aplikasi

#### A. Halaman Utama (HomePage)

- Menampilkan sambutan "Selamat Datang di SmartJob Mobile"
- Deskripsi aplikasi portal lowongan kerja
- Tombol navigasi ke fitur Lowongan dan Profil

#### B. Halaman Lowongan (LowonganPage)

- Daftar lowongan kerja dalam bentuk Card
- Informasi: posisi, perusahaan, lokasi, tipe, gaji
- Tombol "Lamar Sekarang" pada setiap lowongan

#### C. Halaman Lamaran (LamaranPage)

- Riwayat lamaran yang telah diajukan
- Status lamaran dengan badge warna (Menunggu/Diterima/Ditolak)
- Tanggal pengajuan lamaran

#### D. Halaman Profil (ProfilePage)

- Foto profil dalam CircleAvatar
- Informasi pengguna: Nama, Email, Telepon, Alamat
- Tombol Settings dan Logout

#### E. Halaman Settings (SettingsPage)

- Switch untuk Notifikasi dan Dark Mode
- Checkbox untuk filter jenis lowongan
- Pengaturan disimpan dalam state

#### F. Form Lamaran (ApplyJobPage)

- Input: Nama Lengkap, Email, No. Telepon, Surat Lamaran
- File picker untuk upload CV
- Validasi dan konfirmasi submit

### 5.2 Struktur Data

#### Data Lowongan (lowonganList)

```dart
{
  'id': '1',
  'posisi': 'Flutter Developer',
  'perusahaan': 'PT Teknologi Bandung',
  'lokasi': 'Bandung',
  'tipe': 'Full-time',
  'gaji': 'Rp 8.000.000 - Rp 12.000.000',
  'deskripsi': 'Mengembangkan aplikasi mobile...',
}
```

#### Data Lamaran (lamaranList)

```dart
{
  'id': '1',
  'posisi': 'Flutter Developer',
  'perusahaan': 'PT Teknologi Bandung',
  'status': 'Menunggu',
  'tanggal': '2024-01-15',
}
```

### 5.3 API Endpoints

| Method | Endpoint             | Fungsi                     |
| ------ | -------------------- | -------------------------- |
| POST   | `/api/auth/register` | Registrasi user baru       |
| POST   | `/api/auth/login`    | Login user                 |
| POST   | `/api/auth/logout`   | Logout user                |
| GET    | `/api/auth/profile`  | Ambil profil user          |
| GET    | `/api/lowongan`      | Ambil semua lowongan       |
| POST   | `/api/lamaran`       | Tambah lamaran (CREATE)    |
| GET    | `/api/lamaran`       | Ambil semua lamaran (READ) |
| PUT    | `/api/lamaran/:id`   | Update lamaran (UPDATE)    |
| DELETE | `/api/lamaran/:id`   | Hapus lamaran (DELETE)     |
| POST   | `/api/upload/cv`     | Upload file CV             |

---

## 7. KESIMPULAN

### 7.1 Hasil Implementasi

Aplikasi **SmartJob Mobile** berhasil diimplementasikan dengan fitur:

1. ✅ MaterialApp dengan Named Routes
2. ✅ BottomNavigationBar dengan 3 item
3. ✅ ListView/GridView untuk menampilkan lowongan
4. ✅ ListView.builder untuk riwayat lamaran
5. ✅ ProfilePage dengan CircleAvatar
6. ✅ SettingsPage dengan Switch dan Checkbox
7. ✅ RESTful API untuk autentikasi dan CRUD
8. ✅ Upload file CV

### 7.2 Kelebihan Aplikasi

- **UI Konsisten** - Menggunakan Material Design 3 untuk tampilan yang modern
- **Navigasi Intuitif** - Bottom navigation memudahkan user berpindah halaman
- **Responsive** - Tampilan menyesuaikan berbagai ukuran layar
- **Cross-Platform** - Kompatibel dengan Android, iOS, dan Web
- **Modular** - Struktur kode terorganisir dan mudah dikembangkan

### 7.3 Keterbatasan

- Data masih menggunakan dummy (hardcoded)
- API menggunakan in-memory storage (data hilang saat restart)
- Belum ada validasi role admin/user
- Belum ada fitur pencarian dan filter lowongan

### 7.4 Saran Pengembangan

1. Integrasi dengan database persistent (MySQL/PostgreSQL/MongoDB)
2. Implementasi fitur pencarian dan filter lowongan
3. Penambahan fitur notifikasi push
4. Implementasi autentikasi dengan OAuth (Google/Facebook)
5. Penambahan fitur chat antara pelamar dan perusahaan

---

## LAMPIRAN

### Cara Menjalankan Aplikasi

```bash
# 1. Install dependencies Flutter
cd smartjob_mobile
flutter pub get

# 2. Jalankan API Backend (terminal terpisah)
cd api
npm install
npm start

# 3. Jalankan Flutter
flutter run -d chrome    # Untuk web
flutter run -d android   # Untuk Android
flutter run -d ios       # Untuk iOS
```

### Demo Login

- **Email:** mahasiswa@email.com
- **Password:** password123

---

**Link Github:** [Repository SmartJob Mobile]
