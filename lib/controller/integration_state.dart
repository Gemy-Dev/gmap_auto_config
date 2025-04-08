sealed class IntegrationState {
  const IntegrationState();
}
class IntegrationInitial extends IntegrationState {}

class ProjectSelected extends IntegrationState {
  final String projectPath;
  ProjectSelected(this.projectPath);
}
class PackageIntegrated extends IntegrationState {
  

}
class ApiKeySet extends IntegrationState {


  ApiKeySet( );
}
class AndriodConfigured extends IntegrationState {

}
class IosConfigured extends IntegrationState {
  

}
class Compleate extends IntegrationState {


}
class IntegrationError extends IntegrationState {
  final String message;
  IntegrationError(this.message);
}