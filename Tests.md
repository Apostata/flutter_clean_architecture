# Testing
Estrutuda de testes AAA
- Arrange
  - Prover as informações para o test
- Act
  - Usar os informações 
- Assert
  - Testar se a ação com as informações	fornecidas tem o comportamento esperado

## TDD (Test driven development)
 - Escrever o testes (inicialmente irá Falhar, pois não existe a funcionalidades)
 - Fazer o teste passar (escrever a função para que o test funcione)
 - Refatorar (para aprimorar)
  
### Unit Testing
- Testar uma unidade do código.
    -   uma classe, uma função, etc.
  
- Teste precisa ser independente
- Não deve haver nenhuma implmentação da lógica no teste unitário (usa-se mocks)
- Teste precisa ser simples, rápido, limpo e legível

### Integration Testing


## Testes no Flutter

Arquivos devem terminar com `_test`, exemplo, para testar o arquivo `validator.dart`, criar um `validator_test.dart`.


## Faking, Mocking e Stubing
Objetos Fake realmente têm implementações de trabalho, mas geralmente usam algum atalho que os torna inadequados para produção

Os Stubs fornecem respostas prontas para chamadas feitas durante o teste, geralmente não respondendo a nada fora do que está programado para o teste. Os Stubs também podem registrar informações sobre chamadas, como um Stub de gateway de e-mail que lembra as mensagens que 'enviaram' ou talvez apenas quantas mensagens 'enviaram'.

Mocks são objetos pré-programados com expectativas que formam uma especificação das chamadas que se espera que recebam.

### Escrevendo testes
```dart
void main(){

  setUpAll(()={
    // alguma coisa para rodar antes de todos os testes
  });

  setUp((){
    // algum coisa para rodar antes de cada teste
  });

  tearDown((){
    // alguma coisa para rodar após cada teste, falhando ou não
  })

  tearDownAll((){
    // alguma coisa para rodar todos os teste, falhando ou não
  })


  group('um grupo de teste', (){
    test('Descrição completa do teste', (){
        // Arrange

        // Act

        // Assert
    });
  });

  test('Descrição completa de outro teste', (){
        // Arrange

        // Act

        // Assert
    });
}
```

#### setUpAll
Roda antes de todos os testes do grupo ou geral 
(Aqui injetamos as dependencias caso algum teste precise)

#### setUp
Roda antes de cada teste do grupo ou geral

#### tearDown 
Roda depois de cada teste do grupo ou geral. Mesmo que o teste falhe

#### tearDown 
Roda depois de todos os testes do grupo ou geral. Mesmo que o teste falhem

#### Interceptando alguma chamada
Abaixo segue o padrão do `Mocktail`(lib para mocks, aparentemente melhor que `Mockito`) para interceptação de chamadas assíncronas e síncronas

##### Chamada com resposta assíncrona
```dart
...
when(() => algumaFuncaoAsync(algumParametro))
        .thenAnswer((invocation) async => mockDaRespostaAsync);

await instancia.algumaFuncaoAsync(algumParametro);

verify(() => instanciaFilhaMock.algumaFuncaoFilha(qualquerParametro)).called(1);
...

```

##### Chamada com resposta síncrona
```dart
...
when(() => algumaFuncaoSync(algumParametro))
        .thenReturn((invocation) => mockDaRespostaSync);

instancia.algumaFuncaoAsync(algumParametro);

verify(() => instanciaFilhaMock.algumaFuncaoFilha(qualquerParametro)).called(1);
...

```

#### Mocks
usando o `Mocktail` é extemamente simples

```dart
class AlgumaClasseMock extends Mock implements AlgumaClasse{} 
```
