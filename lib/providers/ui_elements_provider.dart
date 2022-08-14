import 'dart:io';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class UIElementsProvider {
  IconData getAppBarBackIcon() {
    if (Platform.isAndroid) {
      return MdiIcons.close;
    }
    return MdiIcons.arrowLeft;
  }
}