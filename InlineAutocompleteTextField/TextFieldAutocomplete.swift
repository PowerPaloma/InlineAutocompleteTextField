//
//  TextFieldAutocomplete.swift
//  InlineAutocompleteTextField
//
//  Created by Paloma Bispo on 06/10/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit

class TextFieldAutocomplete: UITextField {

    var possibilities: [String] =  []
    private var characterCount = 0
    private var timer = Timer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func showAutocomplete(withPossibilities possibilities: [String], Range range: NSRange, andReplacementString string: String){
        self.possibilities = possibilities
        guard let text = self.text as NSString? else { return }
        var subString = (text).replacingCharacters(in: range, with: string)
        subString = format(subString: subString)
        if subString.count == 0 {
            resetValues()
        } else {
            searchAutocompleteEntries(withSubstring: subString)
        }
    }
    
    private func format(subString: String) -> String {
        let formatted = String(subString.dropLast(characterCount)).lowercased().capitalized
        return formatted
    }
    func resetValues() {
        characterCount = 0
        self.text = ""
    }
    
    private func searchAutocompleteEntries(withSubstring substring: String) {
        let userQuery = substring
        let suggestions = getSuggestions(basedOnText: substring)
        
        if suggestions.count > 0 {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                let autocompleteResult = self.formatAutocompleteResult(substring: substring, possibleMatches: suggestions)
                self.formatInline(suggestion: autocompleteResult, withUserQuery: userQuery)
                self.moveIndicatorToEndOf(userQuery: userQuery)
            })
        } else {
            timer = .scheduledTimer(withTimeInterval: 0.01, repeats: false, block: { (timer) in
                self.text = substring
            })
            characterCount = 0
        }
    }
    
    private func getSuggestions(basedOnText text: String) -> [String]{
        var matches = possibilities.map { (string) -> (NSString: NSString, String: String) in
            return (string as NSString, string)
        }
        matches = matches.filter { (possi) -> Bool in
            let range = possi.NSString.range(of: text)
            return range.location == 0
        }
        return matches.map({ (tupla) -> String in
            return tupla.String
        })
    }
    
    private func formatInline(suggestion: String, withUserQuery userQuery : String) {
        let colouredString: NSMutableAttributedString = NSMutableAttributedString(string: userQuery + suggestion)
        colouredString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.green, range: NSRange(location: userQuery.count,length:suggestion.count))
        self.attributedText = colouredString
    }
    
    private func moveIndicatorToEndOf(userQuery : String) {
        if let newPosition = self.position(from: self.beginningOfDocument, offset: userQuery.count) {
            self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
        }
        let selectedRange: UITextRange? = self.selectedTextRange
        self.offset(from: self.beginningOfDocument, to: (selectedRange?.start)!)
    }
    
    private func formatAutocompleteResult(substring: String, possibleMatches: [String]) -> String {
        var autocompleteResult = possibleMatches[0]
        autocompleteResult.removeSubrange(autocompleteResult.startIndex..<autocompleteResult.index(autocompleteResult.startIndex, offsetBy: substring.count))
        characterCount = autocompleteResult.count
        return autocompleteResult
    }
    
}

