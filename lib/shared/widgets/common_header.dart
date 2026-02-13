import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget implements PreferredSizeWidget {
  const CommonHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            // Logo
            Image.asset('assets/image/logo.png', height: 20),
            const Spacer(),
            // Wallet Chip
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF226AD1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 8,
                      backgroundImage: NetworkImage(
                        'http://localhost:3845/assets/7295164430571b46b9fbb1781cd8a3e8631971eb.png',
                      ),
                    ),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '0x9b...E652',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            // Language Switcher
            const Icon(Icons.language, size: 20, color: Color(0xFF969696)),
            const SizedBox(width: 10),
            // Theme Switcher
            const Icon(
              Icons.wb_sunny_outlined,
              size: 20,
              color: Color(0xFF969696),
            ),
          ],
        ),
      ),
    );
  }
}
