import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? backgroundColor;

  const HomeButton({
    super.key,
    required this.name,
    required this.onTap,
    this.icon,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.white24,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: bgColor.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: Colors.white, size: 20),
            if (icon != null) const SizedBox(width: 8),
            Flexible(
              child: Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
