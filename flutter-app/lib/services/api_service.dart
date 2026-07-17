import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  // Django server runs on port 7000
  // For web: localhost:7000
  // For mobile: 10.0.2.2:7000 (Android emulator) or 192.168.29.91:7000 (device)
  static const String _defaultBaseUrlWeb = 'http://localhost:7000';
  static const String _defaultBaseUrlMobile = 'http://10.0.2.2:7000';

  /// Get base URL from SharedPreferences
  static Future<String> getBaseUrl() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedUrl = prefs.getString('server_url');

      if (savedUrl != null && savedUrl.isNotEmpty) {
        print('Using saved server URL: $savedUrl');
        return savedUrl;
      }

      // Return appropriate default based on platform
      final defaultUrl = kIsWeb ? _defaultBaseUrlWeb : _defaultBaseUrlMobile;
      print('Using default server URL: $defaultUrl');
      return defaultUrl;
    } catch (e) {
      print('Error getting base URL: $e');
      return "http://127.0.0.1:7000/";
    }
  }

  /// User Registration
  static Future<Map<String, dynamic>> registerUser({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String phoneNo,
  }) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/user_register'),
        body: {
          'email': email,
          'password': password,
          'confirmpassword': confirmPassword,
          'name': name,
          'phoneno': phoneNo,
          'housename': '',
          'place': '',
          'post': '',
          'pincode': '',
          'Latitude': '0.0',
          'Longitude': '0.0',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// User Login
  static Future<Map<String, dynamic>> loginUser({
    required String username,
    required String password,
  }) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/user_login'),
        body: {
          'username': username,
          'password': password,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Server error'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Get User Profile
  static Future<Map<String, dynamic>> getUserProfile(String userId) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/user_profile/$userId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to fetch profile'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Update User Profile
  static Future<Map<String, dynamic>> updateUserProfile(
    String userId, {
    required String name,
    required String email,
    required String phoneNo,
    required String houseName,
    required String place,
    required String post,
    required String pincode,
  }) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/update_profile/$userId'),
        body: {
          'name': name,
          'email': email,
          'phone_no': phoneNo,
          'house_name': houseName,
          'place': place,
          'post': post,
          'pincode': pincode,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to update profile'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Get All Weeds
  static Future<List<dynamic>> getWeeds() async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/weeds/'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get Plant Diseases
  static Future<List<dynamic>> getPlantDiseases() async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/plant_diseases/'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Get Fertilizers
  static Future<List<dynamic>> getFertilizers() async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/fertilizers/'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  /// Predict Weed using Image
  static Future<Map<String, dynamic>> predictWeed(List<int> imageBytes) async {
    try {
      final baseUrl = await getBaseUrl();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/predict_weed'),
      );

      print("bbbbbbbbb$request");

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'weed_image.jpg',
        ),
      );

      final response = await request.send().timeout(const Duration(seconds: 30000));
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseData);
      } else {
        return {'status': 'error', 'message': 'Prediction failed'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Change Password
  static Future<Map<String, dynamic>> changePassword(
    String userId, {
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/change_password/$userId'),
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Password change failed'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Submit Feedback
  static Future<Map<String, dynamic>> submitFeedback(
    String userId,
    String feedback,
  ) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/submit_feedback'),
        body: {
          'user_id': userId,
          'feedback': feedback,
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to submit feedback'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Predict Plant/Crop Disease using Image
  static Future<Map<String, dynamic>> predictPlant(List<int> imageBytes) async {
    try {
      final baseUrl = await getBaseUrl();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/predict_plant'),
      );

      print("object$request");

      request.files.add(
        http.MultipartFile.fromBytes(
          'image',
          imageBytes,
          filename: 'plant_image.jpg',
        ),
      );

      final response = await request.send().timeout(const Duration(seconds: 10000));
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return jsonDecode(responseData);
      } else {
        return {'status': 'error', 'message': 'Prediction failed'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Get Weed Details
  static Future<Map<String, dynamic>> getWeedDetails(String weedId) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/weeds/$weedId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to fetch weed details'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Get Plant Disease Details
  static Future<Map<String, dynamic>> getDiseaseDetails(String diseaseId) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/diseases/$diseaseId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to fetch disease details'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Get Fertilizer Details
  static Future<Map<String, dynamic>> getFertilizerDetails(
      String fertilizerId) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/fertilizers/$fertilizerId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to fetch fertilizer details'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Save Classification History
  static Future<Map<String, dynamic>> saveClassificationHistory(
    String userId,
    String classificationType,
    String itemName,
    double confidence,
  ) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.post(
        Uri.parse('$baseUrl/api/save_history'),
        body: {
          'user_id': userId,
          'type': classificationType,
          'item_name': itemName,
          'confidence': confidence.toString(),
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {'status': 'error', 'message': 'Failed to save history'};
      }
    } catch (e) {
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Get Classification History
  static Future<List<dynamic>> getClassificationHistory(String userId) async {
    try {
      final baseUrl = await getBaseUrl();
      final response = await http.get(
        Uri.parse('$baseUrl/api/history/$userId'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }
}

