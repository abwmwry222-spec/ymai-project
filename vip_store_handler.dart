class VipStoreHandler {
  // المتغير الحقيقي المسؤول عن حالة الاشتراك (مجاني أو مدفوع Pro)
  bool _isVipUser = false;

  bool get isVip => _isVipUser;

  // دالة تحويل الحساب وتفعيل الاشتراك الحقيقي
  void toggleVipStatus() {
    _isVipUser = !_isVipUser;
  }

  // فحص الصلاحيات حقيقياً قبل السماح للمصمم باستخدام الأدوات القوية
  bool hasAccessToFeature(String featureKey) {
    if (featureKey == 'export_4k' || featureKey == 'remove_watermark') {
      // إذا كان الحساب VIP يسمح له فوراً، وإذا كان مجانياً يتم قفل الميزة
      return _isVipUser;
    }
    return true; // باقي الميزات الاحترافية العادية مفتوحة للجميع
  }
}
