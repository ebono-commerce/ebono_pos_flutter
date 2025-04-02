part of 'connectivity_cubit.dart';

class InternetStatus extends Equatable {
  final ConnectivityStatus status;

  const InternetStatus(this.status);

  @override
  List<Object?> get props => <Object?>[status];
}
