## [3.0.0] - 11 January 2023

* Remove eventbus functionality
* Pin apn_state to version 3

## [2.0.4] - 7 February 2022

* Update apn_state dependency

## [2.0.3] - 15 Oct 2021

* Don't use isolate to transform json (performance loss somehow)
* Don't add default HttpFormatter

## [2.0.2] - 22 July 2021

* Fix bug in displaying FormData

## [2.0.1] - 29 April 2021

* Fix Accept-Language flag on iOS

## [2.0.0] - 10 April 2021

* Drop pre-release flag
* Update to dio 4

## [2.0.0-nullsafety-9] - 25 March 2021

* Add ErrorMessage toString

## [2.0.0-nullsafety-8] - 25 March 2021

* Upgrade dio to latest version

## [2.0.0-nullsafety-7] - 18 March 2021

* Fix bug in dio_formatter regarding json decoding

## [2.0.0-nullsafety-6] - 18 March 2021

* Fix bug in dio_formatter regarding extra fields

## [2.0.0-nullsafety-5] - 18 March 2021

* Replaced dio formatter with own implementation, dropped dependency

## [2.0.0-nullsafety-4] - 18 March 2021

* Merge v1.0.9 functionality into v2.0

## [2.0.0-nullsafety-3] - 18 March 2021

* Update apn_state to new mayor version

## [2.0.0-nullsafety-2] - 18 March 2021

* Flutter 2.0 as min target
* Updated dependencies
* Removed outdated/deprecated depencendies

## [1.0.9] - 5 February 2021

* Add refresh override for api_base_state

## [2.0.0-nullsafety-1] - 22 November 2020

* Changed package to be compatible with the new nullsafety features of dart 2.12

## [1.0.8] - 14 November 2020

* Add better support for web

## [1.0.7] - 6 November 2020

* Add extra loggin options

## [1.0.6] - 26 October 2020

* Add a default value for pagination info when pagination is disabled

## [1.0.5] - 22 October 2020

* Add the ability to disable pagination

## [1.0.4] - 8 September 2020

* Make dio extendable after initial init

## [1.0.2] - 8 September 2020

* Remove default contentType header

## [1.0.1] - 6 September 2020

* Remove print function calls
* Update to version 1.0 to indicate "Is used in production"
* Add ability to update error messages after creation

## [0.5.0] - 5 September 2020

* Utility to refresh http client on the fly (usefull e.g. when changing a header for all http calls)
* Base dio setup
* Utility state class that works with `apn_state`
* First release
