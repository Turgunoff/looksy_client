import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class SocialLoginButtons extends StatelessWidget {
  final Function()? onGooglePressed;
  final Function()? onApplePressed;
  final Function()? onFacebookPressed;
  final Function()? onTelegramPressed;

  const SocialLoginButtons({
    super.key,
    this.onGooglePressed,
    this.onApplePressed,
    this.onFacebookPressed,
    this.onTelegramPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text('yoki', style: TextStyle(color: Colors.grey)),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 16,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSocialButton(
              onPressed: onGooglePressed,
              icon: BoxIcons.bxl_google,
              color: Colors.red,
            ),
            _buildSocialButton(
              onPressed: onApplePressed,
              icon: BoxIcons.bxl_apple,
              color: Colors.black,
            ),
            _buildSocialButton(
              onPressed: onFacebookPressed,
              icon: BoxIcons.bxl_facebook,
              color: Colors.blue,
            ),
            _buildSocialButton(
              onPressed: onTelegramPressed,
              icon: BoxIcons.bxl_telegram,
              color: Colors.lightBlue,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Function()? onPressed,
    required IconData icon,
    required Color color,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon, color: color, size: 30),
      ),
    );
  }
}
