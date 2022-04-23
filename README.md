Este é um importador e validador de títulos. Neste back-end estou incluindo uma opção extra do que foi pedido, incluindo uma opção de importação de títulos via arquivo CSV. No projeto existe um modelo chamado "modelo_importacao_titulos.csv", nele existe colunas definidas e os dados para seguir o modelo.

Além disso usei como filtro de pesquisa a gem 'ransack', na qual a intenção é em construir os filtros e buscar via sql, mas seria desncessário já que temos uma ferramenta ótima e performática.

Alem disso optei por consumir as Apis com a gem httparty.

Fiquei em dúvida se deveria ser full-back ou se deveria tambem fazer uma interface do app, mas como imagino que seja algo que iria receber uma lista de títulos, acredito que o projeto realizado atende a demanda.

Abaixo existe uma coleção do postman na qual as rotas de acessos estão bem definidas e com os parâmetros esperados. Além disso existe uma opção de upload de arquivo csv via postman.

https://www.getpostman.com/collections/b6370b81cb64ca18a2b9