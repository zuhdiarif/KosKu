import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/models/tenant_model.dart';

class TenantService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<TenantModel>> getByKosId(String kosId) async {
    final data = await _client.from('tenants').select().eq('kos_id', kosId).order('created_at');
    return data.map((e) => TenantModel.fromJson(e)).toList();
  }

  Future<TenantModel> getById(String id) async {
    final data = await _client.from('tenants').select().eq('id', id).single();
    return TenantModel.fromJson(data);
  }

  Future<void> create(TenantModel tenant) async {
    await _client.from('tenants').insert(tenant.toJson()..remove('id'));
  }

  Future<void> update(TenantModel tenant) async {
    await _client.from('tenants').update(tenant.toJson()).eq('id', tenant.id);
  }

  Future<void> delete(String id) async {
    await _client.from('tenants').delete().eq('id', id);
  }
}
