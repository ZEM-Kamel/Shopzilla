// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/modules/cart/cart_screen.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit = ShopCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title:  Text(
                cubit.titles[cubit.currentIndex]
            ),
            actions: [
              IconButton(
                  onPressed: (){
                    navigateTo(context, const SearchScreen());
                  },
                  icon: const Icon(Icons.search_outlined)),
              IconButton(
                  onPressed: (){
                    navigateTo(context, const CartScreen());
                  },
                  icon: const Icon(
                    Icons.shopping_cart_outlined
                  )
              ),
            ],
          ),
          body:PageView(
            controller: cubit.pageController,
            onPageChanged: (index){
              cubit.changeBottom(index);
            },
            scrollDirection: Axis.horizontal,
            children: [
              ProductsScreen(),
              CategoriesScreen(),
              FavoritesScreen(),
              SettingsScreen(),
            ],
          ),
          bottomNavigationBar:CurvedNavigationBar(
            items: const <Widget>[
              Icon(Icons.home_outlined,color: Colors.white,),
              Icon(Icons.category_outlined,color: Colors.white,),
              Icon(Icons.favorite_outline_outlined,color: Colors.white,),
              Icon(Icons.settings_outlined,color: Colors.white,),
            ],
            index: cubit.currentIndex,
            height: 60.0,
            color: defaultColor,
            buttonBackgroundColor: defaultColor,
            backgroundColor: Colors.white,
            animationCurve: Curves.easeInOut,
            animationDuration: const Duration(milliseconds: 600),
            onTap: (index) {
              cubit.pageController.animateToPage(index, duration: const Duration(milliseconds: 600), curve: Curves.easeInOut,);
              cubit.changeBottom(index);
            },
            letIndexChange: (index) => true,
          ),
        );
      },
    );
  }
}
