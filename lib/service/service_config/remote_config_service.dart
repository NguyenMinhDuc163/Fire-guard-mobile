part of 'firebase_service.dart';

mixin RemoteConfigService {
  final remoteConfig = FirebaseRemoteConfig.instance;

  // URL mặc định khi tren firebase null
  final String fallbackUrl = StatusApi.BASE_API_URL;

  Future<void> remoteConfigServiceInitialize() async {
    await remoteConfig.ensureInitialized();
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: Duration.zero,
      ),
    );

    bool updated = await remoteConfig.fetchAndActivate();
    print('Remote Config Updated: $updated');

    // Lấy baseUrl từ Remote Config hoặc fallback nếu không có giá trị
    String currentBaseUrl = remoteConfig.getString('baseUrlServer').isNotEmpty
        ? remoteConfig.getString('baseUrlServer')
        : fallbackUrl;

    print('Current baseUrlServer: $currentBaseUrl');
    NetworkService.instance.updateBaseUrl(currentBaseUrl); // Cập nhật URL khi khởi tạo

    // Lắng nghe các sự kiện cập nhật từ Remote Config
    remoteConfig.onConfigUpdated.listen((event) async {
      await remoteConfig.activate();
      final newBaseUrl = getBaseURLServer().isNotEmpty ? getBaseURLServer() : fallbackUrl;
      print('--NEW BASE URL FROM LISTENER: $newBaseUrl--');
      NetworkService.instance.updateBaseUrl(newBaseUrl);
    });
  }

  String getBaseURLServer() => remoteConfig.getString('baseUrlServer');
  String getBaseURLWeb() => remoteConfig.getString('base_url_web');
  String getOpenAISecretKey() => remoteConfig.getString('OpenAI_Secret_Key');
}
