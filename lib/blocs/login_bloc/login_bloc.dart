import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invi/api/invoice_api.dart';
import 'package:invi/blocs/login_bloc/login_event.dart';
import 'package:invi/blocs/login_bloc/login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());
      try {
        String token = await InvoiceApi.login(event.email, event.password);
        emit(LoginSuccess(token));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
