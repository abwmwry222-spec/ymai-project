class VipStoreHandler {
  bool _isUserVip = false;

  bool get isVip => _isUserVip;

  /// فحص صلاحيات الوصول للميزات المتقدمة
  bool hasAccessToFeature(String featureName) {
    List<String> vipExclusiveFeatures = [
      'export_4k',        // جودة 4K حصرية
      'remove_watermark', // إزالة الشعار حصري
    ];

    if (vipExclusiveFeatures.contains(featureName) && !_isUserVip) {
      return false; 
    }
    return true; 
  }

  /// تفعيل أو إلغاء الـ VIP
  void toggleVipStatus() {
    _isUserVip = !_isUserVip;
  }
}
