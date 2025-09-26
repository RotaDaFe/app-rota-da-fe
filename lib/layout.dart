import 'package:flutter/material.dart';
import 'package:rota_da_fe/components/navbar.dart';
import 'package:rota_da_fe/pages/inicio.page.dart';
import 'package:rota_da_fe/style/colors.dart';
import 'package:rota_da_fe/style/animations.dart';

class LayoutBase extends StatelessWidget {
  final Widget child;
  final bool disableMargem;
  final bool disableHomeNav;
  final bool disableIcon;
  const LayoutBase(
      {Key? key,
      required this.child,
      this.disableMargem = false,
      this.disableHomeNav = false,
      this.disableIcon = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double margem = 50.0;

    return Container(
      color: AppColors.primary.withOpacity(.58),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Navbar(
                disable_icon: disableIcon,
                onTap: disableHomeNav
                    ? () {}
                    : () {
                        navigateAndRemoveUntil(context, const PageInicio());
                      },
                height: 80.0,
              ),
              Expanded(
                child: SizedBox(
                  width: disableMargem
                      ? null
                      : (largura > 400 ? 400 - 50 : (largura - margem)),
                  child: child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
