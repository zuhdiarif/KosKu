import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:kosmo/app.dart';
import 'package:kosmo/utils/supabase_config.dart';
import 'package:kosmo/providers/auth_provider.dart';
import 'package:kosmo/providers/kos_provider.dart';
import 'package:kosmo/providers/room_provider.dart';
import 'package:kosmo/providers/tenant_provider.dart';
import 'package:kosmo/providers/payment_provider.dart';
import 'package:kosmo/providers/notification_provider.dart';
import 'package:kosmo/services/database/kosmo_database.dart';
import 'package:kosmo/services/local_db_service.dart';
import 'package:kosmo/services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SupabaseConfig.url,
    publishableKey: SupabaseConfig.anonKey,
  );

  final database = KosmoDatabase();
  final localDbService = LocalDbService(database);
  final syncService = SyncService(localDbService);
  syncService.startListening();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KosProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
        ChangeNotifierProvider(create: (_) => TenantProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        Provider<KosmoDatabase>.value(value: database),
        Provider<LocalDbService>.value(value: localDbService),
        Provider<SyncService>.value(value: syncService),
      ],
      child: const KosmoApp(),
    ),
  );
}
