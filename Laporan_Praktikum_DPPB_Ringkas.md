# LAPORAN PRAKTIKUM DPPB
## SmartJob Mobile - Platform Portal Lowongan Kerja

---

## 1. TUJUAN PRAKTIKUM

Setelah menyelesaikan praktikum ini, mahasiswa mampu:
1. Mengimplementasikan **Bottom Navigation Bar** dan **Named Routes**
2. Menggunakan **ListView.builder** untuk menampilkan data
3. Membuat **Form** dengan validasi dan **Switch/Checkbox**
4. Mengintegrasikan aplikasi dengan **RESTful API**
5. Mengimplementasikan **autentikasi JWT** dan operasi **CRUD**
6. Melakukan **file upload** ke server

---

## 2. ALAT DAN BAHAN

| Kategori | Item | Versi/Keterangan |
|----------|------|------------------|
| Software | Flutter SDK | ≥3.10.0 |
| Software | Node.js | ≥18.x |
| Software | VS Code / Android Studio | Latest |
| Package Flutter | http | ^1.2.0 |
| Package Flutter | file_picker | ^8.0.0+1 |
| Package Flutter | shared_preferences | ^2.2.2 |
| Package Node.js | express, cors, bcryptjs, jsonwebtoken, multer | Latest |

---

## 3. LANGKAH-LANGKAH PRAKTIKUM

### 3.1 Setup Project
```bash
flutter create smartjob_mobile
cd smartjob_mobile
flutter pub get
```

### 3.2 Struktur Folder
```
lib/
├── main.dart                 # Entry point + Named Routes
├── data/dummy_data.dart      # Data dummy
├── pages/                    # Halaman aplikasi
│   ├── home_page.dart
│   ├── lowongan_page.dart    # ListView.builder
│   ├── lamaran_page.dart
│   ├── login_page.dart       # Form + validasi
│   └── settings_page.dart    # Switch/Checkbox
├── widgets/main_navigation.dart  # BottomNavigationBar
└── services/
    ├── auth_service.dart     # API autentikasi
    └── lamaran_service.dart  # CRUD API
```

### 3.3 Implementasi Named Routes (main.dart)
```dart
MaterialApp(
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
```

### 3.4 Implementasi Bottom Navigation
```dart
BottomNavigationBar(
  items: const [
    BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.work), label: 'Lowongan'),
    BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Lamaran'),
  ],
  currentIndex: _selectedIndex,
  onTap: (index) => setState(() => _selectedIndex = index),
)
```

### 3.5 ListView.builder
```dart
ListView.builder(
  itemCount: lowonganList.length,
  itemBuilder: (context, index) {
    return Card(
      child: ListTile(
        title: Text(lowonganList[index]['posisi']),
        subtitle: Text(lowonganList[index]['perusahaan']),
      ),
    );
  },
)
```

### 3.6 API Integration (CRUD)
```dart
// CREATE
http.post(Uri.parse('$baseUrl/lamaran'), body: data);

// READ
http.get(Uri.parse('$baseUrl/lamaran'), headers: {'Authorization': 'Bearer $token'});

// UPDATE
http.put(Uri.parse('$baseUrl/lamaran/$id'), body: data);

// DELETE
http.delete(Uri.parse('$baseUrl/lamaran/$id'));
```

### 3.7 Menjalankan Aplikasi
```bash
# Terminal 1 - Backend
cd api && npm install && npm start

# Terminal 2 - Flutter
flutter run
```

---

## 4. HASIL DAN DOKUMENTASI PROGRAM

### Fitur yang Diimplementasikan

| Fitur | Widget/Teknologi | Status |
|-------|------------------|--------|
| Navigasi Utama | BottomNavigationBar | ✅ |
| Perpindahan Halaman | Named Routes | ✅ |
| Daftar Lowongan | ListView.builder | ✅ |
| Riwayat Lamaran | ListView.builder | ✅ |
| Login/Register | Form + TextFormField | ✅ |
| Pengaturan | Switch, Checkbox | ✅ |
| Apply Job | Form + file_picker | ✅ |
| Autentikasi | JWT Token | ✅ |
| CRUD Lamaran | HTTP Methods | ✅ |

### API Endpoints

| Method | Endpoint | Fungsi |
|--------|----------|--------|
| POST | /api/auth/login | Login |
| POST | /api/auth/register | Register |
| GET | /api/lowongan | Ambil lowongan |
| POST | /api/lamaran | Create lamaran |
| GET | /api/lamaran | Read lamaran |
| PUT | /api/lamaran/:id | Update lamaran |
| DELETE | /api/lamaran/:id | Delete lamaran |

### Demo User
```
Email: mahasiswa@email.com
Password: password123
```

---

## 5. ANALISIS DAN PEMBAHASAN

### 5.1 Arsitektur
```
┌─────────────────────────┐
│   Presentation (Pages)  │
├─────────────────────────┤
│   Services (API Layer)  │
├─────────────────────────┤
│   HTTP Client / Backend │
└─────────────────────────┘
```

### 5.2 Analisis Komponen Utama

| Komponen | Analisis |
|----------|----------|
| **Named Routes** | Centralized routing, mudah maintenance, type-safe |
| **ListView.builder** | Lazy loading, efficient memory untuk list besar |
| **Form Validation** | Real-time validation, user-friendly error messages |
| **JWT Auth** | Stateless, secure token dengan expiry 24 jam |
| **CRUD Operations** | Full RESTful API dengan proper HTTP methods |

### 5.3 Kelebihan
- UI Material Design 3 modern
- Navigasi intuitif dengan bottom nav
- Secure authentication dengan JWT + bcrypt
- Clean architecture dengan service layer

### 5.4 Keterbatasan
- Database in-memory (data hilang saat restart)
- Belum ada state management (Provider/Bloc)
- Belum ada offline mode

---

## 6. KESIMPULAN

Praktikum berhasil mengimplementasikan aplikasi SmartJob Mobile dengan fitur:

| Capaian | Status |
|---------|--------|
| Bottom Navigation Bar | ✅ |
| Named Routes (6 halaman) | ✅ |
| ListView.builder | ✅ |
| Form dengan validasi | ✅ |
| Switch/Checkbox | ✅ |
| Integrasi RESTful API | ✅ |
| JWT Authentication | ✅ |
| CRUD Operations | ✅ |
| File Upload | ✅ |

Semua tujuan praktikum tercapai dengan baik. Aplikasi dapat dikembangkan lebih lanjut dengan menambahkan state management dan database production.

---

**SmartJob Mobile** © 2025 - Laporan Praktikum DPPB 2
