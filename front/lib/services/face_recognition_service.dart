import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class FaceRecognitionService {
  // Cambia esta URL por la dirección IP donde esté ejecutándose tu servidor Python
  static const String baseUrl = 'http://192.168.214.69:5000';

  /// Convierte una imagen XFile de la cámara a base64
  static Future<String> _imageToBase64(XFile imageFile) async {
    final bytes = await imageFile.readAsBytes();
    return base64Encode(bytes);
  }

  /// Realiza el login con reconocimiento facial
  static Future<Map<String, dynamic>> login(XFile imageFile) async {
    try {
      final base64Image = await _imageToBase64(imageFile);

      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Error de conexión: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Realiza el logout con reconocimiento facial
  static Future<Map<String, dynamic>> logout(XFile imageFile) async {
    try {
      final base64Image = await _imageToBase64(imageFile);

      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'image': base64Image}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Error de conexión: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Registra un nuevo usuario con reconocimiento facial
  static Future<Map<String, dynamic>> register(
      XFile imageFile, String username) async {
    try {
      final base64Image = await _imageToBase64(imageFile);

      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'image': base64Image,
          'username': username,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Error de conexión: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: ${e.toString()}'};
    }
  }

  /// Muestra un diálogo con el resultado de la operación
  static void showResultDialog(
      BuildContext context, Map<String, dynamic> result) {
    final bool isSuccess = result['success'];
    final Color titleColor = isSuccess ? Colors.green[800]! : Colors.red[800]!;
    final Color messageColor = Colors.black;
    final Color buttonColor = isSuccess ? Colors.green : Colors.red;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text(
          isSuccess ? 'Éxito' : 'Error',
          style: TextStyle(
            color: titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        content: Text(
          result['message'] ?? '',
          style: TextStyle(
            color: messageColor,
            fontSize: 16,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: buttonColor,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 