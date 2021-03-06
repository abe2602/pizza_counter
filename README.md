# Pizza Counter!
Esse repositório abriga o código de um contador de pedaços de pizza para ser utilizado entre amigos ou em rodízios,
o projeto foi desenvolvido inteiramente em Flutter, utilizando a arquitetura Bloc, seguindo os conceitos de Clean Architecture.
App pode ser encontrado aqui: https://play.google.com/store/apps/details?id=br.com.mobyle.pizza_counter , espero que gostem!

## Tecnologias utilizadas
- [Dio](https://pub.dev/packages/dio)
- [Provider](https://pub.dev/packages/provider)
- [Hive](https://pub.dev/packages/hive)
- [Fluro](https://pub.dev/packages/fluro)
- [RxDart](https://pub.dev/packages/rxdart)

## Como funciona?
Há duas abas, a primeira delas abriga os jogadores, já a segunda um pódio e gráfico.

![alt text](https://i.imgur.com/3lkXbDi.png)

Quando não há nenhum "comedor" (usuário do app), um empty state será exibido. Nele, é possível adicionar um novo usuário a partir do nome. Nomes iguais não são suportados, logo um aviso irá aparecer.

![alt text](https://i.imgur.com/QyUnV45.png)

Quando há jogadores, é possível visualiza-los a partir de quadradinhos. Nos quadrados, podemos adicionar ou remover pedaços de pizza, e na AppBar, é possível adicionar outros usuários.

![alt text](https://i.imgur.com/XLYaqES.png)

Quando não há nenhum "comedor" (usuário do app), um empty state será exibido.

![alt text](https://i.imgur.com/DTLrscs.png)

Quando há jogadores, é possível visualizar o "pódio" dos maiores comilões! Além de um gráfico mostrando a partição dos pedaços comidos pelo grupo todo.

## Autor
Bruno Abe e Edson Toma

## Imagens
As imagens utilizadas são livres de direitos autorais e, conforme licença, precisar ter suas fontes devidamente creditadas, sendo elas:
https://www.freevector.com/pizza-icons# (Splash e ícone) e https://www.manypixels.co (EmptyStates)

## License
[MIT](https://choosealicense.com/licenses/mit/)
