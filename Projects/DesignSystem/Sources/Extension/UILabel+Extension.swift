//
//  UILabel+Extension.swift
//  DesignSystem
//
//  Created by Yujin Kim on 2023-12-19.
//

import UIKit

extension UILabel {
    public func setLineHeight(_ lineHeight: CGFloat, text: String? = nil, font: UIFont) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            
            if lineHeight > font.lineHeight {
                style.lineSpacing = lineHeight - font.lineHeight
            }
            
            let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: style,
                                                             .font: font]
            self.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    public func setLineHeight(_ lineHeight: CGFloat, text: String? = nil, font: UIFont, hasUnderline: Bool = false) {
        if let text = text {
            let style = NSMutableParagraphStyle()
            let underline = NSUnderlineStyle.single.rawValue
            
            if lineHeight > font.lineHeight {
                style.lineSpacing = lineHeight - font.lineHeight
            }
            
            var attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: style,
                                                             .font: font, .underlineStyle: hasUnderline ? underline : .zero]
            
            self.attributedText = NSAttributedString(string: text, attributes: attributes)
        }
    }
    
    public func asColor(targetString: String, color: UIColor?) {
        let fullText = text ?? ""
        let range = (fullText as NSString).range(of: targetString)
        let attributedString = NSMutableAttributedString(string: fullText)
        attributedString.addAttribute(.foregroundColor, value: color as Any, range: range)
        attributedText = attributedString
    }
    
    public func setFontForText(_ targetText: String, withFont font: UIFont) {
         guard let labelText = text, let range = labelText.range(of: targetText) else {
             return
         }
         
         let nsRange = NSRange(range, in: labelText)
         
         let attributedString = NSMutableAttributedString(string: labelText)
         attributedString.addAttribute(.font, value: font, range: nsRange)
         
         attributedText = attributedString
     }
    
    public func setFontAndColorForText(_ targetText: String, withFont font: UIFont, textColor: UIColor) {
        guard let labelText = text, let range = labelText.range(of: targetText) else {
            return
        }
        
        let nsRange = NSRange(range, in: labelText)
        
        let attributedString = NSMutableAttributedString(string: labelText)
        attributedString.addAttribute(.font, value: font, range: nsRange)
        attributedString.addAttribute(.foregroundColor, value: textColor, range: nsRange)
        
        attributedText = attributedString
    }
}
