class ApiConfig {
  ApiConfig._();

  static const String productionBaseUrl =
      'https://api-production-ddf5.up.railway.app/';

  static const String _legacyHost = 'api-rtf.nextlab.cloud';

  static String normalizeBaseUrl(String? value) {
    final rawValue = value?.trim() ?? '';
    if (rawValue.isEmpty) return productionBaseUrl;

    final uri = Uri.tryParse(rawValue);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return productionBaseUrl;
    }

    // Migra automaticamente instalações que ainda tenham o servidor antigo salvo.
    if (uri.host == _legacyHost) return productionBaseUrl;

    return rawValue.endsWith('/') ? rawValue : '$rawValue/';
  }

  static String endpoint(String path, {String? baseUrl}) {
    final normalizedBaseUrl = normalizeBaseUrl(baseUrl);
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return '$normalizedBaseUrl$normalizedPath';
  }
}
