import 'package:ebono_pos/data_store/shared_preference_helper.dart';
import 'package:ebono_pos/ui/home/bloc/home_event.dart';
import 'package:ebono_pos/ui/home/bloc/home_state.dart';
import 'package:ebono_pos/ui/home/repository/home_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository;
  final SharedPreferenceHelper _sharedPreferenceHelper;

  int selectedTabButton = 2;

  HomeBloc(this._homeRepository, this._sharedPreferenceHelper)
      : super(HomeInitial()) {
    on<HomeInitialEvent>(_onHomeInitial);
  }

  Future<void> _onHomeInitial(
      HomeInitialEvent event, Emitter<HomeState> emit) async {}
}
