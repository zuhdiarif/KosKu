import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/models/notification_model.dart';

class NotificationService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<NotificationModel>> getByOwnerId(String ownerId) async {
    final data = await _client.from('notifications').select().eq('owner_id', ownerId).order('created_at');
    return data.map((e) => NotificationModel.fromJson(e)).toList();
  }

  Future<void> create(NotificationModel notification) async {
    await _client.from('notifications').insert(notification.toJson()..remove('id'));
  }

  Future<void> markAsSent(String id) async {
    await _client.from('notifications').update({'is_sent': true}).eq('id', id);
  }
}
