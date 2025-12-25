import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class LamaranService {
  // Base URL untuk API - ganti sesuai dengan server Anda
  static const String baseUrl = 'http://localhost:3000/api';

  // CREATE - Menambah lamaran baru
  static Future<Map<String, dynamic>> createLamaran({
    required String token,
    required int lowonganId,
    required String pesan,
    File? cvFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/lamaran'),
      );

      // Headers
      request.headers['Authorization'] = 'Bearer $token';

      // Fields
      request.fields['lowongan_id'] = lowonganId.toString();
      request.fields['pesan'] = pesan;

      // Upload CV file jika ada
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
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'message': 'Lamaran berhasil dikirim',
        };
      } else {
        return {
          'success': false,
          'message':
              jsonDecode(response.body)['message'] ?? 'Gagal mengirim lamaran',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // READ - Mengambil semua lamaran user
  static Future<Map<String, dynamic>> getAllLamaran(String token) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lamaran'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Gagal mengambil data lamaran'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // READ - Mengambil detail lamaran berdasarkan ID
  static Future<Map<String, dynamic>> getLamaranById(
    String token,
    int id,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lamaran/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'data': jsonDecode(response.body)};
      } else {
        return {'success': false, 'message': 'Lamaran tidak ditemukan'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // UPDATE - Memperbarui lamaran
  static Future<Map<String, dynamic>> updateLamaran({
    required String token,
    required int id,
    String? pesan,
    File? cvFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/lamaran/$id'),
      );

      // Headers
      request.headers['Authorization'] = 'Bearer $token';

      // Fields
      if (pesan != null) {
        request.fields['pesan'] = pesan;
      }

      // Upload CV file baru jika ada
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

      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'message': 'Lamaran berhasil diperbarui',
        };
      } else {
        return {
          'success': false,
          'message':
              jsonDecode(response.body)['message'] ??
              'Gagal memperbarui lamaran',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // DELETE - Menghapus lamaran
  static Future<Map<String, dynamic>> deleteLamaran(
    String token,
    int id,
  ) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/lamaran/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Lamaran berhasil dihapus'};
      } else {
        return {
          'success': false,
          'message':
              jsonDecode(response.body)['message'] ?? 'Gagal menghapus lamaran',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }

  // Upload File CV saja (tanpa lamaran)
  static Future<Map<String, dynamic>> uploadCV({
    required String token,
    required File cvFile,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/upload/cv'),
      );

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath(
          'cv',
          cvFile.path,
          filename: path.basename(cvFile.path),
        ),
      );

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonDecode(response.body),
          'message': 'CV berhasil diupload',
        };
      } else {
        return {
          'success': false,
          'message': jsonDecode(response.body)['message'] ?? 'Gagal upload CV',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Terjadi kesalahan: $e'};
    }
  }
}
