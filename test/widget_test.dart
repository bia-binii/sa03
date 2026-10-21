// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

import 'package:sa03/main.dart';

void main() {
  // Simula o GET para verificar a interface sem depender do servidor PHP.
  testWidgets('exibe tarefas retornadas pela API', (tester) async {
    final client = MockClient(
      (request) async => http.Response(
        jsonEncode([
          {
            'id': 7,
            'titulo': 'Estudar Flutter',
            'descricao': 'Revisar chamadas HTTP',
            'concluida': false,
          },
        ]),
        200,
      ),
    );

    await tester.pumpWidget(
      MyApp(
        api: TaskApi(
          client: client,
          endpoint: Uri.parse('http://localhost/tasks'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Estudar Flutter'), findsOneWidget);
    expect(find.text('Revisar chamadas HTTP'), findsOneWidget);
    expect(find.text('0 de 1 tarefas concluídas'), findsOneWidget);
  });

  // Confirma metodos, query parameters e campos enviados no JSON.
  test('usa GET, POST, PUT e DELETE com JSON', () async {
    final requests = <http.Request>[];
    final client = MockClient((request) async {
      requests.add(request);
      return http.Response(
        request.method == 'GET'
            ? jsonEncode([
                {
                  'id': 1,
                  'titulo': 'Tarefa',
                  'descricao': '',
                  'concluida': false,
                },
              ])
            : '{}',
        200,
      );
    });
    final api = TaskApi(
      client: client,
      endpoint: Uri.parse('http://localhost/tasks'),
    );

    final tasks = await api.getTasks();
    await api.createTask('Nova', 'Descrição');
    await api.updateTask(tasks.single, title: 'Alterada', completed: true);
    await api.deleteTask(tasks.single);

    expect(requests.map((request) => request.method), [
      'GET',
      'POST',
      'PUT',
      'DELETE',
    ]);
    expect(jsonDecode(requests[1].body)['titulo'], 'Nova');
    expect(requests[2].url.queryParameters['id'], '1');
    expect(jsonDecode(requests[2].body)['concluida'], isTrue);
    expect(requests[3].url.queryParameters['id'], '1');
    expect(
      requests.every(
        (request) =>
            request.headers['content-type']!.contains('application/json'),
      ),
      isTrue,
    );
  });

  // Uma resposta nao-2xx deve aparecer como erro legivel na tela.
  testWidgets('mostra estado de erro quando a API falha', (tester) async {
    final client = MockClient(
      (request) async => http.Response('indisponível', 503),
    );
    await tester.pumpWidget(
      MyApp(
        api: TaskApi(
          client: client,
          endpoint: Uri.parse('http://localhost/tasks'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('HTTP 503'), findsOneWidget);
    expect(find.text('Tentar novamente'), findsOneWidget);
  });
}
