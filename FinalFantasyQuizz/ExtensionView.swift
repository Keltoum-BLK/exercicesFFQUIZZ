//
//  ExtensionView.swift
//  Apple ou pas
//
//  Created by Matthieu PASSEREL on 28/07/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit

extension UIView {
    
    func setLayer() {
        backgroundColor = .white
        layer.cornerRadius = 10
        //layer.borderColor = UIColor.red.cgColor
        //layer.borderWidth = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 3
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}
