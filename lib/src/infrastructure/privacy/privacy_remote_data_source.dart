import 'package:cloud_functions/cloud_functions.dart';

abstract class PrivacyRemoteDataSource {
  Future<void> deleteUserData(String userId);
}

class FunctionsPrivacyRemoteDataSource implements PrivacyRemoteDataSource {
  FunctionsPrivacyRemoteDataSource({FirebaseFunctions? functions})
      : _functions = functions ?? FirebaseFunctions.instance;

  final FirebaseFunctions _functions;

  @override
  Future<void> deleteUserData(String userId) async {
    try {
      final callable = _functions.httpsCallable('privacy-deleteUserData');
      await callable.call(<String, dynamic>{'userId': userId});
    } on FirebaseFunctionsException catch (error) {
      throw PrivacyRemoteException(error.message ?? error.code);
    } catch (error) {
      throw PrivacyRemoteException(error.toString());
    }
  }
}

class NoopPrivacyRemoteDataSource implements PrivacyRemoteDataSource {
  const NoopPrivacyRemoteDataSource();

  @override
  Future<void> deleteUserData(String userId) async {}
}

class PrivacyRemoteException implements Exception {
  PrivacyRemoteException(this.message);

  final String message;

  @override
  String toString() => 'PrivacyRemoteException: $message';
}
