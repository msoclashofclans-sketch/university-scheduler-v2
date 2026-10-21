import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

class LicenseScreen extends StatefulWidget {
  const LicenseScreen({super.key});

  @override
  State<LicenseScreen> createState() => _LicenseScreenState();
}

class _LicenseScreenState extends State<LicenseScreen> {
  final TextEditingController _licenseController = TextEditingController();
  bool _isChecking = false;

  Future<void> _activateLicense() async {
    final code = _licenseController.text.trim();
    // کد لایسنس فرضی (می‌توانی تغییرش دهی)
    if (code == 'MASOUD-2026-VIP') {
      setState(() => _isChecking = true);
      final prefs = await SharedPreferences.getInstance();
      // ثبت تاریخ نصب و تاریخ انقضا (۴ ماه بعد)
      final now = DateTime.now();
      final expireDate = now.add(const Duration(days: 120)); // ۱۲۰ روز ~ ۴ ماه
      
      await prefs.setString('license_expire_date', expireDate.toIso8601String());
      
      if (mounted) {
        Navigator.pop(context, true);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('کد لایسنس نامعتبر است!'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('فعال‌سازی لایسنس'), backgroundColor: AppConstants.primaryColor, foregroundColor: Colors.white),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security_rounded, size: 80, color: AppConstants.primaryColor),
                const SizedBox(height: 20),
                const Text('اعتبار نسخه شما به پایان رسیده است.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text('برای ادامه استفاده، کد لایسنس دریافتی را وارد کنید.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 30),
                TextField(
                  controller: _licenseController,
                  decoration: InputDecoration(
                    labelText: 'کد لایسنس',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.key),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isChecking ? null : _activateLicense,
                    style: ElevatedButton.styleFrom(backgroundColor: AppConstants.primaryColor),
                    child: _isChecking 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('فعال‌سازی', style: TextStyle(fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
