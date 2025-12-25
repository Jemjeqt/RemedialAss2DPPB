# LAPORAN PRAKTIKUM
# Dasar Pemrograman Platform Berbasis Mobile (DPPB)

## Platform Portal Lowongan Kerja SmartJob Mobile
### Dinas Tenaga Kerja Kabupaten Bandung

---

## DAFTAR ISI

1. [Tujuan Praktikum](#1-tujuan-praktikum)
2. [Alat dan Bahan](#2-alat-dan-bahan)
3. [Langkah-Langkah Praktikum](#3-langkah-langkah-praktikum)
4. [Hasil dan Dokumentasi Program](#4-hasil-dan-dokumentasi-program)
5. [Analisis dan Pembahasan](#5-analisis-dan-pembahasan)
6. [Kesimpulan](#6-kesimpulan)

---

## 1. TUJUAN PRAKTIKUM

### 1.1 Tujuan Umum
Membangun aplikasi mobile portal lowongan kerja menggunakan framework Flutter yang terintegrasi dengan backend RESTful API.

### 1.2 Tujuan Khusus
Setelah menyelesaikan praktikum ini, mahasiswa diharapkan mampu:

1. **Navigasi Flutter**
   - Mengimplementasikan Bottom Navigation Bar untuk navigasi utama
   - Menggunakan Named Routes untuk perpindahan antar halaman
   - Mengirim data antar halaman menggunakan arguments

2. **Widget Display Data**
   - Menggunakan `ListView.builder` untuk menampilkan daftar data secara efisien
   - Membuat tampilan Card yang informatif dan menarik
   - Menampilkan Dialog untuk detail informasi

3. **Widget Input dan Interaksi**
   - Mengimplementasikan Form dengan validasi input
   - Menggunakan Switch dan Checkbox untuk pengaturan
   - Membuat interaksi pengguna yang responsif

4. **Integrasi API**
   - Menghubungkan aplikasi Flutter dengan RESTful API
   - Mengimplementasikan autentikasi menggunakan JWT (JSON Web Token)
   - Melakukan operasi CRUD (Create, Read, Update, Delete)

5. **File Handling**
   - Mengimplementasikan file picker untuk memilih file
   - Upload file ke server menggunakan multipart request

---

## 2. ALAT DAN BAHAN

### 2.1 Perangkat Keras (Hardware)
| No | Alat | Spesifikasi Minimum |
|----|------|---------------------|
| 1 | Komputer/Laptop | RAM 8GB, Storage 20GB free |
| 2 | Smartphone Android/iOS | Untuk testing (opsional) |

### 2.2 Perangkat Lunak (Software)

| No | Software | Versi | Fungsi |
|----|----------|-------|--------|
| 1 | Flutter SDK | ≥3.10.0 | Framework pengembangan mobile |
| 2 | Dart SDK | Included | Bahasa pemrograman |
| 3 | Android Studio / VS Code | Latest | IDE pengembangan |
| 4 | Node.js | ≥18.x | Runtime backend API |
| 5 | npm | ≥9.x | Package manager |
| 6 | Git | Latest | Version control |
| 7 | Chrome / Edge | Latest | Debugging web |
| 8 | Android Emulator / Physical Device | - | Testing aplikasi |

### 2.3 Dependencies Flutter (pubspec.yaml)

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8    # Icon iOS style
  http: ^1.2.0               # HTTP client untuk API
  file_picker: ^8.0.0+1      # File picker untuk upload
  shared_preferences: ^2.2.2 # Local storage
  path: ^1.9.0               # Path manipulation
```

### 2.4 Dependencies Backend (package.json)

```json
{
  "dependencies": {
    "express": "^4.18.2",      // Web framework
    "cors": "^2.8.5",          // Cross-origin resource sharing
    "bcryptjs": "^2.4.3",      // Password hashing
    "jsonwebtoken": "^9.0.2",  // JWT authentication
    "multer": "^1.4.5-lts.1",  // File upload
    "uuid": "^9.0.0"           // Unique ID generator
  }
}
```

---

## 3. LANGKAH-LANGKAH PRAKTIKUM

### 3.1 Persiapan Lingkungan

#### Langkah 1: Verifikasi Instalasi Flutter
```bash
flutter doctor
```
Pastikan semua komponen menunjukkan ✓ (centang hijau).

#### Langkah 2: Buat Project Baru
```bash
flutter create smartjob_mobile
cd smartjob_mobile
```

#### Langkah 3: Tambahkan Dependencies
Edit file `pubspec.yaml`, tambahkan dependencies yang diperlukan, kemudian jalankan:
```bash
flutter pub get
```

### 3.2 Membuat Struktur Folder

Buat struktur folder berikut di dalam folder `lib/`:

```
lib/
├── main.dart                 # Entry point aplikasi
├── data/
│   └── dummy_data.dart       # Data dummy untuk development
├── pages/
│   ├── home_page.dart        # Halaman utama
│   ├── lowongan_page.dart    # Daftar lowongan pekerjaan
│   ├── lamaran_page.dart     # Riwayat lamaran
│   ├── profile_page.dart     # Profil pengguna
│   ├── settings_page.dart    # Pengaturan
│   ├── login_page.dart       # Halaman login
│   ├── register_page.dart    # Halaman registrasi
│   └── apply_job_page.dart   # Form lamaran pekerjaan
├── widgets/
│   └── main_navigation.dart  # Bottom Navigation Bar
└── services/
    ├── auth_service.dart     # Service autentikasi API
    └── lamaran_service.dart  # Service CRUD lamaran
```

### 3.3 Implementasi Entry Point (main.dart)

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

### 3.4 Implementasi Bottom Navigation (main_navigation.dart)

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

### 3.5 Implementasi Data Dummy (dummy_data.dart)

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
  // ... data lainnya
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

### 3.6 Implementasi ListView.builder (lowongan_page.dart)

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
            padding: const EdgeInsets.all(16),
            child: Text('${lowonganList.length} Lowongan Tersedia'),
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
                  child: ListTile(
                    title: Text(lowongan['posisi'] ?? ''),
                    subtitle: Text(lowongan['perusahaan'] ?? ''),
                    trailing: Text(lowongan['tipe'] ?? ''),
                    onTap: () {
                      // Navigasi ke detail dengan arguments
                      Navigator.pushNamed(context, '/apply', 
                        arguments: lowongan);
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

### 3.7 Implementasi Auth Service (auth_service.dart)

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = 'http://localhost:3000/api';

  // Login
  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Login gagal',
        };
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
        body: jsonEncode({
          'nama': nama,
          'email': email,
          'password': password,
          'nim': nim,
        }),
      );

      if (response.statusCode == 201) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'],
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
```

### 3.8 Implementasi CRUD Lamaran Service (lamaran_service.dart)

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
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/lamaran'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['lowongan_id'] = lowonganId.toString();
    request.fields['pesan'] = pesan;

    if (cvFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'cv',
          cvFile.path,
          filename: path.basename(cvFile.path),
        ),
      );
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }
    return {'success': false, 'message': 'Gagal mengirim lamaran'};
  }

  // READ - Mengambil semua lamaran
  static Future<Map<String, dynamic>> getAllLamaran(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/lamaran'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }
    return {'success': false, 'message': 'Gagal mengambil data'};
  }

  // UPDATE - Memperbarui lamaran
  static Future<Map<String, dynamic>> updateLamaran({
    required String token,
    required int id,
    String? pesan,
    File? cvFile,
  }) async {
    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/lamaran/$id'),
    );
    request.headers['Authorization'] = 'Bearer $token';
    if (pesan != null) request.fields['pesan'] = pesan;

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return {'success': true, 'data': jsonDecode(response.body)};
    }
    return {'success': false, 'message': 'Gagal update lamaran'};
  }

  // DELETE - Menghapus lamaran
  static Future<Map<String, dynamic>> deleteLamaran(
    String token,
    int id,
  ) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/lamaran/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return {'success': true, 'message': 'Lamaran berhasil dihapus'};
    }
    return {'success': false, 'message': 'Gagal menghapus lamaran'};
  }
}
```

### 3.9 Setup dan Implementasi Backend API (server.js)

#### Langkah 1: Inisialisasi project Node.js
```bash
cd api
npm init -y
npm install express cors bcryptjs jsonwebtoken multer uuid
```

#### Langkah 2: Buat file server.js
```javascript
const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = 3000;
const JWT_SECRET = 'smartjob_secret_key_2025';

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// Konfigurasi Multer untuk upload file
const storage = multer.diskStorage({
  destination: (req, file, cb) => cb(null, 'uploads/'),
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${uuidv4()}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  }
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB max
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['.pdf', '.doc', '.docx'];
    const ext = path.extname(file.originalname).toLowerCase();
    if (allowedTypes.includes(ext)) cb(null, true);
    else cb(new Error('Tipe file tidak didukung'));
  }
});

