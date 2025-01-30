# Desafio Técnico - E-commerce  

## Detalhes  
Este projeto é uma API que simula um carrinho de compras para um e-commerce, permitindo criar um carrinho, adicionar produtos, visualizar os itens e remover produtos. Também, conta com um job automatizado utilizando Sidekiq e Sidekiq-Scheduler, que roda a cada hora para gerenciar carrinhos inativos. Se um carrinho não tiver nenhuma alteração por mais de 3 horas, ele é marcado como abandonado. Caso permaneça abandonado por mais de 7 dias, é excluído automaticamente. Dessa forma, a API mantém a organização do sistema e evita o acúmulo de dados desnecessários.

## Informações técnicas  

- [Arquivo de collection para as requisições](carts.json)  

### Dependências  
- Ruby 3.3.1  
- Rails 7.1.3.2  
- PostgreSQL 16  
- Redis 7.0.15  

### Bibliotecas Utilizadas  

- **`active_model_serializers`**: Utilizada para estruturar e formatar as respostas da API de forma organizada. Com essa biblioteca, os dados retornados pelos endpoints são serializados de maneira padronizada, facilitando o consumo pelas aplicações clientes.  

- **`factory_bot_rails`**: Facilita a criação de dados fictícios para testes automatizados. Com essa biblioteca, é possível definir *factories* para gerar instâncias de modelos de forma eficiente, tornando os testes mais simples e evitando a necessidade de criar registros manualmente.  

- **`shoulda-matchers`**: Auxilia na escrita de testes unitários, fornecendo *matchers* que simplificam a verificação de validações e associações entre modelos do Rails. Com essa biblioteca, é possível testar regras como validações de presença, unicidade e relacionamentos de forma mais concisa.  

- **`byebug`**: Ferramenta de depuração que permite pausar a execução do código e inspecionar variáveis durante a execução da aplicação. Muito útil para identificar e corrigir erros de forma interativa.  

- **`rubocop`**: Ferramenta de análise estática de código que ajuda a manter um padrão de qualidade e estilo no código Ruby. Com o *Rubocop*, é possível identificar e corrigir automaticamente problemas de formatação, boas práticas e possíveis otimizações, garantindo um código mais limpo e sustentável.  


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

