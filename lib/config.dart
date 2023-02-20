abstract class Config {
  static const String supabaseUrl = String.fromEnvironment(
    'API_BASES_URL',
    defaultValue: '',
  );

  static const String supabaseAnnonKey = String.fromEnvironment(
    'SUPABASE_ANNON_KEY',
    defaultValue: '',
  );
}