// Database Dummy (In-Memory)
let users = [
  {
    id: 1,
    nama: 'Nama Mahasiswa',
    email: 'mahasiswa@email.com',
    password: bcrypt.hashSync('password123', 10),
    nim: '123456789',
    role: 'user'
  }
];

let lowongan = [
  { id: 1, posisi: 'Staff IT', perusahaan: 'PT Maju Jaya', lokasi: 'Soreang', tipe: 'Full-time' },
  { id: 2, posisi: 'Admin Gudang', perusahaan: 'CV Sumber Rejeki', lokasi: 'Cileunyi', tipe: 'Kontrak' },
  // ... data lainnya
];

let lamaran = [];

// Middleware Authentication
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) return res.status(401).json({ message: 'Token tidak ditemukan' });

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) return res.status(403).json({ message: 'Token tidak valid' });
    req.user = user;
    next();
  });
};

// AUTH ROUTES
app.post('/api/auth/login', async (req, res) => {
  const { email, password } = req.body;
  const user = users.find(u => u.email === email);
  
  if (!user || !await bcrypt.compare(password, user.password)) {
    return res.status(401).json({ message: 'Email atau password salah' });
  }

  const token = jwt.sign(
    { id: user.id, email: user.email, role: user.role },
    JWT_SECRET,
    { expiresIn: '24h' }
  );

  res.json({ message: 'Login berhasil', user: { ...user, password: undefined }, token });
});

