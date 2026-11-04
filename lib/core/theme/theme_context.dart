import 'package:flutter/material.dart';

import 'mi_brand_colors.dart';

extension MiThemeContext on BuildContext {
  MiBrandColors get brandColors =>
      Theme.of(this).extension<MiBrandColors>()!;
}
