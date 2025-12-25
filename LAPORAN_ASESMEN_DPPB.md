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

### 4.5 Implementasi Kode

#### A. main.dart - Entry Point dengan Named Routes

```dart
import 'package:flutter/material.dart';
import 'pages/profile_page.dart';
import 'pages/settings_page.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/apply_job_page.dart';
import 'widgets/main_navigation.dart';

void main() {
  runApp(const SmartJobApp());
}

class SmartJobApp extends StatelessWidget {
  const SmartJobApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartJob Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          primary: const Color(0xFF1565C0),
          secondary: const Color(0xFF42A5F5),
          surface: Colors.white,
        ),
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1565C0),
          foregroundColor: Colors.white,
          elevation: 2,
          centerTitle: true,
        ),
        useMaterial3: true,
      ),
      // Named Routes
      initialRoute: '/',
      routes: {
        '/': (context) => const MainNavigation(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/apply': (context) => const ApplyJobPage(),
      },
    );
  }
}
```

#### B. main_navigation.dart - BottomNavigationBar

```dart
import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/lowongan_page.dart';
import '../pages/lamaran_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const LowonganPage(),
    const LamaranPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work_outline),
            activeIcon: Icon(Icons.work),
            label: 'Lowongan',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.description_outlined),
            activeIcon: Icon(Icons.description),
            label: 'Lamaran',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
```

#### C. dummy_data.dart - Data Dummy

```dart
// Data Dummy Lowongan Pekerjaan
final List<Map<String, String>> lowonganList = [
  {
    'posisi': 'Staff IT',
    'perusahaan': 'PT Maju Jaya',
    'lokasi': 'Soreang',
    'tipe': 'Full-time',
  },
  {
    'posisi': 'Admin Gudang',
    'perusahaan': 'CV Sumber Rejeki',
    'lokasi': 'Cileunyi',
    'tipe': 'Kontrak',
  },
  // ... data lainnya (8 lowongan)
];

// Data Dummy Riwayat Lamaran
List<Map<String, String>> lamaranList = [
  {
    'posisi': 'Staff IT',
    'perusahaan': 'PT Maju Jaya',
    'status': 'Diproses',
    'tanggal': '12-11-2025 08:30',
  },
  // ... data lainnya
];

// Data Dummy User Profile
final Map<String, String> userProfile = {
  'nama': 'Nama Mahasiswa',
  'email': 'mahasiswa@email.com',
  'nim': '123456789',
  'telepon': '081234567890',
};
```

#### D. lowongan_page.dart - ListView.builder

```dart
import 'package:flutter/material.dart';
import '../data/dummy_data.dart';

class LowonganPage extends StatelessWidget {
  const LowonganPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Lowongan Pekerjaan'),
      ),
      body: Column(
        children: [
          // Header Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
            child: Text(
              '${lowonganList.length} Lowongan Tersedia',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          // List Lowongan dengan ListView.builder
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: lowonganList.length,
              itemBuilder: (context, index) {
                final lowongan = lowonganList[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 3,
                  child: ListTile(
                    leading: Icon(Icons.business,
                        color: Theme.of(context).colorScheme.primary),
                    title: Text(
                      lowongan['posisi'] ?? '',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(lowongan['perusahaan'] ?? ''),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(lowongan['tipe'] ?? ''),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/apply', arguments: lowongan);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

#### E. auth_service.dart - HTTP API Client

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api';

  // Login
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': jsonDecode(response.body)['message']};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Register
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String email,
    required String password,
    required String nim,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nama': nama, 'email': email, 'password': password, 'nim': nim}),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      }
      return {'success': false, 'message': 'Registrasi gagal'};
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
```

#### F. lamaran_service.dart - CRUD Operations

```dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class LamaranService {
  static const String baseUrl = 'http://localhost:3000/api';

  // CREATE - Menambah lamaran baru
  static Future<Map<String, dynamic>> createLamaran({
    required String token,
    required int lowonganId,
    required String pesan,
    File? cvFile,
  }) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/lamaran'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['lowongan_id'] = lowonganId.toString();
    request.fields['pesan'] = pesan;

    if (cvFile != null) {
      request.files.add(await http.MultipartFile.fromPath('cv', cvFile.path));
    }

    var response = await http.Response.fromStream(await request.send());
    return response.statusCode == 201
        ? {'success': true, 'data': jsonDecode(response.body)}
        : {'success': false, 'message': 'Gagal mengirim lamaran'};
  }

  // READ - Mengambil semua lamaran
  static Future<Map<String, dynamic>> getAllLamaran(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lamaran'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200
        ? {'success': true, 'data': jsonDecode(response.body)}
        : {'success': false, 'message': 'Gagal mengambil data'};
  }

  // UPDATE - Memperbarui lamaran
  static Future<Map<String, dynamic>> updateLamaran({
    required String token,
    required int id,
    String? pesan,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl/lamaran/$id'),
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'pesan': pesan}),
    );
    return response.statusCode == 200
        ? {'success': true, 'data': jsonDecode(response.body)}
        : {'success': false, 'message': 'Gagal update'};
  }

  // DELETE - Menghapus lamaran
  static Future<Map<String, dynamic>> deleteLamaran(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/lamaran/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200
        ? {'success': true, 'message': 'Berhasil dihapus'}
        : {'success': false, 'message': 'Gagal hapus'};
  }
}
```

#### G. settings_page.dart - Switch dan Checkbox

```dart
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notifikasiAktif = true;
  bool _darkMode = false;
  bool _filterFullTime = true;
  bool _filterPartTime = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan')),
      body: ListView(
        children: [
          // Switch untuk Notifikasi
          SwitchListTile(
            title: const Text('Notifikasi'),
            subtitle: const Text('Aktifkan notifikasi lowongan baru'),
            value: _notifikasiAktif,
            onChanged: (value) => setState(() => _notifikasiAktif = value),
          ),
          // Switch untuk Dark Mode
          SwitchListTile(
            title: const Text('Mode Gelap'),
            subtitle: const Text('Gunakan tema gelap'),
            value: _darkMode,
            onChanged: (value) => setState(() => _darkMode = value),
          ),
          const Divider(),
          // Checkbox untuk Filter
          CheckboxListTile(
            title: const Text('Full-time'),
            value: _filterFullTime,
            onChanged: (value) => setState(() => _filterFullTime = value!),
          ),
          CheckboxListTile(
            title: const Text('Part-time'),
            value: _filterPartTime,
            onChanged: (value) => setState(() => _filterPartTime = value!),
          ),
        ],
      ),
    );
  }
}
```

#### H. server.js - Backend API (Node.js)

```javascript
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');

const app = express();
const JWT_SECRET = 'smartjob_secret_key_2025';

app.use(cors());
app.use(express.json());

// Middleware Auth
const authenticateToken = (req, res, next) => {
  const token = req.headers['authorization']?.split(' ')[1];
  if (!token) return res.status(401).json({ message: 'Token tidak ditemukan' });

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: 'Token tidak valid' });
    req.user = user;
    next();
  });
};

// LOGIN
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;
  const user = users.find(u => u.email === email);
  
  if (!user || !await bcrypt.compare(password, user.password)) {
    return res.status(401).json({ message: 'Email atau password salah' });
  }

  const token = jwt.sign({ id: user.id, email: user.email }, JWT_SECRET, { expiresIn: '24h' });
  res.json({ message: 'Login berhasil', user, token });
});

// CRUD LAMARAN
app.post('/api/lamaran', authenticateToken, (req, res) => { /* CREATE */ });
app.get('/api/lamaran', authenticateToken, (req, res) => { /* READ */ });
app.put('/api/lamaran/:id', authenticateToken, (req, res) => { /* UPDATE */ });
app.delete('/api/lamaran/:id', authenticateToken, (req, res) => { /* DELETE */ });

app.listen(3000, () => console.log('Server di http://localhost:3000'));
```

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

**Link Github:** [[Repository SmartJob Mobile](https://github.com/Jemjeqt/RemedialAss2DPPB)]
