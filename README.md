# StringStylizer
Type strict builder class for NSAttributedString. 

## What's this?
StringStylizer makes NSAttributedString more intuitive by wrapping up with method chains and operators.
Building NSAttributedString is so difficult that it requires us to remember attribute names and types. When you write code with StringStylizer, There is no need to remember them :smiley:

NSAttributedString has the following format.
```swift
let attr: [String: AnyObject] = [
    NSForegroundColorAttributeName: UIColor.whiteColor(),
    NSFontAttributeName: UIFont(name: "HelveticaNeue", size: 14)
]
let str = NSAttributedString(string: "some text", attributes: attr)
```

StringStylizer enable developers to write code in a linear manner.
If you wanna convert String to NSAttributedString which has some colors, sizes and fonts, you can write it as follows.
```swift
let str = "some text".stylize().color(.whiteColor()).size(14).font(.HelveticaNeue).attr
```

## Feature
- [x] Type strict format
- [x] Assign ranges and attributes in a linear manner
- [x] More readable than NSAttributedString

## Requirements
- iOS 8.0+
- Swift 2.0+

## Installation

## Example
 
 ```swift
 let label = UILabel(frame: CGRectMake(0, 0, 100, 50))
 
 // build NSAttributedString.
 let greed = "Hi, ".stylize().color(0x2200ee).size(12).font(.HelveticaNeue).attr
 
 // build NSAttributedString with ranges.
 let msg = "something happened ".stylize()
                .range(0..<9)        .color(0x009911).size(12).font(.HelveticaNeue)
                .range(10..<UInt.max).color(0xaa22cc).size(14).font(.HelveticaNeue_Bold).attr
 
 // build NSAttributedString objects and join them.
 let name = "to ".stylize().color(0x23abfc).size(12).font(.HelveticaNeue).attr +
            "you".stylize().color(0x123456).size(14).font(.HelveticaNeue_Italic).underline(.StyleDouble).attr
 
 label.attributedText = greed + msg + name
 ```

This sample generates the following styled label.
 
<img width="350" src="https://cloud.githubusercontent.com/assets/18266814/14254571/49882d08-facb-11e5-9e3d-c37cbef6a003.png">

Of course, you can wrap up method chains in an abstructed method. 
```swift
extension StringStylizer {
  func strong() -> NSAttributedString {
    return self.stylize()
            .color(0x123456)
            .size(14)
            .font(.HelveticaNeue_Italic)
            .underline(.StyleDouble)
            .attr
  }
}

label.attributedText = "you".stylize().strong()
```

## Usage
#### 1. Convert String to StringStylizer object which is "Styling" state
```swift
let firstStep = "yay!".stylize() // => StringStylizer<Styling>
```
#### 2. Call methods to select range. then StringStylizer become "NarrowDown" state
```swift
let secondStep = "yay!".stylize().range(0..<firstStep.count) // => StringStylizer<NarrowDown>
```
#### 3. Call methods to set attributes. then StringStylizer become "Styling" state
```swift
let thirdStep = "yay!".stylize().range(0..<firstStep.count).size(14) // => StringStylizer<Styling>
```
#### 4. Convert NSAttributedString object.
```swift
let fourthStep = "yay!".stylize().range(0..<firstStep.count).size(14).attr // => NSAttributedString
```
#### 5. Join other NSAttributedString objects.
```swift
let one     = "yay!".stylize().range(0..<firstStep.count).size(14).att
let another = " yay!".stylize().color(0xffffff).attr
let fifthStep = one + another // => NSAttributedString
```

That's it!

## Architecture
StringStylizer is based on **"Builder Pattern"**. In addition, it has some states managed by **"Phantom Type"**.

<img width="800" src="https://cloud.githubusercontent.com/assets/18266814/14271674/4d5bb9de-fb36-11e5-819c-cb2061d49be4.png">

Because of them, developers can write code in the liner manner and call proper methods depending on the situation.

## License

