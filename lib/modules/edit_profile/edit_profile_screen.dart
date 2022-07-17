// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/flutter_conditional_rendering.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/colors.dart';

class EditScreen extends StatelessWidget {
  const EditScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var formKey = GlobalKey<FormState>();
    var emailController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    return BlocProvider(
      create: (BuildContext context) => ShopCubit()..getUserData(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = ShopCubit.get(context).userModel;
          return Conditional.single(
            context: context,
            conditionBuilder: (BuildContext context) =>
            ShopCubit.get(context).userModel != null,
            widgetBuilder: (BuildContext context) {
              emailController.text = model!.data!.email!;
              nameController.text = model.data!.name!;
              phoneController.text = model.data!.phone!;
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Edit Profile'),
                  actions: const [
                    Icon(
                      Icons.edit_outlined,
                      size: 25.0,
                    ),
                  ],
                ),
                body: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            if (state is ShopLoadingUpdateUserState)
                              const LinearProgressIndicator(),
                            const SizedBox(
                              height: 25,
                            ),
                            defaultFormField(
                              controller: nameController,
                              keyboardType: TextInputType.name,
                              label: 'Name',
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Name must not be empty';
                                }
                                return null;
                              },
                              prefix: Icons.person_outline_rounded,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            defaultFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              label: 'Email',
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Email must not be empty';
                                }
                                return null;
                              },
                              prefix: Icons.email_outlined,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            defaultFormField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              label: 'Phone',
                              validate: (value) {
                                if (value!.isEmpty) {
                                  return 'Phone must not be empty';
                                }
                                return null;
                              },
                              prefix: Icons.phone_outlined,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            defaultButton(
                                background: defaultColor,
                                radius: 25,
                                text: 'Update',
                                function: () {
                                  if (formKey.currentState!.validate()) {
                                    ShopCubit.get(context).updateUserData(
                                      name: nameController.text,
                                      email: emailController.text,
                                      phone: phoneController.text,
                                    );
                                  }
                                }),
                            const SizedBox(
                              height: 35,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            fallbackBuilder: (BuildContext context) =>
            const Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}


// class EditScreen extends StatelessWidget {
//   EditScreen({Key? key}) : super(key: key);
//
//   var formKey = GlobalKey<FormState>();
//   var nameController = TextEditingController();
//   var emailController = TextEditingController();
//   var phoneController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<ShopCubit, ShopStates>(
//       listener: (context, state)
//       {},
//       builder: (context, state) {
//         var model = ShopCubit.get(context).userModel;
//         nameController.text = model!.data!.name!;
//         emailController.text = model.data!.email!;
//         phoneController.text = model.data!.phone!;
//
//         return  ConditionalBuilder(
//           condition: ShopCubit.get(context).userModel !=null,
//           builder: (context) => Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Form(
//               key: formKey,
//               child: Center(
//                 child: Column(
//                   children: [
//                     if(state is ShopLoadingUpdateUserState)
//                       LinearProgressIndicator(),
//                     SizedBox(
//                       height: 20.0,
//                     ),
//                     defaultFormField(
//                       controller: nameController,
//                       keyboardType: TextInputType.name,
//                       validate: (String? value) {
//                         if (value!.isEmpty) {
//                           return 'Name Must\'t Be Empty';
//                         }
//                         return null;
//                       },
//                       label: 'Name',
//                       prefix: Icons.person,
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                     ),
//                     defaultFormField(
//                       controller: emailController,
//                       keyboardType: TextInputType.emailAddress,
//                       validate: (String? value) {
//                         if (value!.isEmpty) {
//                           return 'Email Must\'t Be Empty';
//                         }
//                         return null;
//                       },
//                       label: 'Email Address',
//                       prefix: Icons.email,
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                     ),
//                     defaultFormField(
//                       controller: phoneController,
//                       keyboardType: TextInputType.phone,
//                       validate: (String? value) {
//                         if (value!.isEmpty) {
//                           return 'Phone Must\'t Be Empty';
//                         }
//                         return null;
//                       },
//                       label: 'Phone Number',
//                       prefix: Icons.phone,
//                     ),
//                     const SizedBox(
//                       height: 20.0,
//                     ),
//                     defaultButton(
//                       function: () {
//                         if (formKey.currentState!.validate()) {
//                           ShopCubit.get(context).updateUserData(
//                             name: nameController.text,
//                             email: emailController.text,
//                             phone: phoneController.text,
//                           );
//                         }
//                       },
//                       text: 'Update Profile',
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           fallback: (context) => const Center(child: CircularProgressIndicator()),
//         );
//       },
//     );
//   }
// }
