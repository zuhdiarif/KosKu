import 'dart:async';
import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/services/local_db_service.dart';

class SyncService {
  final LocalDbService _localDb;
  final SupabaseClient _supabase = Supabase.instance.client;
  StreamSubscription? _connectivitySubscription;
  bool _isSyncing = false;

  SyncService(this._localDb);

  void startListening() {
    _connectivitySubscription = Connectivity().onConnectivityChanged.listen((results) {
      if (results.any((r) => r != ConnectivityResult.none)) {
        syncAll();
      }
    });
  }

  void stopListening() {
    _connectivitySubscription?.cancel();
  }

  Future<void> syncAll() async {
    if (_isSyncing) return;
    _isSyncing = true;
    try {
      final unsyncedItems = await _localDb.getUnsyncedItems();
      for (final item in unsyncedItems) {
        try {
          final data = jsonDecode(item.data) as Map<String, dynamic>;
          switch (item.operation) {
            case 'insert':
              await _supabase.from(item.targetTable).insert(data);
              break;
            case 'update':
              await _supabase.from(item.targetTable).update(data).eq('id', item.recordId);
              break;
            case 'delete':
              await _supabase.from(item.targetTable).delete().eq('id', item.recordId);
              break;
          }
          await _localDb.markSynced(item.id);
        } catch (e) {
          debugPrint('Sync failed for ${item.targetTable}/${item.recordId}: $e');
        }
      }
    } finally {
      _isSyncing = false;
    }
  }

  Future<bool> isOnline() async {
    final results = await Connectivity().checkConnectivity();
    return results.any((r) => r != ConnectivityResult.none);
  }
}
