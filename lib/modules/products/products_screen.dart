// ignore_for_file: avoid_types_as_parameter_names, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/product_details/product_details_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeFavoritesState) {
          if (!state.model.status!) {
            showToast(text: state.model.message!, state: ToastStates.ERROR);
          }
        }
      },
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ShopCubit.get(context).homeModel != null && ShopCubit.get(context).categoriesModel != null,
          builder: (context) =>
              builderWidget(ShopCubit.get(context).homeModel!, ShopCubit.get(context).categoriesModel!, context),
          fallback: (context) =>
              const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget builderWidget(HomeModel model, CategoriesModel categoriesModel, context) => SingleChildScrollView(
    physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: model.data?.banners
                  .map(
                    (e) => Image(
                      image: NetworkImage(e.image!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 250.0,
                initialPage: 0,
                viewportFraction: 1.0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    height: 100.0,
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoryItem(categoriesModel.data!.data![index]),
                      separatorBuilder: (context, index) => SizedBox(
                        width: 10.0,
                      ),
                      itemCount: categoriesModel.data!.data!.length,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey[300],
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
                childAspectRatio: 1 / 1.74,
                children: List.generate(
                    model.data!.products.length,
                        (index) => buildGridProduct(model.data!.products[index], context,index),),
              ),
            ),
          ],
        ),
      );

  Widget buildGridProduct(ProductModel model,BuildContext context, int? index,) => Container(
    color: Colors.white,
    child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: ()
              {
                navigateTo(context, ProductDetailsScreen(index: index!, model: model));
              },
              child: Stack(
                alignment: AlignmentDirectional.bottomStart,
                children: [
                  Image(
                    image: NetworkImage(model.image!),
                    width: 200.0,
                    height: 200.0,
                  ),
                  if
                  (model.discount! !=0)
                  Container(
                    color: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                    child: const Text(
                      'Discount',
                      style: TextStyle(
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      height: 1.4,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${model.price.round()}',
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: defaultColor,
                        ),
                      ),
                      const SizedBox(
                        width: 5.0,
                      ),
                      if
                      (model.discount! !=0)
                      Text(
                        '${model.oldPrice.round()}',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.grey,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const Spacer(),
                      Expanded(
                        child: IconButton(
                            icon: ShopCubit.get(context).favorites[model.id]!
                                ? Icon(
                              Icons.favorite,
                              size: 17.0,
                              color: Colors.red,
                            )
                                : Icon(
                              Icons.favorite_border,
                              size: 17.0,
                              // color: Colors.white,
                            ),
                            onPressed: () {
                              ShopCubit.get(context).changeFavorites(model.id!);
                              print(model.id);
                            }),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
  );

  Widget buildCategoryItem(DataModel model) => Stack(
    alignment: AlignmentDirectional.bottomCenter,
    children: [
      Image(
        image: NetworkImage(model.image!),
        height: 100,
        width: 100,
        fit: BoxFit.cover,
      ),
      Container(
        color: Colors.black.withOpacity(0.8),
        width: 100.0,
        child: Text(
          model.name!,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ],
  );
}
