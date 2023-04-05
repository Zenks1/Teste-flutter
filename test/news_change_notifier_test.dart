import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing_tutorial/article.dart';
import 'package:flutter_testing_tutorial/news_change_notifier.dart';
import 'package:flutter_testing_tutorial/news_service.dart';
import 'package:mocktail/mocktail.dart';

class MockNewsService extends Mock implements NewsService {}

void main() {
  late NewsChangeNotifier sut;
  late MockNewsService mockNewsService;

  setUp(() {
    mockNewsService = MockNewsService();
    sut = NewsChangeNotifier(mockNewsService);
  });

  test(
    "valores iniciais corretos",
    () {
      expect(sut.articles, []);
      expect(sut.isLoading, false);
    },
  );

  group('getArticles', () {
    final articlesFromService = [
      Article(title: 'Test 1', content: 'Teste1'),
      Article(title: 'Test 2', content: 'Teste2'),
      Article(title: 'Test 3', content: 'Teste3'),
    ];

    void arrangeNewsServiceReturns3Articles() {
      when(() => mockNewsService.getArticles()).thenAnswer(
        (_) async => articlesFromService,
      );
    }

    test(
      "Usa o newsservice e recebe x",
      () async {
        arrangeNewsServiceReturns3Articles();
        await sut.getArticles();
        verify(() => mockNewsService.getArticles()).called(1);
      },
    );

    test(
      """carregando, para de carregar se o artigo ja for trazido""",
      () async {
        arrangeNewsServiceReturns3Articles();
        final future = sut.getArticles();
        expect(sut.isLoading, true);
        await future;
        expect(sut.articles, articlesFromService);
        expect(sut.isLoading, false);
      },
    );
  });
}
