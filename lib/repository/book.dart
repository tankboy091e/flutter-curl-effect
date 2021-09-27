import 'package:book_sample/model/book.dart';
import 'package:book_sample/model/page.dart';

class BookRepository {
  static final BookRepository _instance = BookRepository._();
  factory BookRepository() => _instance;
  BookRepository._();

  final _cache = [
    BookModel(
      title: '종생기',
      pages: [
        PageModel(
          paragraph: '극유산호. 요 다섯 자 동안에 나는 두 자 이상의 오자를 범했는가 싶다.',
        ),
        PageModel(
          paragraph: '이것은 나 스스로 하늘을 우러러 부끄러워 할 일이겠으나',
        ),
        PageModel(
          paragraph: '인지가 발달해 가는 면목이 실로 약여하다.',
        ),
        PageModel(
          paragraph: '죽는 한이 있더라도 이 산호 채찍일랑 꽉 쥐고 죽으리라.',
        ),
        PageModel(
          paragraph: '내 폐포파립 우에 퇴색한 망해 우에 봉황이 와 앉으리라.',
          image: 'https://picsum.photos/seed/5/500/500',
        ),
        PageModel(
          paragraph: '나는 내 종생기가 천하 눈 있는 선비들의 간담을 서늘하게 해 놓기를',
          image: 'https://picsum.photos/seed/6/500/500',
        ),
        PageModel(
          paragraph: '애틋하게 바라는 일념 아래의 만큼 인색한 내 맵씨의 절약법을 피력하여 보인다.',
          image: 'https://picsum.photos/seed/7/500/500',
        ),
        PageModel(
          paragraph: '일발포성에 부득이 영웅이 되고 만 희대의 군인 모는',
          image: 'https://picsum.photos/seed/8/500/500',
        ),
        PageModel(
          paragraph: '아흔에 귀를 단 황송한 일생을 끝막던 날 이렇다는 유언 한마디를 지껄이지 않고',
          image: 'https://picsum.photos/seed/9/500/500',
        ),
        PageModel(
          paragraph: '그 임종의 장면을 곧잘 넘겼다.',
          image: 'https://picsum.photos/seed/10/500/500',
        ),
        PageModel(
          paragraph: '그런데 우리들의 레우오치카는 괴나리봇짐을 짊어지고 나선 데까지는',
          image: 'https://picsum.photos/seed/11/500/500',
        ),
        PageModel(
          paragraph: '기껏 그럴 성싶게 꾸며 가지고 마지막 오 분에 가서 그만 잡았다.',
          image: 'https://picsum.photos/seed/12/500/500',
        ),
        PageModel(
          paragraph: '자지레한 유언 나부랭이로 말미암아 칠십 년 공든 탑을 무너뜨렸고',
          image: 'https://picsum.photos/seed/13/500/500',
        ),
        PageModel(
          paragraph: '허울 좋은 일생에 가실 수 없는 흠집을 하나 내어 놓고 말았다.',
          image: 'https://picsum.photos/seed/14/500/500',
        ),
        PageModel(
          paragraph: '나는 일개 교활한 옵서버의 자격으로 그런 우매한 성인들의 생애를 방청하여 있으니',
          image: 'https://picsum.photos/seed/15/500/500',
        ),
        PageModel(
          paragraph: '내가 그런 따위 실수를 알고도 재범할 리가 없는 것이다.',
          image: 'https://picsum.photos/seed/16/500/500',
        ),
        PageModel(
          paragraph: '거울을 향하여 면도질을 한다. 잘못해서 나는 생채기를 내인다.',
          image: 'https://picsum.photos/seed/17/500/500',
        ),
        PageModel(
          paragraph: '나는 골을 벌컥 내인다.',
          image: 'https://picsum.photos/seed/18/500/500',
        ),
      ],
    )
  ];

  Future<List<BookModel>> retrieveAll() async {
    return _cache;
  }
}
