import 'package:hive/hive.dart';
import 'package:hive/src/binary/frame.dart';
import 'package:hive/src/box/keystore.dart';

export 'package:hive/src/backend/stub/backend_manager.dart'
    if (dart.library.io) 'package:hive/src/backend/vm/backend_manager.dart'
    if (dart.library.html) 'package:hive/src/backend/js/backend_manager.dart';

/// Abstract storage backend
abstract class StorageBackendd {
  /// The path where the database is stored
  String? get path;

  /// Whether the database can be compacted
  bool get supportsCompaction;

  /// Prepare backend
  Future<void> initialize(TypeRegistry registry, Keystore keystore, bool lazy);

  /// Read value from backend
  Future<dynamic> readValue(Frame frame);

  /// Write a list of frames to the backend
  Future<void> writeFrames(List<Frame> frames);

  /// Compact database
  Future<void> compact(Iterable<Frame> frames);

  /// Clear database
  Future<void> clear();

  /// Close database
  Future<void> close();

  /// Clear database and delete from disk
  Future<void> deleteFromDisk();
}

/// Abstract database manager
abstract class BackendManagerInterface {
  /// Opens database connection and creates StorageBackend
  Future<StorageBackendd> open(
      String name, String path, bool crashRecovery, HiveCipher cipher);

  /// Deletes database
  Future<void> deleteBox(String name, String? path);

  /// Checks if box exists
  Future<bool> boxExists(String name, String? path);
}
