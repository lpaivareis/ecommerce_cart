# Desafio Técnico - E-commerce  

## Detalhes  
Este projeto é uma pequena simulação de um carrinho de compras, onde é possível executar algumas funções, como criar um carrinho, adicionar produtos, remover produtos e visualizar o carrinho.  

## Informações técnicas  

- [Arquivo de collection para as requisições](carts.json)  

### Dependências  
- Ruby 3.3.1  
- Rails 7.1.3.2  
- PostgreSQL 16  
- Redis 7.0.15  

### Bibliotecas Utilizadas  
- `active_model_serializer` (Facilita a serialização das respostas dos endpoints)  
- `factory_bot_rails` (Facilita a criação de dados nos testes)  
- `shoulda-matchers` (Biblioteca que facilita os testes de validações e relacionamentos)  
- `byebug` (Ferramenta de depuração)  

### Como executar o projeto  

## Construindo e executando o container com Docker  

```console
$ docker-compose build
```

```console
$ docker-compose up
```

## Executar Rubocop  

Para executar o RuboCop e garantir que o código segue as boas práticas de estilo Ruby, utilize o comando abaixo dentro do container:  

```console
$ docker-compose run web bundle exec rubocop
```

## Executar RSpec  

Para rodar os testes automatizados com RSpec:  

```console
$ docker-compose run test
```

## Executando a aplicação sem Docker  

Caso todas as ferramentas estejam instaladas e configuradas:  

Instalar as dependências:  

```bash
bundle install
```

Executar o Sidekiq:  

```bash
bundle exec sidekiq
```

Iniciar o servidor:  

```bash
bundle exec rails server
```

Executar os testes:  

```bash
bundle exec rspec
```

Executar o rubocop:  

```bash
bundle exec rubocop
```

