import 'dart:async';
import 'dart:html';
import 'dart:js';
import 'package:angular2/core.dart';
import 'package:fnx_gallery/src/image.dart';

const EMPTY = const <Image>[];

@Component(
    selector: 'fnx-gallery',
    templateUrl: 'fnx_gallery.html',
    styleUrls: const <String>['fnx_gallery.css'])
class FnxGallery implements OnInit, OnDestroy {

  Iterable<Image> _images;

  StreamSubscription<KeyboardEvent> keySubscription;

  List<Image> get images => _images??EMPTY;

  @Input()
  set images(Iterable<Image> value) => _images = value;

  Image _selectedImage = null;

  Image get selectedImage => _selectedImage;

  @Input()
  set selectedImage (Image i) {
    _selectedImage = i;
    selectImage(i, false);
  }

  Image selectingImage = null;

  @Input()
  bool withCaptions = false;

  @Input()
  bool withThumbnails = true;

  @Input()
  bool withFullscreen = false;

  @Output()
  EventEmitter<bool> close = new EventEmitter<bool>();

  @Output()
  EventEmitter<Image> select = new EventEmitter<Image>();

  @ViewChild("content")
  ElementRef content;

  @ViewChild("thumbs")
  ElementRef thumbs;

  @ViewChild("caption")
  ElementRef caption;

  bool get moreImages => images != null && images.length > 1;

  String _selectedImageCaption = null;

  String get selectedImageCaption => _selectedImageCaption;

  set selectedImageCaption(String value) {
    if (withCaptions) {
      _selectedImageCaption = value;

      if (value != null) {
       (caption.nativeElement as Element).setInnerHtml(value, treeSanitizer: NodeTreeSanitizer.trusted);
      } else {
       (caption.nativeElement as Element).setInnerHtml("");
      }
    }
  }

  String get selectedImageSrcCss => selectedImage == null ? "" : "url(${selectedImage.imgSrc})";

  Map<Image, String> _captionCache = {};

  int thumbsMargin = 0;

  int startingTouchX = null;

  int lastTouchX = null;

  final int touchMargin = 80;

  FnxGallery();

  /// Opens the full screen on [element].
  void _openFullscreen(Node element) {
    var elem = new JsObject.fromBrowserObject(element);

    if (elem.hasProperty("requestFullscreen")) {
      elem.callMethod("requestFullscreen");
    } else {
      List<String> vendors = ['moz', 'webkit', 'ms', 'o'];

      for (String vendor in vendors) {
        String vendorFullscreen = "${vendor}RequestFullscreen";

        if (vendor == 'moz') {
          vendorFullscreen = "${vendor}RequestFullScreen";
        }

        if (elem.hasProperty(vendorFullscreen)) {
          elem.callMethod(vendorFullscreen);
          return;
        }
      }
    }
  }

  /// Exits the full screen on [element].
  void _exitFullscreen(Node element) {
    var elem = new JsObject.fromBrowserObject(element);

    if (elem.hasProperty("exitFullscreen")) {
      elem.callMethod("exitFullscreen");
    } else if (elem.hasProperty("mozCancelFullScreen")) {
      elem.callMethod("mozCancelFullScreen");
    } else if (elem.hasProperty("webkitExitFullscreen")) {
      elem.callMethod("webkitExitFullscreen");
    }
  }

  Future<Null> selectImage(Image i, [bool selectImage = true]) async {
    if (selectImage && withFullscreen) {
      _openFullscreen(document.body);
    }

    selectingImage = i;

    if (withThumbnails == true) {
      scrollToThumbnail(i);
    }

    (content.nativeElement as Element).style.opacity = "0";
    selectedImageCaption = null;

    if (withCaptions && selectingImage.htmlCaptionProvider != null) {
      selectedImageCaption = _captionCache[selectingImage];
      // if not cached
      if (selectedImageCaption == null) {
        FutureOr<String> caption = selectingImage.htmlCaptionProvider();

        if (caption is String) {
          selectedImageCaption = caption;
        } else {
          (caption as Future).then((String htmlCaption) {
            // are we still on the same image?
            _captionCache[i] = htmlCaption;

            selectedImageCaption = htmlCaption;
          });
        }
      }
    }

    await new Future.delayed(new Duration(milliseconds: 200));

    if (selectImage) {
      selectedImage = i;
    }

    (content.nativeElement as Element).style.opacity = "1";
  }

  void goLeft() {
    if (images.isEmpty || images.length == 1) return;

    int ind = images.indexOf(selectedImage);

    if (ind == 0) {
      selectImage(images.last);
    } else {
      selectImage(images[ind - 1]);
    }
  }

  void goRight() {
    if (images.isEmpty || images.length == 1) return;

    int ind = images.indexOf(selectedImage);

    if (ind == images.length - 1) {
      selectImage(images.first);
    } else {
      selectImage(images[ind + 1]);
    }
  }

  @override
  void ngOnInit() {
    if (selectedImage == null) {
      selectImage(images.first);
    }

    keySubscription = document.onKeyDown.listen((KeyboardEvent e) {
      if (e.keyCode == KeyCode.ESC) {
        e.stopPropagation();
        e.preventDefault();
        close.emit(true);

      } else if (e.keyCode == KeyCode.LEFT) {
        goLeft();

      } else if (e.keyCode == KeyCode.SPACE) {
        goRight();

      } else if (e.keyCode == KeyCode.RIGHT) {
        goRight();
      }
    });
  }

  @override
  ngOnDestroy() {
    if (keySubscription != null) {
      keySubscription.cancel();
      keySubscription = null;
    }
  }

  void goAway() {
    if (withFullscreen) {
      _exitFullscreen(document);
    }

    close.emit(true);
  }

  /// Starts the touch event with setting the starting x position.
  void touchStart(TouchEvent e) {
    lastTouchX = startingTouchX = e.touches[0].page.x.toInt();
  }

  /// Updates the last touch x position.
  void touchMove(TouchEvent e) {
    lastTouchX = e.touches[0].page.x.toInt();
  }

  /// Decides if the touch event was a swipe and to which side.
  void touchEnd(TouchEvent e) {
    if (startingTouchX != null && startingTouchX > lastTouchX + touchMargin) {
      goRight();
    } else if (startingTouchX < lastTouchX - touchMargin) {
      goLeft();
    }

    startingTouchX = null;
    lastTouchX = null;
  }

  Future<Null> scrollToThumbnail(Image i) async {
    /*
    await new Future.delayed(new Duration(milliseconds: 100));
    num thumbsWidth = 0;
    num selectedPosition = 0;
    Element container = (thumbs.nativeElement as Element);

    container.children.forEach((Element e) {
      thumbsWidth += e.getBoundingClientRect().width;
    });
    print(thumbsWidth);

    thumbsMargin = (new Random().nextInt(400)-200);
    */
  }
}