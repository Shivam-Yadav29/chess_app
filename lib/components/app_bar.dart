import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLeadingPressed;
  final VoidCallback? onSettingsPressed;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    this.onLeadingPressed,
    this.onSettingsPressed,
    this.showBackButton = false,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color.fromARGB(255, 87, 16, 16),
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: Icon(
          showBackButton ? Icons.arrow_back : Icons.account_circle_sharp,
          color: const Color.fromARGB(255, 255, 255, 255),
          size: 30,
        ),
        onPressed: onLeadingPressed ?? () => Navigator.pop(context),
      ),
      title: Text(
        'Chess',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontFamily: 'Raleway',
              color: Colors.white,
              fontSize: 30,
              letterSpacing: 0.0,
              fontWeight: FontWeight.w800,
            ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
          child: IconButton(
            icon: const Icon(
              Icons.settings,
              color: Color.fromARGB(255, 253, 253, 253),
              size: 28,
            ),
            onPressed: onSettingsPressed ?? () {},
          ),
        ),
      ],
      centerTitle: true,
      elevation: 2,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
