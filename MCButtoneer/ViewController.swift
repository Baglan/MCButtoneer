//
//  ViewController.swift
//  MCButtoneer
//
//  Created by Baglan on 7/15/16.
//  Copyright © 2016 Mobile Creators. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var sampleButtonView: RoundRectView!
    @IBOutlet weak var countLabel: UILabel!
    
    var clickCount = 0 {
        didSet {
            countLabel.text = "\(clickCount)"
        }
    }
    
    let sampleButtoneer = MCButtoneer()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sampleButtoneer.view = sampleButtonView
        
        sampleButtoneer.action = { [unowned self] buttoneer in
            self.clickCount += 1
        }
        
        sampleButtoneer.onPress = { buttoneer in
            if let view = buttoneer.view as? RoundRectView {
                view.isFilled = true
            }
        }
        
        sampleButtoneer.onRelease = { buttoneer in
            if let view = buttoneer.view as? RoundRectView {
                view.isFilled = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

