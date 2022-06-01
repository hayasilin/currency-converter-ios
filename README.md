# Currency

[![License: MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/hayasilin/Currency/blob/main/LICENSE)
[![Platform](https://img.shields.io/cocoapods/p/PagingTableView.svg?style=flat)](https://github.com/hayasilin/Currency/tree/main/Currency/)
[![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![iOS 15](https://img.shields.io/badge/iOS-12-orange.svg?style=flat)](https://developer.apple.com/ios/)

- An iOS app project of using currencylayer API for currency converter which implements:
  - Select a currency from a list of currencies provided by currencylayer.
  - Enter the desired amount for the selected currency.
  - Shown a list showing the desired amount in the selected currency convered into amounts in each currency provided by currencylayer.
  - Currency data must be persisted locally to permit the application to be used offline after data has be fetched
  - In order to limit bandwidth usage, the required data can be refreshed from the API no more frequently than once every 1 hour.

- Real time currency provided by [currencylayer](https://currencylayer.com/) API.
  - [API Documentation](https://currencylayer.com/documentation)

## Screenshots
<img width=350 src="https://github.com/hayasilin/Currency/blob/main/resources/portrait_1.png"><img width = 350 src="https://github.com/hayasilin/Currency/blob/main/resources/portrait_2.png">

## Architecture

- Using **Clean Architecture**.
- Using Core Date to persist data locally.

## Unit Testing & UI Testing 

- The code coverage is up to **75.4%**.
- Demostrate using dependency injection for unit testing.
- Demostrate Core Data unit testing.

## Code Coverage Screenshot

<img src="https://github.com/hayasilin/Currency/blob/main/resources/code_coverage.png">

## Reference

- [Clean Coder Blog](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Clean Architecture Amazon](https://www.amazon.com/Clean-Architecture-Craftsmans-Software-Structure/dp/0134494164)

<img src="https://github.com/hayasilin/Currency/blob/main/resources/clean_architecture.png">