app.post('/api/auth/register', async (req, res) => {
  const { nama, email, password, nim } = req.body;
  
  if (users.find(u => u.email === email)) {
    return res.status(400).json({ message: 'Email sudah terdaftar' });
  }

  const newUser = {
    id: users.length + 1,
    nama,
    email,
    password: await bcrypt.hash(password, 10),
    nim,
    role: 'user'
  };
  users.push(newUser);

  const token = jwt.sign({ id: newUser.id, email, role: 'user' }, JWT_SECRET, { expiresIn: '24h' });
  res.status(201).json({ message: 'Registrasi berhasil', user: { ...newUser, password: undefined }, token });
});

// CRUD LAMARAN ROUTES
app.post('/api/lamaran', authenticateToken, upload.single('cv'), (req, res) => {
  // CREATE
  const { lowongan_id, pesan } = req.body;
  const job = lowongan.find(l => l.id === parseInt(lowongan_id));
  
  if (!job) return res.status(404).json({ message: 'Lowongan tidak ditemukan' });

  const newLamaran = {
    id: lamaran.length + 1,
    userId: req.user.id,
    lowonganId: parseInt(lowongan_id),
    posisi: job.posisi,
    perusahaan: job.perusahaan,
    status: 'Diproses',
    pesan: pesan || '',
    cvPath: req.file ? req.file.filename : null,
    tanggal: new Date().toLocaleString('id-ID')
  };
  lamaran.push(newLamaran);

  res.status(201).json({ message: 'Lamaran berhasil dikirim', data: newLamaran });
});

app.get('/api/lamaran', authenticateToken, (req, res) => {
  // READ ALL
  const userLamaran = lamaran.filter(l => l.userId === req.user.id);
  res.json(userLamaran);
});

