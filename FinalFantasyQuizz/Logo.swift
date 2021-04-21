//
//  Logo.swift
//  Apple ou pas
//
//  Created by Matthieu PASSEREL on 28/07/2018.
//  Copyright © 2018 Matthieu PASSEREL. All rights reserved.
//

import UIKit

class Logo {
    
    private var _ffImages: [UIImage?] = [ UIImage(named: "aerith"), UIImage(named: "cloud"), UIImage(named: "linoa"), UIImage(named: "seifer"), UIImage(named: "squall"), UIImage(named: "tidus"), UIImage(named: "tiffa"), UIImage(named: "Vivi")]
    private var _autreImages: [UIImage?] = [UIImage(named: "FE1"), UIImage(named: "FE2"), UIImage(named: "kratos"), UIImage(named: "lady"), UIImage(named: "link"), UIImage(named: "nariko"), UIImage(named: "trish"), UIImage(named: "zelda")]
    
    private var _image: UIImage?
    private var _isFF: Bool
    
    var image: UIImage? {
        return _image
    }
    
    var isApple: Bool {
        return _isFF
    }
    
    init(bool: Bool) {
        _isFF = bool
        let random = Int.random(in: 0...6)
        _image = _isFF ? _ffImages[random] : _autreImages[random]
    }
    
}
