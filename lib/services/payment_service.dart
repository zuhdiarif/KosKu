import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/models/payment_model.dart';

class PaymentService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<PaymentModel>> getAll() async {
    final data = await _client.from('payments').select().order('created_at', ascending: false);
    return data.map((e) => PaymentModel.fromJson(e)).toList();
  }

  Future<List<PaymentModel>> getByTenantId(String tenantId) async {
    final data = await _client.from('payments').select().eq('tenant_id', tenantId).order('created_at', ascending: false);
    return data.map((e) => PaymentModel.fromJson(e)).toList();
  }

  Future<List<PaymentModel>> getOverdue() async {
    final data = await _client.from('payments').select().or('status.eq.overdue,status.eq.pending').order('created_at', ascending: false);
    return data.map((e) => PaymentModel.fromJson(e)).toList();
  }

  Future<void> create(PaymentModel payment) async {
    await _client.from('payments').insert(payment.toJson()..remove('id'));
  }

  Future<void> update(PaymentModel payment) async {
    await _client.from('payments').update(payment.toJson()).eq('id', payment.id);
  }

  Future<void> delete(String id) async {
    await _client.from('payments').delete().eq('id', id);
  }
}
