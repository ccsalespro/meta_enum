# Changelog

## 2.1.0 (May 31, 2018)

* Add element_class optional argument to MetaEnum::Type.new to customize element class.

## 2.0.1 (February 8, 2018)

* Fix MetaEnum::Type#inspect
* Documentation improvements

## 2.0.0 (January 27, 2018)

* Support non-integer values.

This entailed some breaking changes:

* MetaEnum::Value renamed to MetaEnum::Element
* MetaEnum::MissingValue renamed to MetaEnum::MissingElement
* MetaEnum::Value#number renamed to value
* MetaEnum::Type#values renamed to elements
* MetaEnum::Type#values_by_name renamed to elements_by_name
* MetaEnum::Type#values_by_number renamed to elements_by_value
