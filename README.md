# UBottomSheet

[![Language](https://img.shields.io/badge/language-swift%205-brightgreen)](https://cocoapods.org/pods/UBottomSheet)
[![Version](https://img.shields.io/cocoapods/v/UBottomSheet.svg?style=flat)](https://cocoapods.org/pods/UBottomSheet)
[![License](https://img.shields.io/cocoapods/l/UBottomSheet.svg?style=flat)](https://cocoapods.org/pods/UBottomSheet)
[![Platform](https://img.shields.io/cocoapods/p/UBottomSheet.svg?style=flat)](https://cocoapods.org/pods/UBottomSheet)

## Demo

![Demo](https://github.com/OfTheWolf/UBottomSheet/blob/master/anim.gif)


## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

Create a view controller that inherits BottomSheetController. Configure the following parameters according to your needs.

```swift
class MapsDemoBottomSheetController: BottomSheetController{
    
    //MARK: BottomSheetController configurations
//    override var topYPercentage: CGFloat
    
//    override var bottomYPercentage: CGFloat
    
//    override var middleYPercentage: CGFloat
    
//    override var bottomInset: CGFloat
    
//    override var topInset: CGFloat

//    //scrollView is automatically detected but if you have nested scrolls it may be detected wrong. 
//    //override this ONLY if your scroll doesn't drive the sheet.
//    override var scrollView: UIScrollView?{
//        return replace_with_your_scrollview
//    }
    
//    //Override this to apply custom animations
//    override func animate(animations: @escaping () -> Void, completion: ((Bool) -> Void)? = nil) {
//        UIView.animate(withDuration: 0.3, animations: animations)
//    }
}
```

Attach to the parent view controller

```swift
let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapsDemoBottomSheetController") as! MapsDemoBottomSheetController
      
        //Add bottom sheet to the current viewcontroller
        vc.attach(to: self)

//      //Remove sheet from the current viewcontroller
//      vc.detach()

```


## Requirements
ios9.0+, Xcode10+

## Installation

UBottomSheet is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'UBottomSheet'
```

## See Also

[TwitterProfile](https://github.com/OfTheWolf/TwitterProfile) Nested scroll view behaviour of Twitter Profile screen.

## Author

uğur, uguboz@gmail.com

## License

UBottomSheet is available under the MIT license. See the LICENSE file for more info.
