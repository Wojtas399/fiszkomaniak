import 'package:flutter_bloc/flutter_bloc.dart';

class SingleInputDialogCubit extends Cubit<String> {
  bool Function(String? value)? _validator;

  SingleInputDialogCubit() : super('');

  bool get isButtonDisabled {
    final validator = _validator;
    if (validator != null) {
      return state.isEmpty && validator(state);
    }
    return state.isEmpty;
  }

  void setValidator(bool Function(String? value)? validator) {
    _validator = validator;
  }

  void onValueChanged(String value) {
    emit(value);
  }
}
