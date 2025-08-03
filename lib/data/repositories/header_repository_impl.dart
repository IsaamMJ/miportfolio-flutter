import 'package:miportfolio/domain/repository/header_repository.dart';
import '../../presentation/pages/header/navigation_helper.dart';
import '../../utils/section_keys.dart';
import '../models/header_item.dart';

class HeaderRepositoryImpl implements HeaderRepository{

  @override
  List<HeaderItem> getHeaderItems() {
    return [
      HeaderItem(
        title: "HOME",
        onTap: () => scrollToSection(homeKey),
      ),
      HeaderItem(
        title: "TECHNICAL SKILLS",
        onTap: () => scrollToSection(servicesKey),
      ),
      HeaderItem(
        title: "PORTFOLIO",
        onTap: () => scrollToSection(portfolioKey),
      ),
      HeaderItem(
        title: "PROFESSIONAL EXPERIENCE",
        onTap: () => scrollToSection(testimonialsKey),
      ),
      HeaderItem(
        title: "MY PROCESS",
        onTap: () => scrollToSection(blogsKey),
      ),
      HeaderItem(
        title: "HIRE ME",
        onTap: () => scrollToSection(contactKey),
        isButton: true,
      ),
    ];
  }
}