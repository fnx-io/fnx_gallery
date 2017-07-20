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
    Image i = new Image(name, thumbSrc: name+"?thumg=1", htmlCaptionProvider: () {
      return new Future.delayed(new Duration(milliseconds: 600)).then((_)=>"$name");
    });
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

The gallery can be closed using `goAway()` method which emites `close` output of type `EventEmitter<bool>`.

It is recommended to use `*ngIf` to show and hide the gallery.

### Element inputs

You use some of these AngularDart inputs to modify the element: 

| input name     | data type       | purpose                                       |
|:---------------|:----------------|:----------------------------------------------|
| images         | List\<Image\>   | List of images of the gallery.                |
| selectedImage  | Image           | Selected image object, default 0th.           |
| withCaptions   | boolean         | Show captions below the images.               |
| withThumbnails | boolean         | Show thumbnails at the bottom of the gallery. |
| withFullscreen | boolean         | Open fullscreen while viewing the gallery.    |

## Contact

Feel free to contact me at `<user-element>tomucha</user-element><host-element separator="@">gmail.com</host-element>`,
or fill-in a bugreport on [Github issue tracking](https://github.com/fnx-io/fnx_gallery/issues).
