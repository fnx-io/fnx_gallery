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
    "dummy-1024x632-FrozenRaspberry.jpg",
    "dummy-240x160-Sikh.jpg",
    "dummy-454x280-Kiwi.jpg",
    "dummy-500x375-Monkey1.jpg",
    "dummy-600x450-KiwiSolo.jpg"
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

  @override
  void ngOnInit() {}

}
