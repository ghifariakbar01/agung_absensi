import '../application/network_response.dart';
import 'network_state_remote_service.dart';

class NetworkStateRepository {
  final NetworkStateRemoteService _remoteService;

  NetworkStateRepository(this._remoteService);

  Future<NetworkResponse> fetchCurrentUrl() async {
    return _remoteService.ping();
  }
}
