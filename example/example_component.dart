import 'dart:async';
import 'package:angular2/core.dart';
import 'package:fnx_gallery/fnx_gallery.dart';

@Component(
    selector: 'example-component',
    templateUrl: 'example_component.html',
    directives: const [ FnxGallery ]
)
class ExampleComponent implements OnInit {

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
        return new Future.delayed(new Duration(milliseconds: 600)).then((_) => "$name");
      });

      images.add(i);
    }
  }

  @override
  void ngOnInit() {}

}
