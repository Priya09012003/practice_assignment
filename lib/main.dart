import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/routes.dart';
import 'config/routes/routes_name.dart';
import 'presentation/bloc/service_bloc/service_bloc.dart';
import 'presentation/bloc/category_bloc/category_bloc.dart';

void main() {
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<ServiceBloc>(create: (_) => ServiceBloc(category: null)),
        BlocProvider<CategoryBloc>(create: (_) => CategoryBloc()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Services App',
      theme: ThemeData(fontFamily: 'Poppins', primarySwatch: Colors.brown),
      onGenerateRoute: Routes.generateRoute,
      initialRoute: RoutesName.splashScreen,
      debugShowCheckedModeBanner: false,
    );
  }
}
