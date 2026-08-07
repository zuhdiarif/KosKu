import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/models/kos_model.dart';

class KosService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<KosModel>> getAll() async {
    final data = await _client.from('kos').select().order('created_at');
    return data.map((e) => KosModel.fromJson(e)).toList();
  }

  Future<KosModel> getById(String id) async {
    final data = await _client.from('kos').select().eq('id', id).single();
    return KosModel.fromJson(data);
  }

  Future<void> create(KosModel kos) async {
    await _client.from('kos').insert(kos.toJson()..remove('id'));
  }

  Future<void> update(KosModel kos) async {
    await _client.from('kos').update(kos.toJson()).eq('id', kos.id);
  }

  Future<void> delete(String id) async {
    await _client.from('kos').delete().eq('id', id);
  }
}