app.put('/api/lamaran/:id', authenticateToken, upload.single('cv'), (req, res) => {
  // UPDATE
  const lamaranIndex = lamaran.findIndex(l => l.id === parseInt(req.params.id) && l.userId === req.user.id);
  if (lamaranIndex === -1) return res.status(404).json({ message: 'Lamaran tidak ditemukan' });
  
  if (req.body.pesan) lamaran[lamaranIndex].pesan = req.body.pesan;
  if (req.file) lamaran[lamaranIndex].cvPath = req.file.filename;

  res.json({ message: 'Lamaran berhasil diperbarui', data: lamaran[lamaranIndex] });
});

app.delete('/api/lamaran/:id', authenticateToken, (req, res) => {
  // DELETE
  const lamaranIndex = lamaran.findIndex(l => l.id === parseInt(req.params.id) && l.userId === req.user.id);
  if (lamaranIndex === -1) return res.status(404).json({ message: 'Lamaran tidak ditemukan' });
  
  lamaran.splice(lamaranIndex, 1);
  res.json({ message: 'Lamaran berhasil dihapus' });
});

// GET LOWONGAN
app.get('/api/lowongan', (req, res) => res.json(lowongan));
app.get('/api/lowongan/:id', (req, res) => {
  const item = lowongan.find(l => l.id === parseInt(req.params.id));
  if (!item) return res.status(404).json({ message: 'Lowongan tidak ditemukan' });
  res.json(item);
});

// Start Server
app.listen(PORT, () => {
  console.log(`Server berjalan di http://localhost:${PORT}`);
});
```

### 3.10 Menjalankan Aplikasi

#### Terminal 1 - Jalankan Backend API:
```bash
cd smartjob_mobile/api
npm install
npm start
# Output: Server berjalan di http://localhost:3000
```

#### Terminal 2 - Jalankan Aplikasi Flutter:
```bash
cd smartjob_mobile
flutter pub get
flutter run
```

---

## 4. HASIL DAN DOKUMENTASI PROGRAM

### 4.1 Struktur Proyek Final

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
│   ├── server.js                    # RESTful API Server
│   ├── package.json                 # Dependencies API
│   └── uploads/                     # Folder upload CV
└── pubspec.yaml                     # Flutter dependencies
```

### 4.2 Named Routes yang Diimplementasikan

| Route | Halaman | Deskripsi |
|-------|---------|-----------|
| `/` | MainNavigation | Bottom nav dengan Home, Lowongan, Lamaran |
| `/profile` | ProfilePage | Halaman profil pengguna |
| `/settings` | SettingsPage | Halaman pengaturan |
| `/login` | LoginPage | Halaman login |
| `/register` | RegisterPage | Halaman registrasi |
| `/apply` | ApplyJobPage | Form lamaran pekerjaan |

### 4.3 API Endpoints yang Tersedia

