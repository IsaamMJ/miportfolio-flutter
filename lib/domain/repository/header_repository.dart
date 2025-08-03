import '../../data/models/header_item.dart';

abstract class HeaderRepository {
  List<HeaderItem> getHeaderItems();
}