sealed class IntegrationEvent{}

class SelectProjectEvent extends IntegrationEvent {
  final String projectPath;
  SelectProjectEvent(this.projectPath);
}
class IntegratePackageEvent extends IntegrationEvent {}
class SetApiKeyEvent extends IntegrationEvent {
  final String? apiKey;
  SetApiKeyEvent(this.apiKey);
}
class ConfigureAndriodEvent extends IntegrationEvent {}
class ConfigureIosEvent extends IntegrationEvent {}
class AddDemoMapEvent extends IntegrationEvent {}
