//
//  MaVue.swift
//  FinalFantasyQuizz
//
//  Created by Kel_Jellysh on 21/04/2021.
//

import UIKit

class MaVue: UIView {
        
        var masque = UIView()
        var imageView: UIImageView?
        var reponse = Reponse.peutEtre
        var logo: Logo? {
            didSet {
                guard let l = logo else { return }
                reponse = .peutEtre
                setMasqueCouleur(reponse)
                if imageView == nil {
                    imageView = UIImageView(frame: bounds)
                    imageView?.contentMode = .scaleAspectFit
                    addSubview(imageView ?? UIImageView())
                    sendSubviewToBack(imageView ?? UIImageView())
                }
                imageView?.image = l.image
            }
        }

        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            setup()
        }
        
        func ajoutMasque() {
            masque = UIView(frame: bounds)
            masque.backgroundColor = .clear
            masque.layer.cornerRadius = 10
            masque.alpha = 0.25
            addSubview(masque)
        }
        
        func setup() {
            setLayer()
            isUserInteractionEnabled = true
            ajoutMasque()
        }
        
        func setMasqueCouleur(_ reponse: Reponse) {
            switch reponse {
            case .oui: masque.backgroundColor = .green
            case .non: masque.backgroundColor = .red
            case .peutEtre: masque.backgroundColor = .clear
            }
            self.reponse = reponse
        }
    }


