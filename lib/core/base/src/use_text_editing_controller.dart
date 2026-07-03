part of '../base.dart';

class CustomTextEditingController extends TextEditingController {
  final String initialValue;

  CustomTextEditingController(this.initialValue) : super(text: initialValue);

  // late String _previousText = defaultValue;

  // final _textListenerMap = <VoidCallback, VoidCallback>{};

  void reset() => text = initialValue;

  // void addTextListener(void Function() listener) {
  //   void newListener() {
  //     if (_previousText == text) return;
  //     _previousText = text;
  //     listener();
  //   }

  //   _textListenerMap[listener] = newListener;
  //   addListener(newListener);
  // }

  // void removeTextListener(void Function() listener) {
  //   final wrapper = _textListenerMap[listener];
  //   if (wrapper == null) return;
  //   removeListener(wrapper);
  //   _textListenerMap.remove(listener);
  // }

  // @override
  // void dispose() {
  //   _textListenerMap.clear();
  //   super.dispose();
  // }
}

mixin TextEditingControllerFactoryMixin {
  final Map<int, CustomTextEditingController> _controllers = <int, CustomTextEditingController>{};
  int _controllerCounter = 0;
  bool _controllersDisposed = false;

  @protected
  CustomTextEditingController useTextEditingController([String initialValue = '']) {
    assert(!_controllersDisposed, 'Cannot create controller after disposal');

    final controllerKey = _controllerCounter++;
    final controller = CustomTextEditingController(initialValue);
    _controllers[controllerKey] = controller;
    return controller;
  }

  @protected
  void resetControllers() {
    for (final controller in _controllers.values) {
      controller.reset();
    }
  }

  @protected
  void disposeControllers() {
    if (_controllersDisposed) return;
    _controllersDisposed = true;

    for (final controller in _controllers.values) {
      controller.dispose();
    }
    _controllers.clear();
  }
}
