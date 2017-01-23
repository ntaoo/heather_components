import 'dart:html';
import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:angular2_components/src/utils/async/async.dart'
    show debounceStream;

@Component(
    selector: 'heather-search',
    template: '''
        <div class="input-container" #inputContainer>
          <material-input
            [label]="label"
            (inputKeyPress)="mdInputKeyPress.add(\$event)">
          </material-input>
          <div class="close-button" (click)="close()" #closeButton>
            <glyph icon="close"></glyph>
          </div>
        </div>
        <div class="open-button" (click)="open()" #openButton>
          <glyph icon="search"></glyph>
        </div>        
        ''',
    styleUrls: const ['search.css'],
    directives: const [MaterialInputComponent, GlyphComponent])
class SearchComponent {
  @Input()
  String label = 'Search';

  bool _isOpen = true;
  bool get isOpen => _isOpen;
  @Input()
  set isOpen(dynamic /*bool | String*/ value) {
    if (value is String) {
      value = value == 'true' ? true : false;
    }
    if (value) {
      open();
    } else {
      close();
    }
  }

  final EventEmitter<String> mdInputKeyPress = new EventEmitter<String>();

  /// Debounced output stream from user input.
  ///
  /// The millisecond is hardcoded to 250. I believe it's enough for search feature.
  /// TODO: Enable strongmode after type parameter can be added to [debounceStream].
  @Output()
  Stream<String> get inputKeyPress => mdInputKeyPress
      .transform(debounceStream(const Duration(milliseconds: 250)));

  @ViewChild('inputContainer')
  ElementRef inputContainerRef;
  DivElement get inputContainer => inputContainerRef.nativeElement;
  @ViewChild('openButton')
  ElementRef openButtonRef;
  DivElement get openButton => openButtonRef.nativeElement;
  @ViewChild('closeButton')
  ElementRef closeButtonRef;
  DivElement get closeButton => closeButtonRef.nativeElement;

  void open() {
    if (_isOpen) return;
    _isOpen = true;
    inputContainer.style.width = '100%';
    closeButton.style.visibility = 'visible';
    openButton.style.cursor = 'auto';
  }

  void close() {
    if (!_isOpen) return;
    _isOpen = false;
    inputContainer.style.width = '0%';
    closeButton.style.visibility = 'hidden';
    openButton.style.cursor = 'pointer';
  }
}
