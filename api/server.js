const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const fs = require('fs');
const { v4: uuidv4 } = require('uuid');

const app = express();
const PORT = 3000;
const JWT_SECRET = 'smartjob_secret_key_2025';

// Middleware
app.use(cors());
app.use(express.json());
app.use('/uploads', express.static('uploads'));

// Buat folder uploads jika belum ada
if (!fs.existsSync('uploads')) {
  fs.mkdirSync('uploads');
}

// Konfigurasi Multer untuk upload file
const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, 'uploads/');
  },
  filename: (req, file, cb) => {
    const uniqueName = `${Date.now()}-${uuidv4()}${path.extname(file.originalname)}`;
    cb(null, uniqueName);
  }
});

const upload = multer({
  storage: storage,
  limits: { fileSize: 5 * 1024 * 1024 }, // 5MB max
  fileFilter: (req, file, cb) => {
    const allowedTypes = ['.pdf', '.doc', '.docx', '.jpg', '.jpeg', '.png'];
    const ext = path.extname(file.originalname).toLowerCase();
    if (allowedTypes.includes(ext)) {
      cb(null, true);
    } else {
      cb(new Error('Tipe file tidak didukung. Gunakan PDF, DOC, DOCX, JPG, atau PNG'));
    }
  }
});

// ==================== DATABASE DUMMY ====================
let users = [
  {
    id: 1,
    nama: 'Admin SmartJob',
    email: 'admin@smartjob.com',
    password: bcrypt.hashSync('admin123', 10),
    nim: '000000000',
    role: 'admin',
    createdAt: new Date().toISOString()
  },
  {
    id: 2,
    nama: 'Nama Mahasiswa',
    email: 'mahasiswa@email.com',
    password: bcrypt.hashSync('password123', 10),
    nim: '123456789',
    role: 'user',
    createdAt: new Date().toISOString()
  }
];

let lowongan = [
  { id: 1, posisi: 'Staff IT', perusahaan: 'PT Maju Jaya', lokasi: 'Soreang', tipe: 'Full-time', deskripsi: 'Bertanggung jawab untuk maintenance sistem IT perusahaan', createdAt: '2025-11-01' },
  { id: 2, posisi: 'Admin Gudang', perusahaan: 'CV Sumber Rejeki', lokasi: 'Cileunyi', tipe: 'Kontrak', deskripsi: 'Mengelola administrasi gudang dan stock barang', createdAt: '2025-11-05' },
  { id: 3, posisi: 'Marketing Executive', perusahaan: 'PT Berkah Sejahtera', lokasi: 'Banjaran', tipe: 'Full-time', deskripsi: 'Melakukan pemasaran produk dan mencari klien baru', createdAt: '2025-11-10' },
  { id: 4, posisi: 'Operator Produksi', perusahaan: 'PT Tekstil Makmur', lokasi: 'Majalaya', tipe: 'Kontrak', deskripsi: 'Mengoperasikan mesin produksi tekstil', createdAt: '2025-11-12' },
  { id: 5, posisi: 'Accounting Staff', perusahaan: 'CV Abadi Jaya', lokasi: 'Dayeuhkolot', tipe: 'Full-time', deskripsi: 'Mengelola pembukuan dan laporan keuangan', createdAt: '2025-11-15' },
  { id: 6, posisi: 'Customer Service', perusahaan: 'PT Telecom Indonesia', lokasi: 'Soreang', tipe: 'Part-time', deskripsi: 'Melayani pelanggan via telepon dan chat', createdAt: '2025-11-18' },
  { id: 7, posisi: 'Web Developer', perusahaan: 'PT Digital Kreatif', lokasi: 'Baleendah', tipe: 'Full-time', deskripsi: 'Mengembangkan website dan aplikasi web', createdAt: '2025-11-20' },
  { id: 8, posisi: 'HRD Staff', perusahaan: 'CV Mandiri Sukses', lokasi: 'Katapang', tipe: 'Full-time', deskripsi: 'Mengelola rekrutmen dan administrasi karyawan', createdAt: '2025-11-22' },
];

let lamaran = [
  { id: 1, userId: 2, lowonganId: 1, posisi: 'Staff IT', perusahaan: 'PT Maju Jaya', status: 'Diproses', pesan: 'Saya tertarik dengan posisi ini', cvPath: null, tanggal: '2025-11-12 08:30' },
  { id: 2, userId: 2, lowonganId: 2, posisi: 'Admin Gudang', perusahaan: 'CV Sumber Rejeki', status: 'Diterima', pesan: 'Saya memiliki pengalaman di bidang ini', cvPath: null, tanggal: '2025-11-15 09:00' },
  { id: 3, userId: 2, lowonganId: 3, posisi: 'Marketing Executive', perusahaan: 'PT Berkah Sejahtera', status: 'Ditolak', pesan: 'Mohon dipertimbangkan', cvPath: null, tanggal: '2025-11-18 10:15' },
];

let lamaranIdCounter = 4;
let userIdCounter = 3;

