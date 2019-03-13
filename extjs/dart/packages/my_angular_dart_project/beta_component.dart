import 'package:angular/angular.dart';
import 'package:my_angular_dart_project/outside_provider.dart';


@Component(
  selector: 'beta-component',
  templateUrl: 'beta_component.html',
  providers: [OutsideService],
)
class BetaComponent implements OnInit {
  @Input()
  var name = 'Angular 2';

  void ngOnInit() {
    print('OutsideService.getData() - Inside Angular Flow');
    print(OutsideService.getData());
  }
}