import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/src/constants/appwrite_constants.dart';

final appWriteClientProvider = Provider<Client>((ref) {
  final Client client = Client();
  return client
      .setEndpoint(AppWriteConstants.endPoint)
      .setProject(AppWriteConstants.projectId)
      .setSelfSigned(status: true);
});

final accountProvider = Provider<Account>((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Account(client);
});

final databasesProvider = Provider<Databases>((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Databases(client);
});

final storageProvider = Provider<Storage>((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Storage(client);
});

final realtimeProvider = Provider<Realtime>((ref) {
  final client = ref.watch(appWriteClientProvider);
  return Realtime(client);
});
