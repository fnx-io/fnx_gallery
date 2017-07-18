import 'dart:async';
import 'dart:html';
import 'dart:math';
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

  @Input()
  Image selectedImage = null;

  Image selectingImage = null;

  @Input()
  bool withCaptions = false;

  @Input()
  bool withThumbnails = true;

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
    _selectedImageCaption = value;

    if (value != null) {
      (caption.nativeElement as Element).setInnerHtml(value, treeSanitizer: NodeTreeSanitizer.trusted);
    } else {
      (caption.nativeElement as Element).setInnerHtml("");
    }
  }

  String get selectedImageSrcCss => selectedImage == null ? "" : "url(${selectedImage.imgSrc})";

  Map<Image, String> _captionCache = {};

  int thumbsMargin = 0;

  int startingTouchX = null;

  int lastTouchX = null;

  final int touchMargin = 80;

  FnxGallery();

  Future<Null> selectImage(Image i) async {
    if (selectingImage == i) return;

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

    selectedImage = i;
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
    close.emit(true);
  }

  void touchStart(TouchEvent e) {
    // Start touch.
    lastTouchX = startingTouchX = e.touches[0].page.x.toInt();
  }

  void touchMove(TouchEvent e) {
    // Update touch.
    lastTouchX = e.touches[0].page.x.toInt();
  }

  void touchEnd(TouchEvent e) {
    // End touch and decide if the swap will be done.
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