class VipStoreHandler {
  bool _isUserVip = false;

  bool get isVip => _isUserVip;

  bool hasAccessToFeature(String featureName) {
    List<String> vipExclusiveFeatures = [
      'export_4k',        
      'remove_watermark', 
    ];

    if (vipExclusiveFeatures.contains(featureName) && !_isUserVip) {
      return false; 
    }
    return true; 
  }

  void toggleVipStatus() {
    _isUserVip = !_isUserVip;
  }
}
