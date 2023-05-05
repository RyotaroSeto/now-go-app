import 'package:flutter/cupertino.dart';

class StringValue {
  static const String backButtonText = 'Back';
  static const String topButtonText = 'Top';
  static const String copyright = '©️今すぐお出かけ';
}

class Parameter {
  static const double smallFontSize = 11;
  static const double defaultFontSize = 16;
  static const double articleTitleFontSize = 40;
  static const double headerHeight = 90;
  static const double headerFontSize = 16;
  static const double headerIconSize = 40;
  static const double footerFontSize = 14;
  static const double footerHeight = 70;
  static const double footerButtonWidthPercent_18 = 0.18;
  static const double footerButtonWidthPercent_40 = 0.40;
  static const double footerButtonWidthPercent_60 = 0.60;
  static const double footerButtonHeight = 50;
  static const double footerButtonIconSize = 16;
  static const double h3FontSize = 32;
  static const double h4FontSize = 50;
  static const double boxFontSize = 21;
  static const double subtitle2FontSize = 25;
  static const double subtitle3FontSize = 18;
  static const double borderWidth_1 = 1;
  static const double borderWidth_2 = 2;
  static const double borderWidth_4 = 4;
  static const double borderWidth_5 = 5;
  static const double boxPositionLeft = 20;
  static const double boxPositionTop = 2;
  static const int intMaxValue = 13000;
  static int maxValueHalfNearestFirstIndex(int length) {
    return ((intMaxValue / 2) + (intMaxValue % length)).toInt();
  }
}

class PaddingParameter {
  static const header = EdgeInsets.fromLTRB(0, 25, 0, 0);
  static const headerUserIcon = EdgeInsets.fromLTRB(10, 0, 0, 0);
  static const headerNameText = EdgeInsets.fromLTRB(10, 0, 0, 0);
  static const headerIcon = EdgeInsets.fromLTRB(0, 0, 10, 0);
  static const articleTitle = EdgeInsets.fromLTRB(20, 20, 20, 20);
  static const mainContent = EdgeInsets.fromLTRB(0, 90, 0, 70);
  static const section0 = EdgeInsets.fromLTRB(17, 0, 0, 0);
  static const subtitle2 = EdgeInsets.fromLTRB(20, 0, 0, 0);
  static const question = EdgeInsets.symmetric(horizontal: 10);
  static const box = EdgeInsets.all(15);
  static const boxLabel = EdgeInsets.fromLTRB(10, 0, 10, 0);
  static const footerButton = EdgeInsets.fromLTRB(0, 10, 0, 10);
  static const footerBackButtonIcon = EdgeInsets.fromLTRB(0, 0, 0, 0);
  static const footerButtonIcon = EdgeInsets.fromLTRB(5, 0, 5, 0);
  static const searchTextField = EdgeInsets.all(20);
  static const searchResultItem = EdgeInsets.fromLTRB(20, 5, 20, 5);
  static const searchResultItemText = EdgeInsets.all(10);
  static const expansionHeaderMarker = EdgeInsets.fromLTRB(20, 15, 15, 15);
  static const expansionHeaderText = EdgeInsets.only(left: 20);
  static const expansionBodyListItem = EdgeInsets.fromLTRB(20, 15, 15, 15);
}

class MarginParameter {
  static const section0 = EdgeInsets.fromLTRB(0, 0, 0, 0);
  static const box = EdgeInsets.fromLTRB(0, 20, 0, 20);
  static const attentionIcon = EdgeInsets.fromLTRB(0, 0, 5, 5);
  static const checkBoxIcon = EdgeInsets.fromLTRB(3, 0, 5, 5);
}
