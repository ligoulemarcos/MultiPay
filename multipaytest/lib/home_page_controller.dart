import 'package:multipay/multipay.dart';
import 'package:multipaytest/i_view_controller.dart';
import 'package:multipaytest/page_args.dart';
import 'package:mvc_pattern/mvc_pattern.dart';

class HomePageController extends ControllerMVC implements IViewController {
  static late HomePageController _this;
  MultiPayClientModel client = MultiPayClientModel();

  factory HomePageController(PageArgs? args) {
    _this = HomePageController._(args);
    return _this;
  }

  static HomePageController get con => _this;
  PageArgs? args;
  HomePageController._(this.args);

  @override
  void initPage({PageArgs? arguments}) {
    args = arguments;
    client = args!.client ?? MultiPayClientModel();
  }

  @override
  disposePage() {}
}