// ==================== MIDDLEWARE AUTH ====================
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({ message: 'Token tidak ditemukan' });
  }

  jwt.verify(token, JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({ message: 'Token tidak valid' });
    }
    req.user = user;
    next();
  });
};

// ==================== AUTH ROUTES ====================

// Register
app.post('/api/auth/register', async (req, res) => {
  try {
    const { nama, email, password, nim } = req.body;

    // Validasi input
    if (!nama || !email || !password || !nim) {
      return res.status(400).json({ message: 'Semua field harus diisi' });
    }

    // Cek email sudah terdaftar
    const existingUser = users.find(u => u.email === email);
    if (existingUser) {
      return res.status(400).json({ message: 'Email sudah terdaftar' });
    }

    // Hash password
    const hashedPassword = await bcrypt.hash(password, 10);

    // Simpan user baru
    const newUser = {
      id: userIdCounter++,
      nama,
      email,
      password: hashedPassword,
      nim,
      role: 'user',
      createdAt: new Date().toISOString()
    };
    users.push(newUser);

    // Generate token
    const token = jwt.sign(
      { id: newUser.id, email: newUser.email, role: newUser.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.status(201).json({
      message: 'Registrasi berhasil',
      user: {
        id: newUser.id,
        nama: newUser.nama,
        email: newUser.email,
        nim: newUser.nim,
        role: newUser.role
      },
      token
    });
  } catch (error) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
});

// Login
app.post('/api/auth/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Validasi input
    if (!email || !password) {
      return res.status(400).json({ message: 'Email dan password harus diisi' });
    }

    // Cari user
    const user = users.find(u => u.email === email);
    if (!user) {
      return res.status(401).json({ message: 'Email atau password salah' });
    }

    // Verifikasi password
    const validPassword = await bcrypt.compare(password, user.password);
    if (!validPassword) {
      return res.status(401).json({ message: 'Email atau password salah' });
    }

    // Generate token
    const token = jwt.sign(
      { id: user.id, email: user.email, role: user.role },
      JWT_SECRET,
      { expiresIn: '24h' }
    );

    res.json({
      message: 'Login berhasil',
      user: {
        id: user.id,
        nama: user.nama,
        email: user.email,
        nim: user.nim,
        role: user.role
      },
      token
    });
  } catch (error) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
});

// Logout
app.post('/api/auth/logout', authenticateToken, (req, res) => {
  res.json({ message: 'Logout berhasil' });
});

// Get Profile
app.get('/api/auth/profile', authenticateToken, (req, res) => {
  const user = users.find(u => u.id === req.user.id);
  if (!user) {
    return res.status(404).json({ message: 'User tidak ditemukan' });
  }

  res.json({
    id: user.id,
    nama: user.nama,
    email: user.email,
    nim: user.nim,
    role: user.role,
    createdAt: user.createdAt
  });
});

// ==================== LOWONGAN ROUTES ====================

// Get all lowongan
app.get('/api/lowongan', (req, res) => {
  res.json(lowongan);
});

// Get lowongan by ID
app.get('/api/lowongan/:id', (req, res) => {
  const item = lowongan.find(l => l.id === parseInt(req.params.id));
  if (!item) {
    return res.status(404).json({ message: 'Lowongan tidak ditemukan' });
  }
  res.json(item);
});

// ==================== LAMARAN ROUTES (CRUD) ====================

// CREATE - Tambah lamaran baru dengan upload file
app.post('/api/lamaran', authenticateToken, upload.single('cv'), (req, res) => {
  try {
    const { lowongan_id, pesan } = req.body;
    const userId = req.user.id;

    // Validasi input
    if (!lowongan_id) {
      return res.status(400).json({ message: 'Lowongan ID harus diisi' });
    }

    // Cari lowongan
    const job = lowongan.find(l => l.id === parseInt(lowongan_id));
    if (!job) {
      return res.status(404).json({ message: 'Lowongan tidak ditemukan' });
    }

    // Cek apakah sudah pernah melamar
    const existingLamaran = lamaran.find(
      l => l.userId === userId && l.lowonganId === parseInt(lowongan_id)
    );
    if (existingLamaran) {
      return res.status(400).json({ message: 'Anda sudah melamar posisi ini' });
    }

    // Buat lamaran baru
    const newLamaran = {
      id: lamaranIdCounter++,
      userId,
      lowonganId: parseInt(lowongan_id),
      posisi: job.posisi,
      perusahaan: job.perusahaan,
      status: 'Diproses',
      pesan: pesan || '',
      cvPath: req.file ? req.file.filename : null,
      tanggal: new Date().toLocaleString('id-ID', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric',
        hour: '2-digit',
        minute: '2-digit'
      }).replace(',', '')
    };
    lamaran.push(newLamaran);

    res.status(201).json({
      message: 'Lamaran berhasil dikirim',
      data: newLamaran
    });
  } catch (error) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
});

// READ - Get semua lamaran user
app.get('/api/lamaran', authenticateToken, (req, res) => {
  const userLamaran = lamaran.filter(l => l.userId === req.user.id);
  res.json(userLamaran);
});

