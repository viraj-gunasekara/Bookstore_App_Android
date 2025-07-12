import 'package:flutter/material.dart';

class HomeButton extends StatelessWidget {
  final String name;
  final VoidCallback onTap;
  final IconData? icon;
  final Color? backgroundColor;

  const HomeButton({super.key, required this.name, required this.onTap, this.icon, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final Color bgColor = backgroundColor ?? Theme.of(context).primaryColor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      splashColor: Colors.white.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: bgColor.withOpacity(0.25), blurRadius: 6, offset: const Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // 🔵 Icon inside a circle
            if (icon != null)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white.withOpacity(0.15)),
                child: Icon(icon, color: Colors.white, size: 22),
              ),

            const SizedBox(width: 12),

            // 📄 Button Text
            Expanded(
              child: Text(
                name,
                // textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600, height: 1.09, letterSpacing: 0.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}