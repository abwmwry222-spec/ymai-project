class VipStoreHandler {
  bool _isUserVip = false;

  bool get isVip => _isUserVip;

  /// التحقق من الصلاحيات للميزات المتقدمة
  bool hasAccessToFeature(String featureName) {
    List<String> vipExclusiveFeatures = [
      'export_4k',        // دقة 4K حصرية للـ VIP
      'remove_watermark', // إزالة العلامة المائية حصرية للـ VIP
    ];

    if (vipExclusiveFeatures.contains(featureName) && !_isUserVip) {
      return false; // ليس لديه صلاحية
    }
    return true; // متاح
  }

  /// تفعيل أو إلغاء تفعيل الـ VIP برمجياً لتجربة الزر
  void toggleVipStatus() {
    _isUserVip = !_isUserVip;
  }
}
