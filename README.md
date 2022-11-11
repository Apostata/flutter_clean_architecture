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
  A camada de dados está localizada na camada mais externa. Essa camada consiste em código-fonte de dados, como API Rest de consumo, acesso ao banco de dados local, Firebase ou outras fontes.
  </br>

    1. **Models**
   A definição das Entities Levando em conta as transformações de dados necessárias(to json, from json)
   </br>

     1. **Repositories**
   As implementações reais das classes e métodos das regras do app, Valida os casos de sucesso e falhas
   </br>

     1. **Datasources**
   Classes e métodos de conexões externas do app, exemplo,  das chamadas de APIs, neste caso só consideramos o resultado esperado, visto que quem trata essa validação é o Repositories, aqui apenas mapeamos os erros de status code e lançamos uma exception customizada para cada erro que quiser tratar
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
class GetCurrentWeatherUsecase implements IUseCase<IWeather, String> {
  final IWeatherRepository repository;
  GetCurrentWeatherUsecase(this.repository);

  @override
  Future<Either<Failure, IWeather>> call(String cityName) {
    return repository.getCurrentWeatherByCityName(cityName);
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
A iremos iniciar a Ui

#### Teste de BLoC
1. Como iremos usar o padrão BLoC para gerenciamento de estado, vamos iniciar criandos os teste para ele `test/features/presenter/bloc/weather_block_test.dart` e como sempre iniciará na red phase.
```dart
void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetCurrentWeatherUsecase usecase;
  late WeatherBloc weatherBloc;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    usecase = GetCurrentWeatherUsecase(mockWeatherRepository);
    weatherBloc = WeatherBloc(usecase);
  });

  void successGetWeatherFromUsecase() {
    when(() => usecase(tCityName))
        .thenAnswer((invocation) async => const Right(tWeatherEntity));
  }

  void failGetWeatherFromUsecase() {
    when(() => usecase(tCityName)).thenAnswer((invocation) async =>
        const Left(ServerFailure('Something went wrong')));
  }

  test('Initial BLoc state should be empty', () {
    expect(weatherBloc.state, WeatherEmptyState());
  });

  blocTest(
    'should emit [loading, has data] when get data is successful',
    build: () {
      successGetWeatherFromUsecase();
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(tCityName)),
    expect: () => [
      WeatherLoadingState(),
      const WeatherLoadedState(tWeatherEntity),
    ],
  );

  blocTest(
    'should emit [loading, error] when get data is unsuccessful',
    build: () {
      failGetWeatherFromUsecase();
      return weatherBloc;
    },
    act: (bloc) => bloc.add(const OnCityChanged(tCityName)),
    expect: () => [
      WeatherLoadingState(),
      const WeatherErrorState('Something went wrong'),
    ],
  );
}
```

2. Criar o BLoC, para isso teremos de iniciar criando os estaos do BLoC `lib/features/presenter/bloc/weather_state.dart`:
```dart
abstract class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object?> get props => [];
}

class WeatherEmptyState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final IWeather weather;
  const WeatherLoadedState(this.weather);

  @override
  List<Object?> get props => [weather];
}

class WeatherErrorState extends WeatherState {
  final String message;
  const WeatherErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
```

3. E depois os eventos `lib/features/presenter/bloc/weather_event.dart` :
```dart
abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
  @override
  List<Object?> get props => [];
}

class OnCityChanged extends WeatherEvent {
  final String cityName;
  const OnCityChanged(this.cityName);

  @override
  List<Object?> get props => [cityName];
}
```
4. e então o BLoC em si `lib/features/presenter/bloc/weather_bloc.dart` :
```dart
class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final GetCurrentWeatherUsecase _getCurrentWeather;

  WeatherBloc(this._getCurrentWeather) : super(WeatherEmptyState()) {

    on<OnCityChanged>((event, emit) async {
      final cityName = event.cityName;
      emit(WeatherLoadingState());

      final weatherResult = await _getCurrentWeather(cityName);

      weatherResult.fold((failure) {
        emit(WeatherErrorState(failure.message));
      }, (data) {
        emit(
          WeatherLoadedState(data),
        );
      });
    });
  }
}
```
5. criar o mock para o BLoC `test/mocks/mock_weather_bloc.dart`:
```dart
class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

class FakeWeatherState extends Fake implements WeatherState {}

class FakeWeatherEvent extends Fake implements WeatherEvent {}
```
6. Agora os teste do BLoC `test/features/presenter/bloc/weather_block_test.dart` deve passar.
   
#### Testes de Widget
Para finalizar criaremos a o frontend em si, neste caso só teremos uma página

1. criar o teste da `WeatherPage` `test/features/presenter/pages/weather_page_test.dart`, que inicialmente estará na red phase:
```dart
void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUpAll(() async {
    HttpOverrides.global = null;
    registerFallbackValue(FakeWeatherState());
    registerFallbackValue(FakeWeatherEvent());

    final di = GetIt.instance;
    di.registerFactory<WeatherBloc>(() => mockWeatherBloc);
  });

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>.value(
      value: mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('text field should trigger state to change from empty to loading',
      (tester) async {
    when(() => mockWeatherBloc.state).thenReturn(WeatherEmptyState());

    await tester.pumpWidget(
      makeTestableWidget(
        const WeatherPage(),
      ),
    );
    await tester.enterText(
      find.byType(TextField),
      tCityName,
    );
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(
      find.byType(TextField),
      equals(findsOneWidget),
    );
    verify(
      () => mockWeatherBloc.add(const OnCityChanged(tCityName)),
    );
  });

  testWidgets(
      'Should show widget containg weather data when state is WeatherLoadedState',
      (tester) async {
    when(() => mockWeatherBloc.state)
        .thenReturn(const WeatherLoadedState(tWeatherEntity));

    await tester.pumpWidget(
      makeTestableWidget(
        const WeatherPage(),
      ),
    );
    await tester.runAsync(
      () async {
        final HttpClientCustom httpClient = HttpClientCustom();
        await httpClient.get(weatherIcon('03d'));
      },
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const Key('weather_data')),
      equals(findsOneWidget),
    );
  });
}
``` 
2. Implementação da `WeatherPage` `lib/features/presenter/pages/weather_page.dart`:

```dart
class WeatherPage extends StatelessWidget {
  const WeatherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'Weather',
            style: TextStyle(color: Colors.orange),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              TextField(
                textAlign: TextAlign.center,
                decoration:
                    const InputDecoration(hintText: 'Enter a city name'),
                onSubmitted: (query) {
                  context.read<WeatherBloc>().add(OnCityChanged(query));
                },
              ),
              const SizedBox(
                height: 32,
              ),
              BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is WeatherLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is WeatherLoadedState) {
                    return Center(
                      child: Column(
                        key: const Key('weather_data'),
                        children: [
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    state.weather.cityName,
                                    style: const TextStyle(fontSize: 22),
                                  ),
                                ),
                                Image(
                                  image: NetworkImage(
                                    weatherIcon(state.weather.iconCode),
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Flexible(
                                  flex: 2,
                                  child: Text(
                                    '${state.weather.main} | ${state.weather.description}',
                                    style: const TextStyle(
                                      letterSpacing: 1.2,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 24),
                              ],
                            ),
                          ),
                          Center(
                            child: Table(
                              defaultColumnWidth: const FixedColumnWidth(150),
                              border: TableBorder.all(
                                color: Colors.grey,
                                style: BorderStyle.solid,
                                width: 1,
                              ),
                              children: [
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Temperature',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        '${state.weather.temperature.ceil().toString()}ºC',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Pressure',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        state.weather.pressure.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8),
                                      child: Text(
                                        'Humidity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        state.weather.humidity.toString(),
                                        style: const TextStyle(
                                          fontSize: 16,
                                          letterSpacing: 1.2,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (state is WeatherErrorState) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
```
3. agora os testes `test/features/presenter/pages/weather_page_test.dart` devem passar.

Para finalizar, teremos que criar o arquivo que tratará a injeção de dependencias no app e carrega-lo no Widget inicial.
### injeção de dependencias
criaremos o arquivo `lib/injecttion.dart` :
```dart
final locator = GetIt.instance;

void init() {
  // bloc
  locator.registerFactory(
    () => WeatherBloc(locator()),
  );

  // usecase
  locator.registerLazySingleton(
    () => GetCurrentWeatherUsecase(locator()),
  );

  // repository
  locator.registerLazySingleton<IWeatherRepository>(
    () => WeatherRepository(locator()),
  );

  // datasource
  locator.registerLazySingleton<IWeatherDatasource>(
    () => WeatherDataSource(locator()),
  );

  // httpClient
  locator.registerLazySingleton<IHttpClient>(() => HttpClientCustom());
}
```
#### Carregando a injeção no Widget inicial
para ginalizar, basta chamar a função `init()` do arquivo `lib/injecttion.dart` no `/lib/main.dart` e passar parao `WeatherBloc` no `MyApp` via `BlocBuilder` ou `MultiBlocProvider` caso tenhamos mais de um bloc por exemplo.

```dart
void main() {
  di.init(); //iniciar a injeção
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<WeatherBloc>(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const WeatherPage(),
      ),
    );
  }
}
```
## Packages utilizadas:
dartz - Implementação dos conceitos de progrmação funcional para dart
http - Chamadas http
flutter_bloc - Para implementação do BLoC para gerenciamento de estaos
get_it - Para injeção de dependencias
equatable - Facilitar a comparação de objetos no dart, mesmo entre duas instancias. (bom para testes)
mocktail - Facilitar Mock, Fake e Stubs e não tem gerção de código como o Mockito
bloc_test - Facilitar os testes de BLoC

Agradecimentos pelo conhecimento fornecido:
[Tutorial no youtube](https://www.youtube.com/watch?v=odr59ZAx-IU&list=PLnFA4SZ9y0T5FA2dFdNh6NLD6Rm6GB6x7) by [LeBaleiro](https://github.com/LeBaleiro)
e
[Tutorial no medium](https://betterprogramming.pub/flutter-clean-architecture-test-driven-development-practical-guide-445f388e8604) by [CodeStronaut](https://github.com/codestronaut)
