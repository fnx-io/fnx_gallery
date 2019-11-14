import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:fnx_gallery/src/image.dart';
import 'package:pedantic/pedantic.dart';

const EMPTY = <Image>[];

@Component(
    selector: 'fnx-gallery',
    templateUrl: 'fnx_gallery.html',
    directives: [coreDirectives],
    styleUrls: <String>['fnx_gallery.css'])
class FnxGallery implements OnInit, OnDestroy {
  Iterable<Image> _images;

  StreamSubscription<KeyboardEvent> keySubscription;

  List<Image> get images => _images ?? EMPTY;

  @Input()
  set images(Iterable<Image> value) => _images = value;

  Image _selectedImage;

  Image get selectedImage => _selectedImage;

  @Input()
  set selectedImage(Image i) {
    _selectedImage = i;
    selectImage(i, false);
  }

  Image selectingImage;

  @Input()
  bool withCaptions = false;

  @Input()
  bool withThumbnails = true;

  StreamController<bool> closeController = StreamController.broadcast();
  @Output()
  Stream<bool> get close => closeController.stream;

  StreamController<bool> selectController = StreamController.broadcast();
  @Output()
  Stream<bool> get select => selectController.stream;

  @ViewChild("content")
  Element content;

  @ViewChild("thumbs")
  Element thumbs;

  @ViewChild("caption")
  Element caption;

  bool get moreImages => images != null && images.length > 1;

  String _selectedImageCaption;

  String get selectedImageCaption => _selectedImageCaption;

  set selectedImageCaption(String value) {
    if (withCaptions) {
      _selectedImageCaption = value;
      if (caption != null) {
        if (value != null) {
          caption.setInnerHtml(value, treeSanitizer: NodeTreeSanitizer.trusted);
        } else {
          caption.setInnerHtml("");
        }
      }
    }
  }

  String get selectedImageSrcCss =>
      selectedImage == null ? "" : "url(${selectedImage.imgSrc})";

  Map<Image, String> _captionCache = {};

  int thumbsMargin = 0;

  int startingTouchX;

  int lastTouchX;

  final int touchMargin = 80;

  FnxGallery();

  Future<Null> selectImage(Image i, [bool selectImage = true]) async {
    selectingImage = i;

    if (withThumbnails == true) {
      unawaited(scrollToThumbnail(i));
    }

    content.style.opacity = "0";
    selectedImageCaption = null;

    if (withCaptions && selectingImage.htmlCaptionProvider != null) {
      selectedImageCaption = _captionCache[selectingImage];
      // if not cached
      if (selectedImageCaption == null) {
        FutureOr<String> caption = selectingImage.htmlCaptionProvider();

        if (caption is String) {
          selectedImageCaption = caption;
        } else {
          unawaited((caption as Future<String>).then((String htmlCaption) {
            // are we still on the same image?
            _captionCache[i] = htmlCaption;
            selectedImageCaption = htmlCaption;
          }));
        }
      }
    }

    await Future.delayed(Duration(milliseconds: 200));

    if (selectImage) {
      selectedImage = i;
    }

    content.style.opacity = "1";
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
        closeController.add(true);
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
    closeController.add(true);
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
    await Future.delayed(Duration(milliseconds: 100));
    num thumbsWidth = 0;
    num selectedPosition = 0;
    Element container = (thumbs.nativeElement as Element);

    container.children.forEach((Element e) {
      thumbsWidth += e.getBoundingClientRect().width;
    });
    print(thumbsWidth);

    thumbsMargin = (Random().nextInt(400)-200);
    */
  }
}
