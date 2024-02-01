import 'package:bloc/bloc.dart';
import 'package:usefulmoney/domain/services/counting/bloc/couter_state.dart';

class CounterCubit extends Cubit<CounterState> {
  CounterCubit(String value) : super(CounterState(value: value));

  void add(String value) {
    if ((value != '0' && value != '00') && state.value == '' ||
        state.value != '' && value != '') {
      final previousValue = state.value;
      emit(CounterState(value: previousValue + value));
    }
  }

  void deleteLast() {
    if (state.value != '') {
      final previousValue = state.value;
      final newValue = previousValue.substring(0, previousValue.length - 1);
      emit(CounterState(value: newValue));
    }
  }

  void clear() {
    emit(const CounterState(value: ''));
  }
}
