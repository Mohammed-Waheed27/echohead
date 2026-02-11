import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationPermissionHandler {
  /// Request location permissions and handle the result
  static Future<bool> requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Show dialog to enable location services
      await _showEnableLocationDialog(context);
      return false;
    }

    // Check current permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Request permission
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        await _showPermissionDeniedDialog(context);
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await _showPermissionPermanentlyDeniedDialog(context);
      return false;
    }

    // Permission granted
    return true;
  }

  /// Show dialog to enable location services
  static Future<void> _showEnableLocationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, color: Colors.orange),
            SizedBox(width: 8),
            Text(
              'تفعيل خدمات الموقع',
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        content: const Text(
          'يرجى تفعيل خدمات الموقع من إعدادات الجهاز للاستفادة من ميزة البحث عن أقرب حاوية.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'حسناً',
              textDirection: TextDirection.rtl,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
            child: const Text(
              'فتح الإعدادات',
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog when permission is denied
  static Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'إذن الموقع مطلوب',
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        content: const Text(
          'نحتاج إلى إذن الوصول إلى موقعك للعثور على أقرب حاوية نفايات.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              textDirection: TextDirection.rtl,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text(
              'فتح الإعدادات',
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }

  /// Show dialog when permission is permanently denied
  static Future<void> _showPermissionPermanentlyDeniedDialog(
      BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.block, color: Colors.red),
            SizedBox(width: 8),
            Text(
              'إذن الموقع محظور',
              textDirection: TextDirection.rtl,
            ),
          ],
        ),
        content: const Text(
          'تم رفض إذن الموقع بشكل دائم. يرجى فتح الإعدادات وتمكين إذن الموقع يدوياً.',
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'إلغاء',
              textDirection: TextDirection.rtl,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openAppSettings();
            },
            child: const Text(
              'فتح الإعدادات',
              textDirection: TextDirection.rtl,
            ),
          ),
        ],
      ),
    );
  }
}

