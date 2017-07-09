import 'dart:async';

typedef FutureOr<String> HtmlCaptionProvider();

class Image {

  String imgSrc;
  String thumbSrc;
  HtmlCaptionProvider htmlCaptionProvider;

  Image(this.imgSrc, {this.thumbSrc, this.htmlCaptionProvider});

}