**Authentication:**
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/auth/register` | Registrasi pengguna baru |
| POST | `/api/auth/login` | Login pengguna |
| POST | `/api/auth/logout` | Logout |
| GET | `/api/auth/profile` | Ambil profil pengguna |

**Lowongan:**
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| GET | `/api/lowongan` | Ambil semua lowongan |
| GET | `/api/lowongan/:id` | Ambil detail lowongan |

**Lamaran (CRUD):**
| Method | Endpoint | Deskripsi |
|--------|----------|-----------|
| POST | `/api/lamaran` | Tambah lamaran baru (Create) |
| GET | `/api/lamaran` | Ambil semua lamaran (Read) |
| GET | `/api/lamaran/:id` | Ambil detail lamaran (Read) |
| PUT | `/api/lamaran/:id` | Update lamaran (Update) |
| DELETE | `/api/lamaran/:id` | Hapus lamaran (Delete) |

### 4.4 Demo User untuk Testing

```
Email: mahasiswa@email.com
Password: password123
```

### 4.5 Fitur yang Berhasil Diimplementasikan

| No | Fitur | Status | Keterangan |
|----|-------|--------|------------|
| 1 | Home Page | ✅ | Banner, statistik, navigasi |
| 2 | Bottom Navigation Bar | ✅ | 3 menu: Home, Lowongan, Lamaran |
| 3 | Daftar Lowongan | ✅ | ListView.builder dengan 8 data |
| 4 | Detail Lowongan | ✅ | AlertDialog dengan tombol lamar |
| 5 | Riwayat Lamaran | ✅ | Summary status + list lamaran |
| 6 | Login | ✅ | Form dengan validasi + API |
| 7 | Register | ✅ | Registrasi user baru + API |
| 8 | Profile | ✅ | Informasi pengguna |
| 9 | Settings | ✅ | Switch notifikasi & dark mode |
| 10 | Apply Job | ✅ | Form + upload CV |
| 11 | CRUD Lamaran | ✅ | Create, Read, Update, Delete |
| 12 | JWT Authentication | ✅ | Token expires 24 jam |

---

## 5. ANALISIS DAN PEMBAHASAN

### 5.1 Arsitektur Aplikasi

Aplikasi SmartJob Mobile menggunakan arsitektur **layered** yang terdiri dari:

```
┌─────────────────────────────────────────────────┐
│          PRESENTATION LAYER (Pages)             │
│  HomePage, LowonganPage, LamaranPage, dll       │
├─────────────────────────────────────────────────┤
│         BUSINESS LOGIC LAYER (Services)         │
│         AuthService, LamaranService             │
├─────────────────────────────────────────────────┤
│              DATA LAYER (Models)                │
│         DummyData, API Response                 │
├─────────────────────────────────────────────────┤
│                  HTTP CLIENT                    │
│               package:http                      │
├─────────────────────────────────────────────────┤
│               BACKEND API                       │
│         Node.js + Express + JWT                 │
└─────────────────────────────────────────────────┘
```

### 5.2 Analisis Widget Flutter

| Widget | Penggunaan | Penjelasan |
|--------|-----------|------------|
| `MaterialApp` | Root widget | Menyediakan tema, routes, dan navigasi |
| `Scaffold` | Layout dasar | Mengatur AppBar, body, bottomNav |
| `BottomNavigationBar` | Navigasi utama | 3 item dengan icon dan label |
| `ListView.builder` | Daftar data | Efficient lazy loading |
| `Card` | Menampilkan item | Dengan elevation dan styling |
| `Form` | Input validation | Grouping TextFormField |
| `TextFormField` | Input text | Dengan validator |
| `Switch` | Toggle setting | On/off controller |
| `AlertDialog` | Detail popup | Menampilkan informasi detail |

### 5.3 Analisis Named Routes

**Keuntungan Named Routes:**
1. **Centralized** - Semua route didefinisikan di satu tempat (`main.dart`)
2. **Maintainable** - Mudah menambah/mengubah route
3. **Type Safe** - Menghindari typo pada route string
4. **Arguments Support** - Bisa mengirim data antar halaman

**Implementasi:**
```dart
// Definisi routes
routes: {
  '/': (context) => const MainNavigation(),
  '/apply': (context) => const ApplyJobPage(),
}

// Navigasi dengan arguments
Navigator.pushNamed(context, '/apply', arguments: lowongan);

// Menerima arguments
final args = ModalRoute.of(context)!.settings.arguments as Map;
```

### 5.4 Analisis CRUD Operations

| Operasi | HTTP Method | Service Method | Deskripsi |
|---------|-------------|----------------|-----------|
| CREATE | POST | `createLamaran()` | Menambah data baru ke server |
| READ | GET | `getAllLamaran()` | Mengambil list data dari server |
| UPDATE | PUT | `updateLamaran()` | Mengubah data existing |
| DELETE | DELETE | `deleteLamaran()` | Menghapus data dari server |

### 5.5 Analisis Autentikasi JWT

**Alur Autentikasi:**
```
1. User login dengan email & password
2. Server verifikasi credentials
3. Server generate JWT token
4. Client simpan token
5. Client kirim token di header setiap request
6. Server verifikasi token sebelum proses request
```

**Keamanan:**
- Token expires 24 jam
- Password di-hash dengan bcrypt (salt round 10)
- Token dikirim via Authorization header (Bearer scheme)

### 5.6 Analisis File Upload

**Frontend (Flutter):**
```dart
// Pick file
FilePickerResult? result = await FilePicker.platform.pickFiles(
  type: FileType.custom,
  allowedExtensions: ['pdf', 'doc', 'docx'],
);

