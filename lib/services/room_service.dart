import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/models/room_model.dart';

class RoomService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<List<RoomModel>> getByKosId(String kosId) async {
    final data = await _client.from('rooms').select().eq('kos_id', kosId).order('created_at');
    return data.map((e) => RoomModel.fromJson(e)).toList();
  }

  Future<RoomModel> getById(String id) async {
    final data = await _client.from('rooms').select().eq('id', id).single();
    return RoomModel.fromJson(data);
  }

  Future<void> create(RoomModel room) async {
    await _client.from('rooms').insert(room.toJson()..remove('id'));
  }

  Future<void> update(RoomModel room) async {
    await _client.from('rooms').update(room.toJson()).eq('id', room.id);
  }

  Future<void> delete(String id) async {
    await _client.from('rooms').delete().eq('id', id);
  }
}
