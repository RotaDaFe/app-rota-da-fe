import 'package:flutter_test/flutter_test.dart';
import 'package:rota_da_fe/config/api_config.dart';

void main() {
  group('ApiConfig', () {
    test('usa a API de produção quando o servidor está vazio', () {
      expect(ApiConfig.normalizeBaseUrl(null), ApiConfig.productionBaseUrl);
      expect(ApiConfig.normalizeBaseUrl(''), ApiConfig.productionBaseUrl);
    });

    test('migra o servidor antigo para a Railway', () {
      expect(
        ApiConfig.normalizeBaseUrl('https://api-rtf.nextlab.cloud/'),
        ApiConfig.productionBaseUrl,
      );
    });

    test('normaliza a barra e monta o endpoint', () {
      expect(
        ApiConfig.endpoint(
          '/api/pessoa/sync',
          baseUrl: 'https://example.com',
        ),
        'https://example.com/api/pessoa/sync',
      );
    });
  });
}
