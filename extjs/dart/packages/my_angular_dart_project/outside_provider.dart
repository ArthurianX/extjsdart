import 'package:angular/angular.dart';

@Injectable()
class OutsideService {
  static var outsideData = {};
  static getData() {
    return outsideData;
  }
  static setData(data) {
    outsideData = data;
  }
}