// Upload dengan MultipartRequest
var request = http.MultipartRequest('POST', Uri.parse(url));
request.files.add(await http.MultipartFile.fromPath('cv', file.path));
```

**Backend (Multer):**
- Max file size: 5MB
- Allowed types: PDF, DOC, DOCX, JPG, PNG
- Unique filename: timestamp + UUID

### 5.7 Kelebihan Aplikasi

1. **UI/UX Modern** - Material Design 3 dengan tema konsisten
2. **Navigasi Intuitif** - Bottom navigation + named routes
3. **Efficient Rendering** - ListView.builder untuk performa optimal
4. **Secure Auth** - JWT dengan bcrypt password hashing
5. **File Upload** - Support upload CV dengan validasi tipe file
6. **Clean Architecture** - Separation of concerns dengan service layer

### 5.8 Keterbatasan dan Saran Pengembangan

| Keterbatasan | Saran Pengembangan |
|--------------|-------------------|
| In-memory database | Gunakan MySQL/PostgreSQL |
| Tanpa push notification | Implementasi Firebase FCM |
| Tanpa offline mode | Local database dengan SQLite |
| Tanpa state management | Gunakan Provider/Riverpod/Bloc |

---

## 6. KESIMPULAN

### 6.1 Ringkasan Hasil Praktikum

Praktikum ini berhasil mengimplementasikan aplikasi mobile SmartJob untuk portal lowongan kerja dengan fitur-fitur:

1. **Navigasi Flutter**
   - ✅ Bottom Navigation Bar dengan 3 menu
   - ✅ Named Routes untuk 6 halaman
   - ✅ Passing arguments antar halaman

2. **Widget Display Data**
   - ✅ ListView.builder untuk daftar lowongan dan lamaran
   - ✅ Card widget dengan styling modern
   - ✅ AlertDialog untuk detail informasi

3. **Widget Input**
   - ✅ Form dengan validasi (email, password)
   - ✅ Switch untuk toggle pengaturan
   - ✅ File picker untuk upload CV

4. **Integrasi API**
   - ✅ HTTP client untuk komunikasi dengan backend
   - ✅ JWT authentication (login/register)
   - ✅ CRUD operations (Create, Read, Update, Delete)

5. **Backend Development**
   - ✅ RESTful API dengan Express.js
   - ✅ JWT middleware untuk autentikasi
   - ✅ Multer untuk file upload

### 6.2 Capaian Pembelajaran

| Materi | Capaian |
|--------|---------|
| Flutter Widget | ✅ ListView, Card, Form, Dialog, Switch |
| State Management | ✅ StatefulWidget, setState |
| Navigation | ✅ Named Routes, arguments passing |
| HTTP Client | ✅ GET, POST, PUT, DELETE requests |
| File Handling | ✅ File picker, multipart upload |
| Backend | ✅ Express.js, JWT, Multer, bcrypt |

### 6.3 Kesimpulan Akhir

Aplikasi SmartJob Mobile berhasil dibangun sesuai dengan tujuan praktikum. Aplikasi ini mendemonstrasikan kemampuan Flutter dalam membangun aplikasi mobile yang terintegrasi dengan backend API. Fitur-fitur utama seperti navigasi, display data, input form, autentikasi, dan CRUD operations telah berhasil diimplementasikan dengan baik.

---

## REFERENSI

1. Flutter Documentation - https://flutter.dev/docs
2. Dart Language - https://dart.dev
3. Express.js Guide - https://expressjs.com
4. JWT.io - https://jwt.io
5. Material Design 3 - https://m3.material.io

---

**SmartJob Mobile** - Dinas Tenaga Kerja Kabupaten Bandung © 2025

*Laporan disusun untuk Asesmen Praktikum DPPB 2*
