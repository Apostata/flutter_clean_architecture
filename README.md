# Clean Architecture usando
Pensar em camadas independentes e desacopladas e para projetos grandes
A Estrutuda tem que deixar claro a intenção do app, como um projeto de ecommerce, ou qualquer outro ramo
Pincipio de injeção de dependencias, sempre depender de uma interface (mas no caso uma classe asbrata), já que a implementação pode variar
Sempre extender e não modificar a classe

Primeiro pensa na camada de negócio

**Pastas**
-lib
|- Core = Coisas compartilhadas entre as features
|---- Usecases (Interfaces que serão compartilhadas nas camadas de Features)
|---- Utils
|- Features 
|---- Domain (camada de abstração, Interfaces)
|------- Entities (Interfaces dos modelos)
|------- Repositories (Interfaces das funções do app)
|------- Usecases (Implementação dos repositórios Interfaces, regra de negócio e validações)
|---- Data (camada e implementação)
|------- Datasources (conexão real ao mundo externo. chamada APIs só importa o resultado feliz)
|------- Models (modelos externos, implmenta Interfaces das Entities)
|------- Repositories (implementação Interfaces dos Repositories de Domain, validação dos erros de api e etc)
|---- Presenter
|------- Widgets
|------- Pages
-test

## Camadas do clean code
**1. Core**

  os UseCases e utilitários que serão compartilhados entre as camadas

**2. Features**  
  o projeto a grosso modo

  - <ins>Domain</ins>
  A camada que não depende de nenhuma outra camada aqui é apenas a camada de domínio (independente) que é o código para a lógica de negócios. Dessa forma, o aplicativo é mais adaptável e dinâmico. Por exemplo, se quisermos alterar o gerenciamento de estado do provedor para BLoC, o processo de migração não interferirá na lógica de negócios existente.
  </br>

    1. **Entities**
  Interface dos modelos de dados(schemmas) ignorando as transformações e o formato de dados extennos 
  </br>

    2. **Repositories**
  Interfaces das classes e métodos das regras do app
  </br>

    3. **Usecases**
  A implementação das Interfaces dos Repositoriese e validações dados quando necessários
  </br>

  - <ins>Data</ins>
  A camada de dados está localizada na camada mais externa. Essa camada consiste em código-fonte de dados, como API Rest de consumo, acesso ao banco de dados local, Firebase ou outras fontes. Além disso, nesta camada, geralmente há o código da plataforma que constrói a interface do usuário (widgets).
  </br>

    1. **Models**
   A definição das Entities Levando em conta as transformações de dados necessárias
   </br>

     2. **Repositories**
   As implementações reais das classes e métodos das regras do app, Valida os casos de sucesso e falhas
   </br>

     3. **Datasources**
   Implementação das classes e métodos de conexões externas do app, exemplo,  das chamadas de APIs, neste caso só consideramos o resultado esperado, visto que quem trata essa validação é o Repositories, aqui apenas mapeamos os erros de status code e lançamos uma exception customizada para cada erro que quiser tratar
  </br>

- <ins>Presenter</ins>
   A camada de apresentação consiste no código para acessar os dados do aplicativo a partir de um repositório. Além disso, há o código para gerenciamento de estado, como provedores, BLoC e assim por diante.

  
