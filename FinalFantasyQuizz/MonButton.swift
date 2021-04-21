//
//  MonButton.swift
//  Apple ou pas
//
//  Created by Matthieu PASSEREL on 28/07/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit

class MonButton: UIButton {
    
    func setup(string: String) {
       setLayer()
        setTitle(string, for: UIControl.State.normal)
        setTitleColor(UIColor.darkGray, for: .normal)
    }

}
