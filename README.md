# fnx_gallery

Easy to use AngularDart gallery component.

## [Live demo](http://demo.fnx.io/fnx_gallery/)

## Getting started

First of all, in a Dart app you have to prepare list of images and optionally some caption provider:

```dart
List<Image> images = [];

List<String> names = [
  "butterfly.jpg",
  "tunnel.jpg",
  "coast.jpg",
  "flower.jpg",
  "meadow.jpg",
];

ExampleComponent() {
  for (var name in names) {
    name = "imgs/$name";
    Image i = new Image(name, thumbSrc: name+"?thumg=1", htmlCaptionProvider: () => name);
    images.add(i);
  }
}
```

In your template, you can use the component like this:

```html
<fnx-gallery
    [images]="images"
    [withCaptions]="true"
    [withThumbnails]="true"></fnx-gallery>
    ...
```

## Caption provider

htmlCaptionProvider is a function which returns `FutureOr<String>` and you can use is to
fetch your image caption from an asynchronous source (server, etc.).

Caption is handled as HTML, and is displayed using `innerHtml` with `NodeTreeSanitizer.trusted`,
please make sure your caption can be TRUSTED! 


## Navigation

Your user can navigate through your gallery by simply pressing the left/right buttons or on mobile also by swiping to left or right.

## fnx-gallery element

**fnx_gallery** package contains `<fnx-gallery>` element. It's a simple `position: fixed;` element which you can use as a gallery.

Specify dependency in pubspec.yaml:

```yaml
dependencies:
  fnx_gallery: ^0.0.7
```

Run `pub get` and in your "index.dart" (or whatever is the name of your main script):

```dart
import 'package:fnx_gallery/fnx_gallery.dart';
```

### Closing the gallery

The gallery can be closed using `goAway()` method which emits `close` output event of type `EventEmitter<bool>`.

It is recommended to use `*ngIf` to show and hide the gallery.

### Element inputs

You use some of these AngularDart inputs to modify the element: 

| input name     | data type       | purpose                                       |
|:---------------|:----------------|:----------------------------------------------|
| `images`         | List\<Image\>   | List of images of the gallery.                |
| `selectedImage`  | Image           | Selected image object, default 0th.           |
| `withCaptions`   | bool         | Show captions below the images.               |
| `withThumbnails` | bool         | Show thumbnails at the bottom of the gallery. |

## Contact

Fill-in a bugreport or feature request on [Github issue tracking](https://github.com/fnx-io/fnx_gallery/issues).
