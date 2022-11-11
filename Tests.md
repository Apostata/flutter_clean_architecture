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
    test('Descrição completa do teste', (){
        // Arrange

        // Act

        // Assert
    });
}
```