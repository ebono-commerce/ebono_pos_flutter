import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ebono_pos/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Import for ValueNotifier

part 'connectivity_state.dart';

class NetworkCubit extends Cubit<InternetStatus> {
  NetworkCubit() : super(const InternetStatus(ConnectivityStatus.connected)) {
    checkConnectivity();
    trackConnectivityChange(); // Ensure this is called during initialization
  }

  final ValueNotifier<InternetStatus> _connectivityStatusNotifier =
      ValueNotifier<InternetStatus>(
    const InternetStatus(ConnectivityStatus.connected),
  );

  ValueNotifier<InternetStatus> get connectivityStatusNotifier =>
      _connectivityStatusNotifier;

  // Check initial connectivity
  void checkConnectivity() async {
    ConnectivityResult connectivityResult =
        await Connectivity().checkConnectivity();
    _updatedConnectivityStatus(connectivityResult);
  }

  // Update the connectivity status based on result
  void _updatedConnectivityStatus(ConnectivityResult result) {
    InternetStatus newStatus;
    if (result == ConnectivityResult.none) {
      newStatus = const InternetStatus(ConnectivityStatus.disconnected);
    } else {
      newStatus = const InternetStatus(ConnectivityStatus.connected);
    }

    emit(newStatus); // Emit the new status
    _connectivityStatusNotifier.value = newStatus; // Update the notifier value
  }

  late StreamSubscription<ConnectivityResult?> _subscription;

  // Start listening to connectivity changes
  void trackConnectivityChange() {
    _subscription = Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        _updatedConnectivityStatus(result);
      },
    );
  }

  // Clean up resources when the cubit is disposed
  void dispose() {
    _subscription.cancel();
    _connectivityStatusNotifier.dispose();
    super.close(); // Don't forget to call super.close()
  }
}
