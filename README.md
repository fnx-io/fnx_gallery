# fnx_gallery

In Dart app you have to prepare images paths and optionally captions:

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

In template use it like this:

```html
<fnx-gallery
    [images]="images"
    [withCaptions]="true"
    [withThumbnails]="true"></fnx-gallery>
    ...
```

See [examples](http://demo.fnx.io/fnx_gallery-examples/).

## Navigation

Your user can navigate through your gallery by simply pressing the left/right buttons or on mobile also by swapping to left or right.

## fnx-gallery element

**fnx_gallery** package contains `<fnx-gallery>` element. It's a
simple `position: fixed;` element which you can use as gallery.

Specify dependency in pubspec.yaml:

```yaml
dependencies:
  fnx_gallery: ^0.0.6
```

Run `pub get`, import it in your html:

```html
<link rel="import" href="packages/fnx_gallery/fnx_gallery.html">
```

... and in your "index.dart" (or whatever is the name of your main script):

```dart
import 'package:fnx_gallery/fnx_gallery.dart';
```

## Contact

Feel free to contact me at `<user-element>tomucha</user-element><host-element separator="@">gmail.com</host-element>`,
or fill-in a bugreport on [Github issue tracking](https://github.com/fnx-io/fnx_gallery/issues).
