# sa03
# Minhas tarefas

Aplicativo Flutter para consultar e gerenciar tarefas em uma API REST PHP.

## Configurar a API

O endereço fica em `apiUrl`, no início de `lib/main.dart`. O valor atual é
`http://10.140.170.23/pdm_api/tarefas.php`. Esse IP é privado: o celular ou
emulador precisa alcançar o servidor nessa rede e o servidor web deve aceitar
conexões do dispositivo. Para backend local, use o endereço de host adequado
ao emulador ou o IP da rede local para um aparelho físico.

O app envia e espera JSON com `id`, `titulo`, `descricao` e `concluida`. A
consulta GET pode retornar uma lista diretamente ou dentro de `tarefas`,
`data` ou `tasks`. POST envia, por exemplo:

```json
{
	"titulo": "Estudar Flutter",
	"descricao": "Revisar chamadas HTTP",
	"concluida": false
}
```

PUT envia o objeto completo e o identificador também em `?id=<id>`. DELETE
envia o identificador na URL e no corpo JSON. Respostas de sucesso devem usar
status HTTP 2xx. Ajuste esses nomes se o contrato do PHP for diferente.

## Executar

Com Flutter instalado, execute `flutter pub get` e `flutter run`. O app exibe
carregamento, lista vazia, erros HTTP/conexão e opção para tentar novamente.
Os testes usam respostas HTTP simuladas, sem exigir a API online.

O endpoint atual usa HTTP sem criptografia para desenvolvimento na rede local.
Em produção, prefira HTTPS e remova as exceções HTTP do Android e iOS.

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
