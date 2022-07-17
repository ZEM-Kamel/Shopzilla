// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/cubit/cubit.dart';
import 'package:shop_app/shared/cubit/states.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/themes.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();
  bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  Widget? widget;
  String? token = CacheHelper.getData(key: 'token');
  print(token);

  if (onBoarding != null) {
    if (token != null) {
      widget = const ShopLayout();
    } else {
      widget = LoginScreen();
    }
  } else {
    widget = OnBoardingScreen();
  }

  BlocOverrides.runZoned(
    () {
      runApp(MyApp(
        startWidget: widget,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  final Widget? startWidget;

  MyApp({
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => ShopCubit()
                ..getHomeData()
                ..getCategories()
                ..getFavorites()
                ..getUserData(),
          ),
          BlocProvider(create: (BuildContext context) => AppCubit()
              // ..changeAppMode(
              //   fromShared: isDark,
              // ),
              ),
        ],
        child: BlocConsumer<AppCubit, AppStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
             // darkTheme: darkTheme,
              home: SplashScreenView(
                navigateRoute: startWidget,
                duration: 3000,
                imageSize: 400,
                imageSrc: "assets/images/shopzilla_splash.png",
              )
            );
          },
        ));
  }
}
