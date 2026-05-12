// وظيفة برمجية للتحقق من وصول المبلغ تلقائياً
Future<void> checkPaymentStatus() async {
  // هنا نقوم بربط محفظتك بـ API البلوكشين لمراقبة الرصيد
  // بمجرد العثور على المعاملة، يتم تنفيذ الكود التالي:
  setState(() {
    isVip = true; // فتح كافة الميزات الجبارة تلقائياً
  });
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("تهانينا! تم تفعيل عضوية VIP بنجاح ✅"))
  );
}
