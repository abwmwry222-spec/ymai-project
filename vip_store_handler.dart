class VipStoreHandler {
  // متغير بسيط لتحديد حالة الـ VIP (true تعني مشترك، false تعني مجاني)
  bool isVip = false;

  // دالة لتغيير حالة الاشتراك فوراً عند الضغط على الزر
  void toggleVipStatus() {
    isVip = !isVip;
  }

  // دالة فحص الصلاحيات لمعرفة هل الميزة مفتوحة أم مغلقة
  bool hasAccessToFeature(String featureKey) {
    if (featureKey == 'export_4k' || featureKey == 'remove_watermark') {
      return isVip; // لن يمنحه الوصول إلا إذا كان حساب VIP حقيقي
    }
    return true; // باقي الميزات العادية مفتوحة دائماً
  }
}
