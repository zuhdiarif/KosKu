import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:kosmo/services/database/kosmo_database.dart';
import 'package:uuid/uuid.dart';

class LocalDbService {
  final KosmoDatabase _db;
  final Uuid _uuid = const Uuid();

  LocalDbService(this._db);

  String generateId() => _uuid.v4();

  Future<List<Ko>> getAllKos(String ownerId) {
    return (_db.select(_db.kos)..where((t) => t.ownerId.equals(ownerId))).get();
  }

  Future<int> insertKos(KosCompanion kos) {
    return _db.into(_db.kos).insert(kos);
  }

  Future<int> updateKos(KosCompanion kos, String id) {
    return (_db.update(_db.kos)..where((t) => t.id.equals(id))).write(kos);
  }

  Future<int> deleteKos(String id) {
    return (_db.delete(_db.kos)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Room>> getRoomsByKosId(String kosId) {
    return (_db.select(_db.rooms)..where((t) => t.kosId.equals(kosId))).get();
  }

  Future<int> insertRoom(RoomsCompanion room) {
    return _db.into(_db.rooms).insert(room);
  }

  Future<int> updateRoom(RoomsCompanion room, String id) {
    return (_db.update(_db.rooms)..where((t) => t.id.equals(id))).write(room);
  }

  Future<int> deleteRoom(String id) {
    return (_db.delete(_db.rooms)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Tenant>> getTenantsByKosId(String kosId) {
    return (_db.select(_db.tenants)..where((t) => t.kosId.equals(kosId))).get();
  }

  Future<int> insertTenant(TenantsCompanion tenant) {
    return _db.into(_db.tenants).insert(tenant);
  }

  Future<int> updateTenant(TenantsCompanion tenant, String id) {
    return (_db.update(_db.tenants)..where((t) => t.id.equals(id))).write(tenant);
  }

  Future<int> deleteTenant(String id) {
    return (_db.delete(_db.tenants)..where((t) => t.id.equals(id))).go();
  }

  Future<List<Payment>> getPaymentsByTenantId(String tenantId) {
    return (_db.select(_db.payments)..where((t) => t.tenantId.equals(tenantId))).get();
  }

  Future<List<Payment>> getOverduePayments() {
    return (_db.select(_db.payments)..where((t) => t.status.equals('overdue') | t.status.equals('pending'))).get();
  }

  Future<int> insertPayment(PaymentsCompanion payment) {
    return _db.into(_db.payments).insert(payment);
  }

  Future<int> updatePayment(PaymentsCompanion payment, String id) {
    return (_db.update(_db.payments)..where((t) => t.id.equals(id))).write(payment);
  }

  Future<int> deletePayment(String id) {
    return (_db.delete(_db.payments)..where((t) => t.id.equals(id))).go();
  }

  Future<void> addToSyncQueue(String targetTable, String recordId, String operation, Map<String, dynamic> data) {
    return _db.into(_db.syncQueue).insert(SyncQueueCompanion.insert(
      targetTable: targetTable,
      recordId: recordId,
      operation: operation,
      data: jsonEncode(data),
    ));
  }

  Future<List<SyncQueueData>> getUnsyncedItems() {
    return (_db.select(_db.syncQueue)..where((t) => t.isSynced.equals(false))).get();
  }

  Future<void> markSynced(int id) {
    return (_db.update(_db.syncQueue)..where((t) => t.id.equals(id))).write(
      const SyncQueueCompanion(isSynced: Value(true)),
    );
  }
}
