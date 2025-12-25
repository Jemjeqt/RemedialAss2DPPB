import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../data/dummy_data.dart';

class ApplyJobPage extends StatefulWidget {
  const ApplyJobPage({super.key});

  @override
  State<ApplyJobPage> createState() => _ApplyJobPageState();
}

class _ApplyJobPageState extends State<ApplyJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _pesanController = TextEditingController();
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;
  bool _isLoading = false;
  Map<String, dynamic>? _jobData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Get job data from arguments
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Map<String, dynamic>) {
      _jobData = args;
    }
  }

  @override
  void dispose() {
    _pesanController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true, // Penting untuk web - ambil bytes
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        setState(() {
          _selectedFileBytes = file.bytes;
          _selectedFileName = file.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error memilih file: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _removeFile() {
    setState(() {
      _selectedFileBytes = null;
      _selectedFileName = null;
    });
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulasi pengiriman lamaran (karena ini demo tanpa token)
    await Future.delayed(const Duration(seconds: 2));

    // Tambahkan lamaran baru ke lamaranList
    final now = DateTime.now();
    final tanggal =
        '${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    lamaranList.insert(0, {
      'posisi': _jobData?['posisi'] ?? 'Unknown',
      'perusahaan': _jobData?['perusahaan'] ?? 'Unknown',
      'status': 'Diproses',
      'tanggal': tanggal,
    });

    setState(() => _isLoading = false);

    if (mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 32,
                ),
              ),
              const SizedBox(width: 12),
              const Text('Berhasil!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lamaran Anda untuk posisi ${_jobData?['posisi'] ?? 'Unknown'} di ${_jobData?['perusahaan'] ?? 'Unknown'} telah berhasil dikirim.',
                style: const TextStyle(height: 1.4),
              ),
              const SizedBox(height: 12),
              Text(
                'Status lamaran dapat dilihat di halaman Riwayat Lamaran.',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context); // Back to previous page
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lamar Pekerjaan'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Job Info Card
                if (_jobData != null) _buildJobInfoCard(),

                const SizedBox(height: 24),

                // Form Section Title
                const Text(
                  'Formulir Lamaran',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1565C0),
                  ),
                ),

                const SizedBox(height: 16),

                // Pesan/Cover Letter
                TextFormField(
                  controller: _pesanController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText:
                        'Tulis pesan singkat tentang diri Anda dan mengapa Anda cocok untuk posisi ini...',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Pesan harus diisi';
                    }
                    if (value.length < 20) {
                      return 'Pesan minimal 20 karakter';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 24),

                // Upload CV Section
                const Text(
                  'Upload CV / Resume',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Format yang didukung: PDF, DOC, DOCX (Maks. 5MB)',
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                ),

                const SizedBox(height: 12),

                // File Upload Area
                InkWell(
                  onTap: _pickFile,
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: _selectedFileBytes != null
                          ? Colors.green.withOpacity(0.1)
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedFileBytes != null
                            ? Colors.green.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.3),
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: _selectedFileBytes != null
                        ? _buildSelectedFileWidget()
                        : _buildUploadPlaceholder(),
                  ),
                ),

                const SizedBox(height: 32),

                // Submit Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _submitApplication,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      _isLoading ? 'Mengirim...' : 'Kirim Lamaran',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Cancel Button
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text('Batal'),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJobInfoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.work, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _jobData?['posisi'] ?? 'Posisi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    Text(
                      _jobData?['perusahaan'] ?? 'Perusahaan',
                      style: TextStyle(
                        fontSize: 14,
                        color: Theme.of(
                          context,
                        ).colorScheme.primary.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoChip(Icons.location_on, _jobData?['lokasi'] ?? '-'),
              const SizedBox(width: 12),
              _buildInfoChip(Icons.schedule, _jobData?['tipe'] ?? '-'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 4),
          Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
        ],
      ),
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      children: [
        Icon(Icons.cloud_upload_outlined, size: 48, color: Colors.grey[400]),
        const SizedBox(height: 12),
        Text(
          'Tap untuk memilih file',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'atau drag & drop file di sini',
          style: TextStyle(fontSize: 13, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildSelectedFileWidget() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(0.2),
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.description, color: Colors.green, size: 32),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _selectedFileName ?? 'File',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'File berhasil dipilih',
                style: TextStyle(color: Colors.green[700], fontSize: 13),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: _removeFile,
          icon: const Icon(Icons.close, color: Colors.red),
          tooltip: 'Hapus file',
        ),
      ],
    );
  }
}
