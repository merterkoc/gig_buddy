// ignore_for_file: constant_identifier_names
import 'package:flutter_dotenv/flutter_dotenv.dart';

enum EnvVariables {
  BASE_URL('BASE_URL'),
  FIREBASE_DB_URI('FIREBASE_DB_URI');

  const EnvVariables(this.name);

  final String name;
}
