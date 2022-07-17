import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:shop_app/layout/cubit/cubit.dart';
import 'package:shop_app/layout/cubit/states.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/colors.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) => {},
      builder: (context, state) {
        ShopCubit.get(context).calcTotal();
        var cubit = ShopCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: Column(
            children: [
              Expanded(
                child: Conditional.single(
                  context: context,
                  conditionBuilder: (BuildContext context) =>
                  ShopCubit.get(context).cartItems!.isNotEmpty,
                  widgetBuilder: (BuildContext context) => ListView.separated(
                    itemBuilder: (context, index) => buildCartItems(ShopCubit.get(context).cartItems![index],context,index),
                    separatorBuilder: (context, index) => myDivider(),
                    itemCount: ShopCubit.get(context).cartItems!.length,
                  ),
                  fallbackBuilder: (BuildContext context) => Center(
                    child: defaultFallback(
                        text: 'No Items In Cart Yet, Please Add Some Items.'),
                  ),
                ),
              ),
              if(ShopCubit.get(context).cartItems!.isNotEmpty)
                Padding(
                padding: const EdgeInsets.all(8.0),
                child: defaultButton(text: "CHECKOUT (EGP ${cubit.price})", function: (){},background: defaultColor),
              ),


            ],
          ),
        );
        }
    );

  }
  Widget buildCartItems(model, BuildContext context,index) => Padding(
    padding: const EdgeInsets.all(20.0),
    child: SizedBox(
      height: 115,
      child: Row(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                image: NetworkImage('${model.image}'),
                width: 115,
                height: 115,
                fit: BoxFit.cover,
              ),
              if (model.discount != 0)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  color: Colors.red,
                  child: const Text(
                    'DISCOUNT',
                    style: TextStyle(
                      fontSize: 8,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${model.name}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    height: 1.3,
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    Text(
                      '${model.price.round()}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: defaultColor,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    if (model.discount != 0)
                      Text(
                        '${model.oldPrice.round()}',
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    const Spacer(),
                    IconButton(
                      onPressed: () {
                        ShopCubit.get(context).removeFromCart(index);
                      },
                      icon: const CircleAvatar(
                        radius: 30,
                        backgroundColor:Colors.red,
                        child: Icon(
                          Icons.remove_shopping_cart_outlined,
                          size: 25,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

}

