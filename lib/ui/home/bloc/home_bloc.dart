import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kpn_pos_application/data_store/shared_preference_helper.dart';
import 'package:kpn_pos_application/ui/home/bloc/home_event.dart';
import 'package:kpn_pos_application/ui/home/bloc/home_state.dart';
import 'package:kpn_pos_application/ui/home/repository/home_repository.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {

  final HomeRepository _homeRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  HomeBloc(this._homeRepository, this._sharedPreferenceHelper)
      : super(HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitial);

  }

  Future<void> _onHomeInitial(
      HomeInitialEvent event, Emitter<HomeState> emit) async {

  }
}