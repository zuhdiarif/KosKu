import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kosmo/utils/constants.dart';

class WhatsappService {
  static Future<bool> sendReminder({
    required String phone,
    required String tenantName,
    required String month,
    required String amount,
  }) async {
    final cleanPhone = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (cleanPhone.isEmpty || cleanPhone.length < 8) return false;

    final message = AppConstants.waMessageTemplate
        .replaceAll('{name}', tenantName)
        .replaceAll('{month}', month)
        .replaceAll('{amount}', amount);
    final encodedMessage = Uri.encodeComponent(message);

    final String waPhone;
    if (cleanPhone.startsWith('62')) {
      waPhone = cleanPhone;
    } else if (cleanPhone.startsWith('0')) {
      waPhone = '62${cleanPhone.substring(1)}';
    } else {
      waPhone = '62$cleanPhone';
    }
    final uri = Uri.parse('https://wa.me/$waPhone?text=$encodedMessage');
    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      return false;
    }
  }

  static Future<bool> sendEmail({
    required String email,
    required String tenantName,
    required String month,
    required String amount,
    required String ownerName,
  }) async {
    if (email.trim().isEmpty) return false;

    final subject = AppConstants.emailSubjectTemplate.replaceAll('{month}', month);
    final body = AppConstants.emailBodyTemplate
        .replaceAll('{name}', tenantName)
        .replaceAll('{month}', month)
        .replaceAll('{amount}', amount)
        .replaceAll('{ownerName}', ownerName);

    try {
      final response = await Supabase.instance.client.functions.invoke(
        'send-email',
        body: {
          'to': email,
          'subject': subject,
          'body': body,
          'tenantName': tenantName,
          'month': month,
          'amount': amount,
          'ownerName': ownerName,
        },
      );
      if (response.status == 200) {
        return true;
      }
    } catch (_) {}

    final uri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {'subject': subject, 'body': body},
    );
    try {
      return await launchUrl(uri);
    } catch (_) {
      return false;
    }
  }
}
