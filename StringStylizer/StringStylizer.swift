//
//  StringSerializer.swift
//  aaa
//
//  Created by Kazuhiro Hayashi on 4/3/16.
//  Copyright © 2016 Kazuhiro Hayashi. All rights reserved.
//

import UIKit


/**
 Type safely builder class for NSAttributedString. 
 
 It makes NSAttributedString more intitive by wrapping method chains and operators.
 
 #### Usage
 when you convert String to NSAttributedString which has some colors, sizes and fonts, you can write it in a linear manner.
 
 ```
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
 
 
 This sample code generates the following styled label.
 
 <img width="261" src="https://cloud.githubusercontent.com/assets/18266814/14254571/49882d08-facb-11e5-9e3d-c37cbef6a003.png">

 */
public class StringStylizer<T: StringStylizerStatus>: StringLiteralConvertible {
    public typealias ExtendedGraphemeClusterLiteralType = String
    public typealias UnicodeScalarLiteralType = String
    
    private var _attrString: NSAttributedString
    private var _attributes = [String: AnyObject]()
    private var _range: Range<UInt>
    
    // MARK:- Initializer
    
    init(string: String, range: Range<UInt>? = nil, attributes: [String: AnyObject] = [String: AnyObject]()) {
        let range = range ?? 0..<UInt(string.characters.count)
        
        _attrString = NSAttributedString(string: string)
        _attributes = attributes
        _range = range
    }
    
    init(attributedString: NSAttributedString, range: Range<UInt>, attributes: [String: AnyObject] = [String: AnyObject]()) {
        _attrString = attributedString
        _attributes = attributes
        _range = range
    }
    
