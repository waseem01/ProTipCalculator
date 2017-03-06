//
//  PercentageViewController.swift
//  ProTipCalculator
//
//  Created by Waseem Mohd on 3/6/17.
//  Copyright © 2017 Waseem Mohd. All rights reserved.
//

import UIKit

protocol PercentageControllerDelegate {
    func selectedPercentage(percent: String)
    func popOverDismissed()
}

class PercentageViewController: UIViewController {
    @IBOutlet weak var tenPercent: UILabel!
    @IBOutlet weak var twentyPercent: UILabel!
    @IBOutlet weak var thirtyPercent: UILabel!
    var delegate : PercentageControllerDelegate?
    var percentage : Float!

    override func viewDidLoad() {
        super.viewDidLoad()

        tenPercent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tipUpdated)))
        twentyPercent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tipUpdated)))
        thirtyPercent.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tipUpdated)))
    }

    func tipUpdated(sender: UITapGestureRecognizer) {
        delegate?.selectedPercentage(percent: (sender.view?.restorationIdentifier!)!)
        self.dismiss(animated: true, completion: nil)
    }

    override func viewDidDisappear(_ animated: Bool) {
        delegate?.popOverDismissed()
    }
}
