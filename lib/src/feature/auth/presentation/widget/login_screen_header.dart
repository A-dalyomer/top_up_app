import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:uae_top_up/src/core/constants/const_icon_assets.dart';
import 'package:uae_top_up/src/feature/localization/domain/util/app_localizations.dart';

/// Login screen header containing top screen icon and welcoming text
class LoginScreenHeader extends StatelessWidget {
  const LoginScreenHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: SvgPicture.asset(ConstIconAssets.loginPresentIcon),
        ),
        Text(
          AppLocalizations.loginScreenTitle.tr(),
          style: Theme.of(context).textTheme.displaySmall,
        ),
      ],
    );
  }
}
