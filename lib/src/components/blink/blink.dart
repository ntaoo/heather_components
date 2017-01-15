import 'dart:html';
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:async/async.dart';

/// Blink element.
///
/// Being ported from TypeScript and RxJS version explained in below url.
/// https://medium.com/@jsayol/using-the-power-of-rxjs-and-angular-components-to-blink-a78b1ab0cf5e#.pmzpb9t0g
/// TODO: Not practical. Just css and directive solution is better.
@Component(selector: 'blink', template: '<ng-content></ng-content>')
class BlinkComponent implements OnInit, OnDestroy {
  final Element _element;
  final StreamGroup<String> _blinkersGroup;
  bool _isActive = true;

  BlinkComponent(ElementRef elementRef)
      : _element = elementRef.nativeElement,
        _blinkersGroup = new StreamGroup<String>() {
    final d = const Duration(seconds: 1); // blink duration.
    _blinkersGroup.add(new Stream<String>.periodic(d, (_) => 'visible'));
    new Future.delayed(const Duration(milliseconds: 750), () {
      _blinkersGroup.add(new Stream<String>.periodic(d, (_) => 'hidden'));
    });
  }

  void ngOnInit() {
    _blinkersGroup.stream.takeWhile((_) => _isActive).listen(
        (String newVisibility) => _element.style.visibility = newVisibility);
  }

  void ngOnDestroy() {
    _isActive = false;
    _blinkersGroup.close();
  }
}