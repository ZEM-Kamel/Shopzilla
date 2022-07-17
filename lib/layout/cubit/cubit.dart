// ignore_for_file: avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorite_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favorites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  PageController pageController=PageController(initialPage: 0);

  List<Widget> bottomScreens = [
     ProductsScreen(),
     CategoriesScreen(),
     FavoritesScreen(),
     SettingsScreen(),
  ];

  List<String> titles = [
    'Home',
    'Categories',
    'Favorites',
    'Settings',
  ];

  void changeBottom(int index)
  {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }

  HomeModel? homeModel;
  Map<int, bool> favorites = {};

  void getHomeData()
  {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: CacheHelper.getData(key: 'token'),
    ).then((value)
    {
      homeModel = HomeModel.fromJson(value.data);

      //printFullText(homeModel.toString());
      //print(homeModel?.status);

      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id!: element.inFavorites!,
        });
      });

      //print(favorites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories()
  {
    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value)
    {
      categoriesModel = CategoriesModel.fromJson(value.data);

     // printFullText(categoriesModel.toString());
     // print(categoriesModel?.status);

      emit(ShopSuccessCategoriesState());
    }).catchError((error){
      print(error.toString());
      emit(ShopErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId)
  {
    favorites[productId] = !favorites[productId]!;
    emit(ShopChangeFavoritesState());

    DioHelper.postData(
        url: FAVORITES,
        data: {
          'product_id': productId,
        },
      token: CacheHelper.getData(key: 'token'),
    ).then((value)
    {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      //print(value.data);

      if(!changeFavoritesModel!.status!)
        {
          favorites[productId] = !favorites[productId]!;
        }
      else
        {
          getFavorites();
        }

      emit(ShopSuccessChangeFavoritesState(changeFavoritesModel!));
    }).catchError((error)
    {
      favorites[productId] = !favorites[productId]!;

      emit(ShopErrorChangeFavoritesState());
    });
  }

  FavoritesModel? favoritesModel;

  void getFavorites()
  {
    emit(ShopLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
     // printFullText(value.data.toString());

      emit(ShopSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorGetFavoritesState());
    });
  }

  ShopLoginModel? userModel;

  void getUserData() {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: CacheHelper.getData(key: 'token'),
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);

      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = ShopLoginModel.fromJson(value.data);
      printFullText(userModel!.data!.name!);

      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });
  }

  List<ProductModel>? cartItems=[];
  void addToCart(ProductModel model)
  {
    cartItems!.add(model);
    emit(ShopSuccessAddItemToCartState());
  }

  void removeFromCart(int index){
    cartItems!.removeAt(index);
    emit(ShopSuccessRemoveItemFromCartState());
    calcTotal();
  }

  num price=0;
  void calcTotal(){
    price=0;
    cartItems?.forEach((element) {
      price=price+element.price;
    });
    emit(ShopSuccessCalcTotalState());
  }
}