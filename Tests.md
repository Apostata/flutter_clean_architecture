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