// READ - Get lamaran by ID
app.get('/api/lamaran/:id', authenticateToken, (req, res) => {
  const item = lamaran.find(l => l.id === parseInt(req.params.id) && l.userId === req.user.id);
  if (!item) {
    return res.status(404).json({ message: 'Lamaran tidak ditemukan' });
  }
  res.json(item);
});

// UPDATE - Update lamaran
app.put('/api/lamaran/:id', authenticateToken, upload.single('cv'), (req, res) => {
  try {
    const lamaranIndex = lamaran.findIndex(
      l => l.id === parseInt(req.params.id) && l.userId === req.user.id
    );

    if (lamaranIndex === -1) {
      return res.status(404).json({ message: 'Lamaran tidak ditemukan' });
    }

    // Cek status - hanya bisa update jika masih diproses
    if (lamaran[lamaranIndex].status !== 'Diproses') {
      return res.status(400).json({ message: 'Lamaran tidak dapat diubah karena sudah diproses' });
    }

    // Update data
    if (req.body.pesan) {
      lamaran[lamaranIndex].pesan = req.body.pesan;
    }

    // Update CV jika ada file baru
    if (req.file) {
      // Hapus file lama jika ada
      if (lamaran[lamaranIndex].cvPath) {
        const oldPath = path.join('uploads', lamaran[lamaranIndex].cvPath);
        if (fs.existsSync(oldPath)) {
          fs.unlinkSync(oldPath);
        }
      }
      lamaran[lamaranIndex].cvPath = req.file.filename;
    }

    res.json({
      message: 'Lamaran berhasil diperbarui',
      data: lamaran[lamaranIndex]
    });
  } catch (error) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
});

// DELETE - Hapus lamaran
app.delete('/api/lamaran/:id', authenticateToken, (req, res) => {
  try {
    const lamaranIndex = lamaran.findIndex(
      l => l.id === parseInt(req.params.id) && l.userId === req.user.id
    );

    if (lamaranIndex === -1) {
      return res.status(404).json({ message: 'Lamaran tidak ditemukan' });
    }

    // Hapus file CV jika ada
    if (lamaran[lamaranIndex].cvPath) {
      const filePath = path.join('uploads', lamaran[lamaranIndex].cvPath);
      if (fs.existsSync(filePath)) {
        fs.unlinkSync(filePath);
      }
    }

    // Hapus lamaran
    lamaran.splice(lamaranIndex, 1);

    res.json({ message: 'Lamaran berhasil dihapus' });
  } catch (error) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
});

// ==================== UPLOAD ROUTES ====================

// Upload CV saja
app.post('/api/upload/cv', authenticateToken, upload.single('cv'), (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({ message: 'File tidak ditemukan' });
    }

    res.json({
      message: 'File berhasil diupload',
      filename: req.file.filename,
      originalName: req.file.originalname,
      size: req.file.size,
      path: `/uploads/${req.file.filename}`
    });
  } catch (error) {
    res.status(500).json({ message: 'Terjadi kesalahan server', error: error.message });
  }
});

// Download file
app.get('/api/download/:filename', authenticateToken, (req, res) => {
  const filePath = path.join(__dirname, 'uploads', req.params.filename);

  if (!fs.existsSync(filePath)) {
    return res.status(404).json({ message: 'File tidak ditemukan' });
  }

  res.download(filePath);
});

// ==================== ERROR HANDLER ====================
app.use((err, req, res, next) => {
  if (err instanceof multer.MulterError) {
    if (err.code === 'LIMIT_FILE_SIZE') {
      return res.status(400).json({ message: 'Ukuran file terlalu besar. Maksimal 5MB' });
    }
    return res.status(400).json({ message: err.message });
  }

  if (err) {
    return res.status(500).json({ message: err.message });
  }

  next();
});

// ==================== START SERVER ====================
app.listen(PORT, () => {
  console.log('====================================');
  console.log('   SmartJob API Server Running');
  console.log('====================================');
  console.log(`Server berjalan di http://localhost:${PORT}`);
  console.log('');
  console.log('Endpoints tersedia:');
  console.log('  AUTH:');
  console.log('    POST /api/auth/register');
  console.log('    POST /api/auth/login');
  console.log('    POST /api/auth/logout');
  console.log('    GET  /api/auth/profile');
  console.log('');
  console.log('  LOWONGAN:');
  console.log('    GET  /api/lowongan');
  console.log('    GET  /api/lowongan/:id');
  console.log('');
  console.log('  LAMARAN (CRUD):');
  console.log('    POST   /api/lamaran');
  console.log('    GET    /api/lamaran');
  console.log('    GET    /api/lamaran/:id');
  console.log('    PUT    /api/lamaran/:id');
  console.log('    DELETE /api/lamaran/:id');
  console.log('');
  console.log('  UPLOAD:');
  console.log('    POST /api/upload/cv');
  console.log('    GET  /api/download/:filename');
  console.log('====================================');
  console.log('');
  console.log('User Demo:');
  console.log('  Email: mahasiswa@email.com');
  console.log('  Password: password123');
  console.log('====================================');
});