    public required init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
        _attrString = NSMutableAttributedString(string: value)
        _range = 0..<UInt(_attrString.string.characters.count)
    }
    
    public required init(stringLiteral value: StringLiteralType) {
        _attrString = NSMutableAttributedString(string: value)
        _range = 0..<UInt(_attrString.string.characters.count)
    }
    
    public required init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
        _attrString = NSMutableAttributedString(string: value)
        _range = 0..<UInt(_attrString.string.characters.count)
    }
    
    // MARK:- Attributes
    // https://developer.apple.com/library/ios/documentation/Cocoa/Reference/Foundation/Classes/NSAttributedString_Class/index.html#//apple_ref/doc/c_ref/NSLinkAttributeName
    
    public func color(rgb: UInt, alpha: Double = 1.0) -> StringStylizer<Styling> {
        _attributes[NSForegroundColorAttributeName] = self.rgb(rgb, alpha: alpha)
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func color(color: UIColor) -> StringStylizer<Styling> {
        _attributes[NSForegroundColorAttributeName] = color
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func font(font: UIFont) -> StringStylizer<Styling> {
        _attributes[NSFontAttributeName] = font
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }

    public func font(name: String) -> StringStylizer<Styling> {
        let font: UIFont
        if let currentFont = _attributes[NSFontAttributeName] as? UIFont {
            font = UIFont(name: name, size: currentFont.pointSize) ?? UIFont()
        } else {
            font = UIFont(name: name, size: UIFont.systemFontSize()) ?? UIFont()
        }
        
        _attributes[NSFontAttributeName] = font
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func font(name: StringStylizerFontName) -> StringStylizer<Styling> {
        let font: UIFont
        if let currentFont = _attributes[NSFontAttributeName] as? UIFont {
            font = UIFont(name: name.rawValue, size: currentFont.pointSize) ?? UIFont()
        } else {
            font = UIFont(name: name.rawValue, size: UIFont.systemFontSize()) ?? UIFont()
        }
        
        _attributes[NSFontAttributeName] = font
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func size(size: Double) -> StringStylizer<Styling> {
        let font: UIFont
        if let currentFont = _attributes[NSFontAttributeName] as? UIFont {
            font = UIFont(name: currentFont.fontName, size: CGFloat(size)) ?? UIFont()
        } else {
            font = UIFont.systemFontOfSize(CGFloat(size))
        }
        
        _attributes[NSFontAttributeName] = font
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func background(rgb: UInt, alpha: Double = 1.0) -> StringStylizer<Styling> {
        _attributes[NSBackgroundColorAttributeName] = self.rgb(rgb, alpha: alpha)
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func karn(value: Double) -> StringStylizer<Styling> {
        _attributes[NSKernAttributeName] = value
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func underline(style: NSUnderlineStyle..., rgb: UInt? = nil, alpha: Double = 1) -> StringStylizer<Styling> {
        let _style: [NSUnderlineStyle] = style.isEmpty ? [.StyleSingle] : style
        
        let value = _style.reduce(0) { (sum, elem) -> Int in
            return sum | elem.rawValue
        }
        _attributes[NSUnderlineStyleAttributeName] = value
        _attributes[NSUnderlineColorAttributeName] = rgb.flatMap { self.rgb($0, alpha: alpha) }
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func stroke(rgb rgb: UInt, alpha: Double = 1.0,  width: Double = 1) -> StringStylizer<Styling>  {
        _attributes[NSStrokeWidthAttributeName] = width
        _attributes[NSStrokeColorAttributeName] = self.rgb(rgb, alpha: alpha)
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func stroke(color color: UIColor, alpha: Double = 1.0,  width: Double = 1) -> StringStylizer<Styling>  {
        _attributes[NSStrokeWidthAttributeName] = width
        _attributes[NSStrokeColorAttributeName] = color
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func strokeThrogh(style: NSUnderlineStyle..., rgb: UInt? = nil, alpha: Double = 1) -> StringStylizer<Styling>  {
        let _style: [NSUnderlineStyle] = style.isEmpty ? [.StyleSingle] : style
        
        let value = _style.reduce(0) { (sum, elem) -> Int in
            return sum | elem.rawValue
        }
        
        _attributes[NSStrikethroughStyleAttributeName] = value
        _attributes[NSStrikethroughColorAttributeName] = rgb.flatMap { self.rgb($0, alpha: alpha) }
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func shadow(value: NSShadow) -> StringStylizer<Styling> {
        _attributes[NSShadowAttributeName] = value
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func ligeture(value: Int) -> StringStylizer<Styling> {
        _attributes[NSLigatureAttributeName] = value
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func link(url: NSURL) -> StringStylizer<Styling> {
        _attributes[NSLinkAttributeName] = url
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func baselineOffset(value: Double) -> StringStylizer<Styling> {
        _attributes[NSBaselineOffsetAttributeName] = value
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    private func rgb(rgb: UInt, alpha: Double) -> UIColor {
        return UIColor(
            red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgb & 0x0000FF) / 255.0,
            alpha: CGFloat(alpha)
        )
    }
}

public extension StringStylizer {
    public func paragraph(style: NSParagraphStyle) -> StringStylizer<Styling> {
        _attributes[NSParagraphStyleAttributeName] = style
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func paragraphAlignment(alignment: NSTextAlignment) -> StringStylizer<Styling> {
        let style: NSMutableParagraphStyle
        if let currentStyle = _attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle {
            currentStyle.alignment = alignment
            style = currentStyle
        } else {
            style = NSMutableParagraphStyle()
            style.alignment = alignment
        }
        
        _attributes[NSParagraphStyleAttributeName] = style
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    /** 
     The indentation of the receiver.
     */
    public func paragraphIndent(firstLineHead firstLineHead: CGFloat? = nil, tail: CGFloat? = nil, otherHead: CGFloat? = nil) -> StringStylizer<Styling> {
        let style = getParagraphStyle()
        
        if let firstLineHead = firstLineHead {
            style.firstLineHeadIndent = firstLineHead
        }
        
        if let otherHead = otherHead {
           style.headIndent = otherHead
        }
        
        if let tail = tail {
            style.tailIndent = tail
        }
        
        _attributes[NSParagraphStyleAttributeName] = style
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func paragraphLineBreak(lineBreakMode: NSLineBreakMode) -> StringStylizer<Styling> {
        let style = getParagraphStyle()
        style.lineBreakMode = lineBreakMode
        
        _attributes[NSParagraphStyleAttributeName] = style
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func paragraphLineHeight(maximum maximum: CGFloat? = nil, minimum: CGFloat? = nil, multiple: CGFloat? = nil) -> StringStylizer<Styling> {
        let style = getParagraphStyle()
        
        if let maximum = maximum {
            style.maximumLineHeight = maximum
        }

        if let minimum = minimum {
            style.minimumLineHeight = minimum
        }
        
        if let multiple = multiple {
            style.lineHeightMultiple = multiple
        }
        
        _attributes[NSParagraphStyleAttributeName] = style
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func paragraphLineSpacing(after after: CGFloat? = nil, before: CGFloat? = nil) -> StringStylizer<Styling> {
        let style = getParagraphStyle()
        
        if let after = after {
            style.lineSpacing = after
        }
        
        if let before = before {
            style.paragraphSpacingBefore = before
        }
        
        _attributes[NSParagraphStyleAttributeName] = style
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    public func paragraphBaseWritingDirection(baseWritingDirection: NSWritingDirection) -> StringStylizer<Styling> {
        let style: NSMutableParagraphStyle
        if let currentStyle = _attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle {
            style = currentStyle
        } else {
            style = NSMutableParagraphStyle()
        }
        
        style.baseWritingDirection = baseWritingDirection

        _attributes[NSParagraphStyleAttributeName] = style
        let stylizer = StringStylizer<Styling>(attributedString: _attrString, range: _range, attributes: _attributes)
        return stylizer
    }
    
    private func getParagraphStyle() -> NSMutableParagraphStyle {
        if let currentStyle = _attributes[NSParagraphStyleAttributeName] as? NSMutableParagraphStyle {
            return currentStyle
        } else {
            return NSMutableParagraphStyle()
        }
    }
}

public extension StringStylizer where  T: Styling {
    public var attr: NSAttributedString {
        let range = Int(_range.startIndex)..<Int(_range.endIndex)
        let attrString = NSMutableAttributedString(attributedString: _attrString)
        attrString.setAttributes(_attributes, range: NSRange(range))
        return attrString
    }
    
    public func range(range: Range<UInt>? = nil) -> StringStylizer<NarrowDown> {
        let attrString = NSMutableAttributedString(attributedString: _attrString)
        attrString.setAttributes(_attributes, range: NSRange(Int(_range.startIndex)..<Int(_range.endIndex)))
        
        let range = range ?? 0..<UInt(attrString.length)
        let endIndex = min(range.endIndex, UInt(_attrString.length))
        let validRange = range.startIndex..<endIndex
        return StringStylizer<NarrowDown>(attributedString: attrString, range: validRange)
    }
}