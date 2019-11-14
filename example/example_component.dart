import 'package:angular/angular.dart';
import 'package:angular/core.dart';
import 'package:fnx_gallery/fnx_gallery.dart';

@Component(
    selector: 'example-component',
    templateUrl: 'example_component.html',
    directives: [FnxGallery, coreDirectives])
class ExampleComponent implements OnInit {
  bool visibleGallery = true;

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

      Image i = Image(name,
          thumbSrc: name + "?thumg=1", htmlCaptionProvider: () => name);
      images.add(i);
    }
  }

  @override
  void ngOnInit() {}
}
