O objetivo desse exercício é a criação de uma aplicação web simples para lidar com importação e processamento de dados. A app deve receber, via um endpoint, uma lista de títulos financeiros, esses títulos devem ser importados para o banco de dados da aplicação, passando por etapas de validação interna e externa, essas validações podem gerar uma lista de críticas para cada título, que precisam ser armazenadas para consulta posterior. Deve ser criado também um endpoint para consulta dos títulos importados.

## Endpoint de importação de títulos

O endpoint de importação de títulos deverá receber no body da requisição um objeto JSON com uma array contendo os dados dos títulos a serem importados. Os atributos enviados pelo endpoint serão:

* Número do título - Alfanumérico.
* Valor - Decimal.
* Data de vencimento - Data no formato YYYY-MM-DD.
* CNPJ do cedente (emissor do título).
* CNPJ do sacado (pagador do título).

Ao receber os títulos, a app deve efetuar as seguintes validações:

* Se todos os campos estão preenchidos com o formato correto (todos os campos são obrigatórios).
* Valor deve ser maior que zero.
* Data de vencimento deve ser maior do que a data atual.
* Se já existe algum título com o mesmo número para o mesmo cedente.

Os títulos que não passarem pela validação interna não devem ser armazenados no banco de dados, nesse caso, deve ser passado no corpo da resposta do endpoint a lista de títulos que não passaram pela validação juntamente com uma mensagem descrevendo por que cada um desses títulos falharem na validação.

Após a validação interna, a app deve acionar APIs externas para validação dos títulos. As APIs são as seguintes:

1. Verificar se o cedente possui algum protesto em cartório.
2. Verificar se o sacado possui algum protesto em cartório.
3. Validação se o título já foi registrado para outra empresa.

## Endpoint de consulta de títulos

O endpoint de consulta de títulos cadastrados deve retornar um JSON array com os títulos cadastrados e deve receber os seguintes parâmetros para filtros os resultados:

* CNPJ do cedente.
* CNPJ do sacado.
* Período da data de vencimento.
* Se o título possui ou não alguma crítica.
* Número do título, podendo ser apenas parte do número do título.

Deve ser obrigatório informar sempre o CNPJ do cedente, a busca deve retornar uma mensagem de erro caso a requisição não tenha pelo menos o parâmetro de CNPJ do cedente preenchido. O retorno do endpoint de consulta de títulos cadastrados deve conter os dados dos títulos junto com a lista de críticas do título.

Ficará ao seu cargo definir o path e o formato dos parâmetros de entrada e de retorno do endpoint de importação e do endpoint de consulta de títulos.

## Endpoints que devem ser consumidos


Para fazer o exercício, vamos disponibilizar 2 endpoints que simulam essas validações. Para simplificar a implementação, esses endpoints irão sempre retornar dados simulados baseado nos dados enviados. No caso do endpoint de verificação de protesto, o endpoint sempre irá retornar nenhum protesto se o primeiro dígito do CNPJ for ímpar e irá retornar um protesto com dados aleatórios se o primeiro dígito do CNPJ for par. No caso da validação se o título já foi registrado por outra empresa, o endpoint sempre irá retornar que o título já foi registrado se o primeiro dígito do número do título for um número ímpar e irá retornar que o título não foi registrado se o primeiro dígito do número do título for par ou não for um número. Segue abaixo o link para a documentação desses endpoints mockados:

### Endpoint de validação de protestos:

> GET https://6e3v4cnk5i.execute-api.us-east-1.amazonaws.com/default/validatorProtestoFake?cnpj={cnpj}

#### Exemplo de retorno:

* params:
    * cnpj=87.865.863/0001-00
* response body:
    * [{"tabeliao":"Tabelião 34","valor":167394,"data":"2022-02-21"}

* params:
    * cnpj=31.201.274/0001-72
* response_body:
    * []

### Endpoint de validação se o título já está registrado:

> GET https://rgshxukw2a.execute-api.us-east-1.amazonaws.com/default/validadorRegistroTituloFake?numero_titulo={numero_titulo}

#### Exemplo de retorno:

* params:
    * numero_titulo=10006
* response body:
    * {"status":"nao_registrado"}

* params:
    * numero_titulo=20005
* response body:
    * {"status":"registrado"}

## Alguns pontos de atenção

* Considere que os endpoints de validação de protesto e de registro de título são de empresas terceiras, não temos controle sobre eles, eles podem estar temporariamente indisponíveis por algum problema de servidor ou de rede. O ideal seria a importação ter a capacidade de refazer a validação caso tenha algum problema de acesso aos endpoints.
* É provável que no futuro esse mesmo fluxo de importação seja utilizado mas com uma fonte de dados diferente da atual, a implementação deve levar isso em conta.
* Para simplificar a implementação, não é obrigatório a implementação de autenticação e autorização na aplicação web, mas isso será considerado um bônus na avaliação.
* O foco da vaga é back-end, mas seria muito bom ter devs que consigam atender a demandas de front-end Vue.js, a criação de um front-end simples que chama o endpoint de busca também será considerada um bônus, mas não é obrigatório.
* A única restrição tecnológica é a obrigatoriedade de uso de Ruby. Fica livre o uso de qualquer gem no projeto.
* O foco da avaliação do exercício é qualidade de código, design, uso de boas práticas e proficiência com o uso de linguagens e libs, não é necessário enviar nada relacionado a infra-estrutura/devops para rodar a app, mas será considerado um bônus.