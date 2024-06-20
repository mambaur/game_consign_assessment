import 'package:flutter_bloc/flutter_bloc.dart';

class BlocSetting {
  static List<BlocProvider> providers() {
    return [
      // BlocProvider<AuthCubit>(
      //     create: (BuildContext context) => AuthCubit()..authCheck()),
    ];
  }
}
