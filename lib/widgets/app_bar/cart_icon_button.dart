import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import '../../data/repositories/shop_repository.dart';

/// Widget del ícono del carrito con badge de cantidad
class CartIconButton extends ConsumerWidget {
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;

  const CartIconButton({
    super.key,
    this.height,
    this.width,
    this.margin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemCount = ref.watch(cartItemCountProvider);

    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: InkWell(
        onTap: onTap ??
            () {
              Navigator.of(context).pushNamed(AppRoutes.cartScreen);
            },
        borderRadius: BorderRadius.circular(20),
        child: SizedBox(
          height: height ?? 30.h,
          width: width ?? 30.h,
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: (height ?? 30.h) * 0.8,
                  color: appTheme.blueGray80001,
                ),
              ),
              if (itemCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.h),
                    decoration: BoxDecoration(
                      color: appTheme.deepOrange400,
                      shape: BoxShape.circle,
                    ),
                    constraints: BoxConstraints(
                      minWidth: 16.h,
                      minHeight: 16.h,
                    ),
                    child: Text(
                      itemCount > 9 ? '9+' : itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.fSize,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
