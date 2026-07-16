import 'package:flutter/foundation.dart'; // عشان kIsWeb
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:html' as html;

class GuestService {
  static const String _guestIdKey = 'guest_user_id';
  static String? _cachedGuestId; // كاش داخلي عشان نمنع الاستدعاء المتكرر وتغيير القيم

  // 🔑 دالة الحصول على الـ Guest ID أو إنشائه مع حماية كاملة من التدمير والريستارت
  static Future<String> getOrCreateGuestId() async {
    // 0️⃣ لو الـ ID متشال في الميموري كاش نرجعه فوراً لتجنب العمليات غير اللازمة
    if (_cachedGuestId != null && _cachedGuestId!.isNotEmpty) {
      return _cachedGuestId!;
    }

    // 1️⃣ أولاً: في بيئة الويب (Chrome)
    if (kIsWeb) {
      // ننتظر 100 مللي ثانية فقط لضمان استقرار وتهيئة نافذة المتصفح لقراءة الـ LocalStorage
      await Future.delayed(const Duration(milliseconds: 100));
      
      String? webGuestId = html.window.localStorage[_guestIdKey];
      
      if (webGuestId != null && webGuestId.trim().isNotEmpty) {
        print("🎯 [WEB] Stable persistent Guest ID retrieved: $webGuestId");
        _cachedGuestId = webGuestId;
        return webGuestId;
      } else {
        // نتحقق مرة أخرى احتياطياً للتأكد تماماً أنه فارغ قبل الإنشاء
        String? doubleCheck = html.window.localStorage[_guestIdKey];
        if (doubleCheck != null && doubleCheck.isNotEmpty) {
          _cachedGuestId = doubleCheck;
          return doubleCheck;
        }

        // هنا فقط يتم إنشاء ID جديد لأن المتصفح فارغ تماماً فعلاً
        var uuid = const Uuid();
        String newGuestId = 'guest_web_${uuid.v4()}';
        
        html.window.localStorage[_guestIdKey] = newGuestId;
        print("🆕 [WEB] First time user! Created and saved Guest ID: $newGuestId");
        _cachedGuestId = newGuestId;
        return newGuestId;
      }
    } 
    
    // 2️⃣ ثانياً: في الموبايل
    else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? existingGuestId = prefs.getString(_guestIdKey);

      if (existingGuestId != null && existingGuestId.isNotEmpty) {
        print("🎯 [MOBILE] Found existing Guest ID: $existingGuestId");
        _cachedGuestId = existingGuestId;
        return existingGuestId;
      } else {
        var uuid = const Uuid();
        String newGuestId = 'guest_mobile_${uuid.v4()}';
        await prefs.setString(_guestIdKey, newGuestId);
        print("🆕 [MOBILE] Created and saved Guest ID: $newGuestId");
        _cachedGuestId = newGuestId;
        return newGuestId;
      }
    }
  }

  // 🗑️ دالة لمسح الـ ID
  static Future<void> clearGuestId() async {
    _cachedGuestId = null;
    if (kIsWeb) {
      html.window.localStorage.remove(_guestIdKey);
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove(_guestIdKey);
    }
  }
}