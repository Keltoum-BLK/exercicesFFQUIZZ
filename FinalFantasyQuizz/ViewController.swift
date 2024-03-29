//
//  ViewController.swift
//  FinalFantasyQuizz
//
//  Created by Kel_Jellysh on 21/04/2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var container: UIView!
    
    
    var carte: MaVue?
    var rect = CGRect()
    var boutonOui = MonButton()
    var boutonNon = MonButton()
    var playBouton: MonButton?
    var scoreLabel = MonLabel()
    var timer = Timer()
    
    var audioPlayer: AVAudioPlayer?
    var soundPlayer: AVAudioPlayer?
    
    var isGame = false
    var tempsRestant = 0
    var score = 0
    
    let ouiSon = Son(nom: "oui", ext: "wav")
    let nonSon = Son(nom: "non", ext: "mp3")
    let fanfare = Son(nom: "fanfare", ext: "mp3")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        gradient()
        container.frame = view.bounds
        rect = CGRect( x: container.frame.midX - 100, y: container.frame.midY - 100, width: 200, height: 200)
        setupButtons()
        setupLabel()
        setupGame()
    }
    
    func setupLabel() {
        scoreLabel = MonLabel(frame: CGRect(x: 20, y: 10, width: container.frame.width - 40, height: 60))
        container.addSubview(scoreLabel)
    }
    
    func setupButtons() {
        let tiers = container.frame.width / 3
        let quart = container.frame.width / 4
        let hauteur: CGFloat = 50
        let y = container.frame.height - (hauteur * 2)
        let taille = CGSize(width: tiers, height: hauteur)
        boutonNon.frame.size = taille
        boutonNon.center = CGPoint(x: quart, y: y)
        boutonNon.setup(string: "NON")
        boutonNon.addTarget(self, action: #selector(non), for: .touchUpInside)
        boutonNon.isHidden = true
        container.addSubview(boutonNon)
        
        boutonOui.frame.size = taille
        boutonOui.center = CGPoint(x: quart * 3, y: y)
        boutonOui.setup(string: "OUI")
        boutonOui.addTarget(self, action: #selector(oui), for: .touchUpInside)
        boutonOui.isHidden = true
        container.addSubview(boutonOui)
    }
    
    func gradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.black.cgColor, UIColor.gray.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 1)
        gradient.frame = view.bounds
        view.layer.addSublayer(gradient)
        view.bringSubviewToFront(container)
    }
    
    func setupGame() {
        if isGame {
            if playBouton != nil {
                playBouton?.removeFromSuperview()
                playBouton = nil
            }
            
            carte = MaVue(frame: rect)
            container.addSubview(carte ?? UIView())
            boutonOui.isHidden = false
            boutonNon.isHidden = false
            let boolRandom = Int.random(in: 0...1) % 2 == 0
            carte?.logo = Logo(bool: boolRandom)
            
            let titac = Son(nom: "hurry", ext: "mp3")
            if let url = Bundle.main.url(forResource: titac.nom, withExtension: titac.ext) {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: url)
                    audioPlayer?.numberOfLoops = 20
                    audioPlayer?.prepareToPlay()
                    audioPlayer?.play()
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            
        } else {
            if carte != nil {
                carte?.removeFromSuperview()
                carte = nil
            }
            score = 0
            playBouton = MonButton(frame: CGRect(x: 40, y: container.frame.height / 2 - 30, width: container.frame.width - 80, height: 60))
            playBouton?.setup(string: "Commencer à jouer")
            playBouton?.addTarget(self, action: #selector(play), for: .touchUpInside)
            container.addSubview(playBouton ?? UIButton())
            boutonNon.isHidden = true
            boutonOui.isHidden = true
        }
        
    }
    
    func alerte() {
        var best = UserDefaults.standard.integer(forKey: "score")
        if score > best {
            best = score
            UserDefaults.standard.set(best, forKey: "score")
            UserDefaults.standard.synchronize()
        }
        
        let alert = UIAlertController(title: "C'est fini", message: "Votre score est de : \(score)\nLe meilleur score est de : \(best)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default) { (action) in
            self.play()
        }
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == carte?.masque {
            let xPosition = touch.location(in: container).x
            let distance = container.frame.midX - xPosition
            let angle = -distance / 360
            
            carte?.center.x = xPosition
            carte?.transform = CGAffineTransform(rotationAngle: angle)
            
            if distance >= 75 {
                carte?.setMasqueCouleur(.non)
            } else if distance <= -75 {
                carte?.setMasqueCouleur(.oui)
            } else {
                carte?.setMasqueCouleur(.peutEtre)
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == carte?.masque {
            UIView.animate(withDuration: 0.3, animations: {
                self.carte?.transform = CGAffineTransform.identity
                self.carte?.frame = self.rect
            }) { (success) in
                if self.carte?.reponse != .peutEtre {
                    if self.carte?.reponse == .oui {
                        self.oui()
                    }
                    if self.carte?.reponse == .non {
                        self.non()
                    }
                }
            }
            
        }
    }
    
    func rotation() {
        guard carte != nil else { return }
        carte?.logo = Logo(bool: Int.random(in: 0...1) % 2 == 0)
        UIView.transition(with: carte!, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    func jouerSon(_ son: Son) {
        guard let url = Bundle.main.url(forResource: son.nom, withExtension: son.ext) else { return }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url)
            soundPlayer?.prepareToPlay()
            soundPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    @objc func non() {
        if self.carte?.logo?.isApple == false {
            self.score += 1
            jouerSon(ouiSon)
        } else {
            jouerSon(nonSon)
        }
        scoreLabel.updateText(tempsRestant, score)
        rotation()
    }
    
    @objc func oui() {
        if self.carte?.logo?.isApple == true {
            self.score += 1
            jouerSon(ouiSon)
        } else {
            jouerSon(nonSon)
        }
        scoreLabel.updateText(tempsRestant, score)
        rotation()
    }
    
    @objc func play() {
        isGame = !isGame
        setupGame()
        //Timer
        if isGame {
            tempsRestant = 30
            timerFunc()
        }
    }
    
    func timerFunc() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [self] (timer) in
            self.tempsRestant -= 1
            self.scoreLabel.updateText(self.tempsRestant, self.score)
            if self.tempsRestant == 0 {
                self.timer.invalidate()
                self.scoreLabel.updateText(nil, nil)
                self.audioPlayer?.stop()
                self.alerte()
                self.jouerSon(self.fanfare)
            }
        })
    }


}



