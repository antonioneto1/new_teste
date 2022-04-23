Este é um importador e validador de titulos.
Neste back-end estou incluindo uma opcao extra do que foi pedido, estou incluindo uma opcao de importacao de titulos via
arqvio csv. no projeto existe um modelo chamado "modelo_importacao_titulos.csv". nele existe já as colunas definidas e um dado para seguir o modelo. 

Alem disso usei como filtro de pesquisa a gem 'ransack'. eu tinha pensando em construir os filtros e buscar via sql, mas seria desncessario já que temos uma ferramenta otima e performatica.

Alem disso optei por consumir as Apis com a gem httparty.

ficou na duvida se deveria ser full-back ou deveria tambem fazer uma interface do app, mas como imagino que seja algo que iria receber uma lista de titulos, acredito que seja a forma correta que eu fiz. 

Abaixo tem essa colecao do postman em que eu ja deixei as rotas de acessos bem definidas e os parametros esperados.
alem disso existe uma opcao de upload de arquivo csv via postman. 

https://www.getpostman.com/collections/b6370b81cb64ca18a2b9