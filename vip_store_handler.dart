import 'package:flutter/material.dart';

class KZVIPTemplate {
  final String id;
  final String title;
  final String category;
  final String duration;
  final IconData icon;

  KZVIPTemplate({
    required this.id,
    required this.title,
    required this.category,
    required this.duration,
    required this.icon,
  });
}

class KZVIPStoreHandler {
  // مكتبة القوالب والتأثيرات الحية الضخمة والحقيقية للتطبيق
  static List<KZVIPTemplate> getVIPStoreContent() {
    return [
      KZVIPTemplate(id: "1", title: "قالب تريند تيك توك: الانتقال السريع ⚡", category: "تيك توك", duration: "15", icon: Icons.bolt),
      KZVIPTemplate(id: "2", title: "تأثير النيون المتوهج ثلاثي الأبعاد AI 🔮", category: "تأثيرات Visual", duration: "42", icon: Icons.psychology),
      KZVIPTemplate(id: "3", title: "مقدمة سينمائية 4K: الشعار الذهبي المتوهج ✨", category: "Intros", duration: "08", icon: Icons.movie_filter),
      KZVIPTemplate(id: "4", title: "قالب ريلز إنستغرام: المونتاج السلو-موشن ⏱️", category: "إنستغرام", duration: "30", icon: Icons.slow_motion_video),
      KZVIPTemplate(id: "5", title: "تأثير زلزال الكاميرا (Camera Shake Trendy) 🎬", category: "تأثيرات Visual", duration: "25", icon: Icons.vibration),
      KZVIPTemplate(id: "6", title: "مقدمة لوجو احترافية: دخان سينمائي نيون 💨", category: "Intros", duration: "05", icon: Icons.cloud),
    ];
  }
}
