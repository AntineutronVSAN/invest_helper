# invests_helper

## Предназначение

Имеется множество кошельков, криптовалютных бирж, гугл-документов т т.д. и т.п.
Приложение предназначено структурировать всю информацию и получить доступ ко всем данным
из одного места.
Базой данных для приложения является Google sheet таблицы, бизнес логика находится в приложении

## Планируемые для подключения сервисы

- [x] Google sheets
- [x] Binance
- [ ] ByBit
- [ ] KuCoin
- [ ] Coinmarketcap
- [ ] Blockchain.com
- [ ] Подключение в сети основных блокчейнов (под вопросом, но было бы неплохо)
- [ ] Криптовалютные кошельки (вручную через google-таблицы)
- [ ] Телеграмм бот


## Интеграция с google sheets

* Создать google таблицу и получить её ID
* Добавить её в класс ``IHSecureData``, в дальнейшем все ключи - через МП

Для корректной работы, гугл-таблица должна содержать следущий список страниц:

* Orders
* Buys
* Buys_status
* fiat_actives_pairs

### Google sheets "Orders"
### Google sheets "Buys"
### Google sheets "Buys_status"
### Google sheets "fiat_actives_pairs"

## Интеграция с binance

* Получить API ключи
* Добавить их в класс ``IHSecureData``, в дальнейшем все ключи - через МП


## Не будь велосипедистом

* Не используется ванильный Bloc, [используется унифицированный блок с глобальными событиями и состояниями](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/base)
* Для сложных виджетов с бизнес-логикой использутся [кастомные stateless и statefull виджеты](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/base)
    
* Все модели данных: ответы сервисов, внутренние модели и т.п. хранятся [тут](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/data/models)
* Репозитории объединены с провайдерами и находятся [тут](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/data/repositories)
* Все обёртки над репозиториями [тут](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/data/services). Используются для кеширования: в ОП и в Hive БД
* Различные сервисы находят [тут](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/services). К примеру: вебсокеты, firebase и т.п.
* Вся вёрстка с блоками разбиты по частям. Навигация исключительно через ``TabNavigator`` [тут](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/parts)

* [Тексты и стили приложения](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/theme)
* [Цветовая гамма приложения](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/theme)

* [App bar](https://github.com/AntineutronVSAN/invest_helper/blob/main/lib/ui_package/app_bar/app_bar.dart)
* [Button](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Info section](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Clickable card](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Dialog](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Form](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Input fields](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Loading widget](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Number picker](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Paginated list](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Refresh indicator](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Select item widget](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Selectable widget](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [App slider](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)
* [Unfocus](https://github.com/AntineutronVSAN/invest_helper/tree/main/lib/ui_package)


### Build models

flutter pub run build_runner build --delete-conflicting-outputs