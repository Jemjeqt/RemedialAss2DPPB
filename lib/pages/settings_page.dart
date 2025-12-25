import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // State untuk Switch/Checkbox
  bool _notifikasiLowongan = true;
  bool _modeGelap = false;
  bool _notifikasiStatus = true;
  bool _emailNotifikasi = false;
  bool _suaraNotifikasi = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.settings,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pengaturan Aplikasi',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      Text(
                        'Kelola preferensi Anda',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Settings List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notifikasi Section
                  _buildSectionTitle('Notifikasi'),
                  const SizedBox(height: 12),

                  _buildSwitchTile(
                    icon: Icons.notifications_active,
                    title: 'Notifikasi Lowongan Baru',
                    subtitle: 'Dapatkan notifikasi saat ada lowongan baru',
                    value: _notifikasiLowongan,
                    color: Colors.blue,
                    onChanged: (value) {
                      setState(() => _notifikasiLowongan = value);
                      _showSnackbar(
                        'Notifikasi Lowongan ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                      );
                    },
                  ),

                  _buildSwitchTile(
                    icon: Icons.update,
                    title: 'Notifikasi Status Lamaran',
                    subtitle: 'Dapatkan update status lamaran Anda',
                    value: _notifikasiStatus,
                    color: Colors.green,
                    onChanged: (value) {
                      setState(() => _notifikasiStatus = value);
                      _showSnackbar(
                        'Notifikasi Status ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                      );
                    },
                  ),

                  _buildSwitchTile(
                    icon: Icons.email,
                    title: 'Notifikasi Email',
                    subtitle: 'Terima notifikasi melalui email',
                    value: _emailNotifikasi,
                    color: Colors.orange,
                    onChanged: (value) {
                      setState(() => _emailNotifikasi = value);
                      _showSnackbar(
                        'Notifikasi Email ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                      );
                    },
                  ),

                  _buildSwitchTile(
                    icon: Icons.volume_up,
                    title: 'Suara Notifikasi',
                    subtitle: 'Aktifkan suara untuk notifikasi',
                    value: _suaraNotifikasi,
                    color: Colors.purple,
                    onChanged: (value) {
                      setState(() => _suaraNotifikasi = value);
                      _showSnackbar(
                        'Suara Notifikasi ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Tampilan Section
                  _buildSectionTitle('Tampilan'),
                  const SizedBox(height: 12),

                  _buildSwitchTile(
                    icon: Icons.dark_mode,
                    title: 'Mode Gelap',
                    subtitle: 'Aktifkan tema gelap untuk aplikasi',
                    value: _modeGelap,
                    color: Colors.indigo,
                    onChanged: (value) {
                      setState(() => _modeGelap = value);
                      _showSnackbar(
                        'Mode Gelap ${value ? 'diaktifkan' : 'dinonaktifkan'}',
                      );
                    },
                  ),

                  const SizedBox(height: 24),

                  // Checkbox Section
                  _buildSectionTitle('Preferensi Lainnya'),
                  const SizedBox(height: 12),

                  _buildCheckboxCard(),

                  const SizedBox(height: 24),

                  // Tombol Kembali
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Kembali'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1565C0),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required Color color,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(fontSize: 13, color: Colors.grey[600]),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: color,
        ),
      ),
    );
  }

  Widget _buildCheckboxCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Jenis Lowongan yang Diminati:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          const SizedBox(height: 12),
          _buildCheckboxItem('Full-time', true),
          _buildCheckboxItem('Part-time', false),
          _buildCheckboxItem('Kontrak', true),
          _buildCheckboxItem('Magang', false),
        ],
      ),
    );
  }

  Widget _buildCheckboxItem(String label, bool initialValue) {
    return StatefulBuilder(
      builder: (context, setLocalState) {
        bool isChecked = initialValue;
        return CheckboxListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(label),
          value: isChecked,
          onChanged: (value) {
            setLocalState(() => isChecked = value ?? false);
            _showSnackbar('$label ${value! ? 'dipilih' : 'tidak dipilih'}');
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: Theme.of(context).colorScheme.primary,
        );
      },
    );
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
