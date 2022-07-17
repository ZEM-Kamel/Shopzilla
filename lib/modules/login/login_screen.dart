// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, must_be_immutable, use_key_in_widget_constructors, avoid_print, unused_import

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layout/shop_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/colors.dart';

class LoginScreen extends StatelessWidget
{
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, states) {
          if (states is ShopLoginSuccessState) {
            if (states.loginModel.status!) {
              if (kDebugMode) {
                print(states.loginModel.message);
              }
              showToast(
                  text: states.loginModel.message.toString(),
                  state: ToastStates.SUCCESS);
              if (kDebugMode) {
                print(states.loginModel.data!.token);
              }
              CacheHelper.saveData(
                  key: 'token', value: states.loginModel.data!.token)
                  .then((value) {
                token = states.loginModel.data!.token!;
                navigateAndFinish(context, const ShopLayout());
              });
            } else {
              if (kDebugMode) {
                print(states.loginModel.message);
              }
              showToast(
                text: states.loginModel.message!,
                state: ToastStates.ERROR,
              );
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Image(
                            image: AssetImage('assets/images/login.png'),
                            height: 200,
                            width: 200,
                          ),
                        ),
                        const Center(
                          child: Text(
                            'LOGIN',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const Center(
                          child: Text(
                            'Login Now To Browse Our Hot Offers',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        defaultFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Email Address';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          onSubmit: (value) {
                            if (formKey.currentState!.validate()) {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          validate: (String? value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                          label: 'Password',
                          prefix: Icons.lock_outline,
                          suffix: ShopLoginCubit.get(context).suffix,
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: () {
                            ShopLoginCubit.get(context)
                                .changePasswordVisibility();
                          },
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        Conditional.single(
                          context: context,
                          conditionBuilder: (BuildContext context) =>
                          state is! ShopLoginLoadingState,
                          widgetBuilder: (BuildContext context) =>
                              defaultButton(
                                radius: 25,
                                text: 'Login',
                                background: defaultColor,
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopLoginCubit.get(context).userLogin(
                                        email: emailController.text,
                                        password: passwordController.text);
                                  }
                                },
                              ),
                          fallbackBuilder: (BuildContext context) =>
                          const Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('Don\'t have an account?'),
                            TextButton(onPressed: () {
                              navigateTo(
                                  context, RegisterScreen());
                            }, child: const Text('REGISTER',
                              style: TextStyle(
                                  color: defaultColor,
                              ),

                            )),

                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
/****************************************************/

//   @override
//   Widget build(BuildContext context) {
//
//     return BlocProvider(
//       create: (BuildContext context) => ShopLoginCubit(),
//       child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
//         listener: (context, state) {
//           if (state is ShopLoginSuccessState) {
//             if (state.loginModel.status!)
//             {
//               print(state.loginModel.message);
//               print(state.loginModel.data?.token);
//
//               CacheHelper.saveData(
//                 key: 'token',
//                 value: state.loginModel.data?.token,
//               ).then((value){
//                 token = state.loginModel.data!.token!;
//
//                 navigateAndFinish(
//                   context,
//                   ShopLayout(),
//                 );
//               });
//
//             } else {
//               print(state.loginModel.message);
//
//               showToast(
//                 text: state.loginModel.message!,
//                 state: ToastStates.ERROR,
//
//               );
//             }
//           }
//         },
//         builder: (context, state) {
//           return Scaffold(
//             appBar: AppBar(),
//             body: Center(
//               child: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20.0),
//                   child: Form(
//                     key: formKey,
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.,
//                       children: [
//                         Text(
//                           'LOGIN',
//                           style:
//                               Theme.of(context).textTheme.headline4!.copyWith(
//                                     color: Colors.black,
//                                   ),
//                         ),
//                         Text(
//                           'Login Now To See Our Offers',
//                           style:
//                               Theme.of(context).textTheme.bodyText1?.copyWith(
//                                     color: Colors.grey,
//                                   ),
//                         ),
//                         SizedBox(
//                           height: 30.0,
//                         ),
//                         defaultFormField(
//                           controller: emailController,
//                           keyboardType: TextInputType.emailAddress,
//                           validate: (String? value) {
//                             if (value!.isEmpty) {
//                               return 'Please Enter Your Email Address';
//                             }
//                             return null;
//                           },
//                           label: 'Email Address',
//                           prefix: Icons.email,
//                         ),
//                         SizedBox(
//                           height: 15.0,
//                         ),
//                         defaultFormField(
//                           controller: passwordController,
//                           keyboardType: TextInputType.visiblePassword,
//                           onSubmit: (value) {
//                             if (formKey.currentState!.validate()) {
//                               ShopLoginCubit.get(context).userLogin(
//                                 email: emailController.text,
//                                 password: passwordController.text,
//                               );
//                             }
//                           },
//                           validate: (String? value) {
//                             if (value!.isEmpty) {
//                               return 'Password is too short';
//                             }
//                             return null;
//                           },
//                           label: 'Password',
//                           prefix: Icons.lock,
//                           suffix: ShopLoginCubit.get(context).suffix,
//                           isPassword: ShopLoginCubit.get(context).isPassword,
//                           suffixPressed: () {
//                             ShopLoginCubit.get(context)
//                                 .changePasswordVisibility();
//                           },
//                         ),
//                         SizedBox(
//                           height: 30.0,
//                         ),
//                         ConditionalBuilder(
//                           condition: state is! ShopLoginLoadingState,
//                           builder: (context) => defaultButton(
//                             function: () {
//                               if (formKey.currentState!.validate()) {
//                                 ShopLoginCubit.get(context).userLogin(
//                                   email: emailController.text,
//                                   password: passwordController.text,
//                                 );
//                               }
//                             },
//                             text: 'Login',
//                             isUpperCase: true,
//                           ),
//                           fallback: (context) =>
//                               Center(child: CircularProgressIndicator()),
//                         ),
//                         SizedBox(
//                           height: 15.0,
//                         ),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             Text(
//                               'Don\'t Have An Account?',
//                             ),
//                             defaultTextButton(
//                               function: () {
//                                 navigateTo(
//                                   context,
//                                   RegisterScreen(),
//                                 );
//                               },
//                               text: 'register',
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
