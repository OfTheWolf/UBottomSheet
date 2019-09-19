# UBottomSheet

[![Version](https://img.shields.io/cocoapods/v/UBottomSheet.svg?style=flat)](https://cocoapods.org/pods/UBottomSheet)
[![License](https://img.shields.io/cocoapods/l/UBottomSheet.svg?style=flat)](https://cocoapods.org/pods/UBottomSheet)
[![Platform](https://img.shields.io/cocoapods/p/UBottomSheet.svg?style=flat)](https://cocoapods.org/pods/UBottomSheet)

## Demo

![Demo](https://github.com/OfTheWolf/UBottomSheet/blob/master/anim.gif)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Features
Supports any kind of view and scroll view. 

In case you use nested scrolls (i.e. vertical and horizontal in the sheet) it may detect wrong scroll. in this case override scrollView property and assing the correct scroll view as below.

```ruby
override var scrollView: UIScrollView?{
  return replace_with_your_scrollview
}
```

## Requirements
ios9.0+, Xcode10+

## Installation

UBottomSheet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UBottomSheet'
```

## Author

uğur, uguboz@gmail.com

## License

UBottomSheet is available under the MIT license. See the LICENSE file for more info.
