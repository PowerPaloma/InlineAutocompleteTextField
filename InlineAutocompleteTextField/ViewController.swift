//
//  ViewController.swift
//  InlineAutocompleteTextField
//
//  Created by Paloma Bispo on 04/10/19.
//  Copyright © 2019 Paloma Bispo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var autoCompletionPossibilities = ["Teste", "Book2", "hue3"]
    
    lazy var textField: TextFieldAutocomplete = {
        let textField = TextFieldAutocomplete()
        textField.borderStyle = .roundedRect
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(textField)
        textField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        self.textField.showAutocomplete(withPossibilities: autoCompletionPossibilities, Range: range, andReplacementString: string)
        return true
    }
}
