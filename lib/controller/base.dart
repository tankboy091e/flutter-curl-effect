import 'package:book_sample/interfaces/view.dart';

abstract class BaseController {
  ViewState? viewState;

  void attach(ViewState viewState) {
    this.viewState = viewState;
  }

  void detach(ViewState viewState) {
    this.viewState = null;
  }

  void notify() {
    viewState?.update();
  }
}