## Ferramentas
iremos usar a [api do open weather](https://api.openweathermap.org/data/2.5/weather?q={cidade}&appid={apiKey})

E gerenciamento de estado com o padrão **BLoC**.

libs utilizadas no projeto:
* Dartz
* Equatable
* Mocktail
* Http

## Passo a Passo da implementação do clean architecture

### Trabalhando do Domain layer
Primeiro Criar um teste de usecase para ver se o repositório traz a entidade desejada (simulando uma chamada na api)
Obviamente este teste vai falhar pois não temos nenhum código ainda

1. criar o teste do usecase, `test/features/domain/usecases/get_current_weather_usecase.dart`
  ``` dart
    void main() {
      late MockWeatherRepository mockWeatherRepository;
      late GetCurrentWeatherUsecase usecase;

      setUp(() {
        mockWeatherRepository = MockWeatherRepository();
        usecase = GetCurrentWeatherUsecase(mockWeatherRepository);
      });

      const tWeatherDetails = IWeather(
        cityName: 'Indaiatuba',
        main: 'Clouds',
        description: 'scattered clouds',
        iconCode: '03d',
        temperature: 300.45,
        pressure: 1014,
        humidity: 21,
      );

      const tCityName = 'Indaiatuba';

      test('Should get current weather from the repository', () async {
        when(
          () => mockWeatherRepository.getCurrentWeather(tCityName),
        ).thenAnswer(
          (_) async => const Right(tWeatherDetails),
        );

        final result = await usecase(tCityName);

        expect(
          result,
          const Right(tWeatherDetails),
        );
      });
    }
  ```
2. Definir a entidade  `lib/features/domain/usecases/get_current_weather_usecase.dart`
Um dos erros é por conta que a entidade `IWeather` não existe ainda, então temos de definir a entidade
 ```dart
class IWeather extends Equatable {
  final String cityName;
  final String main;
  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int humidity;

  const IWeather({
    required this.cityName,
    required this.main,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.humidity,
  });

  @override
  List<Object?> get props => [
        cityName,
        main,
        description,
        iconCode,
        temperature,
        pressure,
        humidity,
      ];
}
 ```

3. criar o repositório `lib/features/domain/repositories/weather_repository.dart`: 

```dart
abstract class IWeatherRepository {
  Future<Either<Failure, IWeather>> getCurrentWeather(String cityName);
}

```

4. criar o usecase `lib/features/domain/usecases/get_current_weather_usecase.dart`:
```dart
class GetSpaceMediaFromDateUsecase
    implements IUseCase<SpaceMediaEntity, DateTime> {
  final ISpaceMediaRepository repository;
  GetSpaceMediaFromDateUsecase(this.repository);

  @override
  Future<Either<Failure, SpaceMediaEntity>> call(DateTime? date) async {
    return date != null
        ? await repository.getSpaceMediaFromDate(date)
        : Left(NullParamError());
  }
}

```
5. para criar um padrão para todos usecases vamos criar uma interface IUseCase, assim seremos obrigados e passar a entrada e a saida para uma obrigatória função call `lib/core/Interfaces/usecase.dart`
```dart
abstract class IUseCase<Output, Input> {
  Future<Either<Failure, Output>> call(Input params);
}
```

6. Criar o mocks do repository para instanciar o usecase `test/mocks/mock_weather_repository.dart`
```dart
class MockWeatherRepository extends Mock implements IWeatherRepository {} //usando Mocktail
```

7. executar o teste do usecase `test/features/domain/usecases/get_current_weather_usecase.dart` e agora deve passar

### Trabalhando no Data layer

#### Teste de model
1. Criar os teste de model, e como antes este teste iniciará na red phase, e não irá funcionar: `test/features/data/models/weather_model_test.dart`
```dart
void main() {
  group('to entity', () {
    test('Should tWeatherModel be a subclass of Weather entity (IWeather)', () {
      final tWheaterModelToEntity = tWheaterModel.toEntity();

      expect(tWheaterModelToEntity, tWeatherEntity);
    });
  });

  group('from json', () {
    test('Should return a valid WeatherModel from a given json', () {
      final Map<String, dynamic> jsonMap = jsonDecode(mockWeatherApiResponse);

      final tJsonToWeatherModel = WeatherModel.fromJson(jsonMap);
      expect(tJsonToWeatherModel, tWheaterModel);
    });
  });

  group('to json', () {
    test('Should return a valid json from a given WeatherModel', () {
      final tJsonMapFromWheaterModel = tWheaterModel.tojson();
      expect(tJsonMapFromWheaterModel, weatherModelToMap);
    });
  });

  group('to string', () {
    test('Should return a string representation of the Weather model', () {
      final tStringFromWeatherModel = tWheaterModel.toString();
      expect(tStringFromWeatherModel, tMockWeatherToString);
    });
  });
}
```

2. criar o WheaterModel: `lib/features/data/models/weather_model.dart` e as funções de conversão:
```dart
    class WeatherModel extends IWeather {
    const WeatherModel({
      required String cityName,
      required String main,
      required String description,
      required String iconCode,
      required double temperature,
      required int pressure,
      required int humidity,
    }) : super(
            cityName: cityName,
            main: main,
            description: description,
            iconCode: iconCode,
            temperature: temperature,
            pressure: pressure,
            humidity: humidity,
          );

    factory WeatherModel.fromJson(Map<String, dynamic> json) {
      return WeatherModel(
        cityName: json["name"],
        main: json["weather"][0]['main'],
        description: json["weather"][0]['description'],
        iconCode: json["weather"][0]['icon'],
        temperature: json["main"]['temp'],
        pressure: json["main"]['pressure'],
        humidity: json["main"]['humidity'],
      );
    }

    Map<String, dynamic> tojson() {
      return {
        "weather": [
          {
            "main": main,
            "description": description,
            "icon": iconCode,
          },
        ],
        "main": {
          "temp": temperature,
          "pressure": pressure,
          "humidity": humidity,
        },
        "name": cityName,
      };
    }

    IWeather toEntity() {
      return IWeather(
          cityName: cityName,
          main: main,
          description: description,
          iconCode: iconCode,
          temperature: temperature,
          pressure: pressure,
          humidity: humidity);
    }

    @override
    String toString() {
      return 'WeatherModel('
          'cityName: $cityName, '
          'main: $main, '
          'description: $description, '
          'iconCode: $iconCode, '
          'temperature: $temperature, '
          'pressure: $pressure, '
          'humidity: $humidity)';
    }
  }
```
3. agora os teste de model `test/features/data/models/weather_model_test.dart` irão passar.

#### Teste de Datasources
1. Cria o teste de datasource, e como antes, o teste iniciará na red phase, e não irá funcionar `test/features/data/datasources/weather_datasource_test.dart`
```dart
void main() {
  late MockHttpClient mockHttpClient;
  late WeatherDataSource dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = WeatherDataSource(mockHttpClient);
  });

  void httpGetSuccess() {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (invocation) async => HttpResponse(mockWeatherApiResponse, 200),
    );
  }

  void httpGetFail() {
    when(() => mockHttpClient.get(any())).thenAnswer(
      (invocation) async => HttpResponse('something went wrong', 400),
    );
  }

  group('get corrent weather url', () {
    test('Should call the client.get with correct url', () async {
      httpGetSuccess();

      await dataSource.getCurrentWeatherByCityName(tCityName);

      verify(() => mockHttpClient.get(mockApiUrl)).called(1);
    });
  });

  group('get current weather responses', () {
    test('Should return a WeatherModel when successful calls the api',
        () async {
      httpGetSuccess();

      final successfulResponse =
          await dataSource.getCurrentWeatherByCityName(tCityName);

      expect(successfulResponse, tWheaterModel);
    });

    test('Should return a ServerException when unsuccessful calls the api',
        () async {
      httpGetFail();

      final unsuccessfulResponse =
          dataSource.getCurrentWeatherByCityName(tCityName);

      expect(unsuccessfulResponse, throwsA(ServerException()));
    });
  });
}
```

2. Definir a interface do dataSource, para definir a interface da fonte de dados para a Api do Open Weather `lib/features/data/datasources/weather_datasource_interface.dart` :
```dart
abstract class IWeatherDatasource {
  Future<WeatherModel> getCurrentWeatherByCityName(String cityName);
}
```

3. Criar a implementação deste datasource `lib/features/data/datasources/weather_datasource_implementation.dart` :
```dart
class WeatherDataSource implements IWeatherDatasource {
  final IHttpClient client;
  WeatherDataSource(this.client);

  @override
  Future<WeatherModel> getCurrentWeatherByCityName(String cityName) async {
    final url = WeatherEndpoints.getCurrentWeatherByName(
        OpenWeatherApiKeys.apiKey, cityName);
    final ressponse = await client.get(url);
    if (ressponse.statusCode == 200) {
      return WeatherModel.fromJson(
        jsonDecode(ressponse.data),
      );
    } else {
      throw ServerException();
    }
  }
}
```
4. Como é possível que cade desenvolvedor use uma lib diferente para requisições http, como o HTTP ou o DIO, criaremos também uma interface para ela `lib/core/http_client/http_client_interface.dart` :
```dart
abstract class IHttpClient {
  Future<HttpResponse> get(String url);
}
```

5. e também o HttpResponse customizado `lib/core/Interfaces/http_response.dart` :
```dart
class HttpResponse {
  final dynamic data;
  final int statusCode;

  HttpResponse(
    this.data,
    this.statusCode,
  );
}
```

6. Criamos o MockHttpClient para `test/mocks/mock_http_client.dart`:
```dart
class MockHttpClient extends Mock implements IHttpClient {}
```

7. agora os teste do dataSource `test/features/data/datasources/weather_datasource_test.dart` irão passar.

#### Teste de repository
1. Cria o teste de repository, e como antes, o teste iniciará na red phase, e não irá funcionar `test/features/data/repositories/weather_repository_implementation_test.dart`
```dart
void main() {
  late MockWeatherDataSource mockWeatherDataSource;
  late WeatherRepository repository;

  setUp(() {
    mockWeatherDataSource = MockWeatherDataSource();
    repository = WeatherRepository(mockWeatherDataSource);
  });

  void dataSoruceGetSuccess() {
    when(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
        .thenAnswer(
      (invocation) async => tWheaterModel,
    );
  }

  void dataSoruceGetFail() {
    when(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
        .thenThrow(ServerException());
  }

  void dataSoruceGetNoConnection() {
    when(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
        .thenThrow(SocketException());
  }

  group('get weather from datasource', () {
    test(
        'Should return the Weather when successful call the the datasource from repository',
        () async {
      dataSoruceGetSuccess();

      final successfulResponse =
          await repository.getCurrentWeatherByCityName(tCityName);

      expect(successfulResponse, const Right(tWheaterModel));
      verify(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
          .called(1);
    });

    test(
        'Should ServerExeption when unsuccessful call the the datasource from repository',
        () async {
      dataSoruceGetFail();

      final unsuccessfulResponse =
          await repository.getCurrentWeatherByCityName(tCityName);

      expect(
        unsuccessfulResponse,
        const Left(
          ServerFailure('Something went wrong'),
        ),
      );
      verify(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
          .called(1);
    });

    test('Should SocketException when there is no connection', () async {
      dataSoruceGetNoConnection();

      final unsuccessfulResponse =
          await repository.getCurrentWeatherByCityName(tCityName);

      expect(
        unsuccessfulResponse,
        const Left(
          ConnectionFailure('Failed to connect to newwork!'),
        ),
      );
      verify(() => mockWeatherDataSource.getCurrentWeatherByCityName(tCityName))
          .called(1);
    });
  });
}
```
   
2. Criar a implementação do repository `lib/features/data/repositories/weather_repository_implementation.dart` :
```dart
class WeatherRepository implements IWeatherRepository {
  final IWeatherDatasource datasource;

  WeatherRepository(this.datasource);

  @override
  Future<Either<Failure, IWeather>> getCurrentWeatherByCityName(
      String cityName) async {
    try {
      final result = await datasource.getCurrentWeatherByCityName(cityName);
      return Right(result);
    } on ServerException {
      return const Left(ServerFailure('Something went wrong'));
    } on SocketException {
      return const Left(ConnectionFailure('Failed to connect to newwork!'));
    }
  }
}
``` 

3. criar o mock do repository `test/mocks/mock_weather_repository.dart` :
```dart
class MockWeatherRepository extends Mock implements IWeatherRepository {}
```

7. agora os teste do repository `test/features/data/repositories/weather_repository_implementation_test.dart` irão passar.

### Trabalhando no Presenter layer
Como iremos usar o padrão BLoC, vamos iniciar criandos os teste para ele.

## Factory, retorna uma nova instancia da classe

Agradecimentos pelo conhecimento fornecido:
[Tutorial no youtube](https://www.youtube.com/watch?v=odr59ZAx-IU&list=PLnFA4SZ9y0T5FA2dFdNh6NLD6Rm6GB6x7) by [LeBaleiro](https://github.com/LeBaleiro)
e
[Tutorial no medium](https://betterprogramming.pub/flutter-clean-architecture-test-driven-development-practical-guide-445f388e8604) by [CodeStronaut](https://github.com/codestronaut)
