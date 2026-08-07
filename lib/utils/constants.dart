class AppConstants {
  static const String appName = 'Kosmo';
  static const String appVersion = '1.0.0';
  static const Duration syncInterval = Duration(minutes: 5);
  static const String waMessageTemplate = 'Halo {name}, ini pengingat pembayaran kos bulan {month} sebesar Rp{amount}. Mohon segera dilunasi. Terima kasih.';
  static const String emailSubjectTemplate = 'Pengingat Pembayaran Kos - {month}';
  static const String emailBodyTemplate = 'Halo {name},\n\nIni pengingat pembayaran kos bulan {month} sebesar Rp{amount}.\nMohon segera dilunasi.\n\nTerima kasih,\n{ownerName}';
}
