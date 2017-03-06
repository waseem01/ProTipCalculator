//
//  ViewController.swift
//  ProTipCalculator
//
//  Created by Waseem Mohd on 3/6/17.
//  Copyright © 2017 Waseem Mohd. All rights reserved.
//

import UIKit

class TipViewController: UIViewController, UIPopoverPresentationControllerDelegate, PercentageControllerDelegate {
    @IBOutlet weak var billText: UITextField!
    @IBOutlet weak var tipPercentage: UILabel!
    @IBOutlet weak var finalTotal: UILabel!
    @IBOutlet weak var billView: UIView!
    let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    let userDefaults = UserDefaults.standard

    deinit {
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillTerminate, object: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Pro Tip Calculator"
        var frame = view.frame
        frame.size.height -= 65 //compensate for navBar height

        blurView.frame = self.view.bounds
        self.billView.alpha = 0
        billText.becomeFirstResponder()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showTipSettings))
        tipPercentage.addGestureRecognizer(tapGesture)

        navigationItem.rightBarButtonItem =  UIBarButtonItem(title: "+",
                                                             style: .plain,
                                                             target: self,
                                                             action: #selector(showTipSettings))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
        navigationItem.hidesBackButton = true
        view.backgroundColor = UIColor.white

        NotificationCenter.default.addObserver(self, selector: #selector(loadDefaults), name: .UIApplicationDidBecomeActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storeDefaults), name: .UIApplicationWillResignActive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(storeDefaults), name: .UIApplicationWillTerminate, object: nil)
    }

    func animateView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: [], animations: {
            Float(self.finalTotal.text!) != nil ? (self.billView.alpha=1) : (self.billView.alpha=0)
        }, completion: nil)
    }

    func loadDefaults() {
        if let bill_date = userDefaults.object(forKey: "bill_date") as? Date {
            let time_interval = NSDate().timeIntervalSince(bill_date)
            if Int(time_interval) < 600 {
                billText.text = userDefaults.string(forKey: "bill_text")
                tipPercentage.text = userDefaults.string(forKey: "tip_text")
                finalTotal.text = userDefaults.string(forKey: "total_text")
            }
        }
    }

    func storeDefaults() {
        userDefaults.set(NSDate(), forKey: "bill_date")
        userDefaults.set(billText.text, forKey: "bill_text")
        userDefaults.set(tipPercentage.text, forKey: "tip_text")
        userDefaults.set(finalTotal.text, forKey: "total_text")
        userDefaults.synchronize()
    }

    @IBAction func totalChanged(_ sender: Any) {
        updateValues()
        storeDefaults()
        animateView()
    }

    //MARK: - Private Methods
    func updateValues() {
        guard let total = billText.text, total != "" else {
            finalTotal.text = "$0.00"
            return
        }
        let floatTotal = Float(total)!
        let percentage = String(tipPercentage.text!.characters.dropLast())
        let tipPercent = Float(percentage)! / 100
        let tip = (floatTotal * tipPercent)
        finalTotal.text = String(floatTotal + tip)
    }

    func showTipSettings() {
        let percentageViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "settings") as!PercentageViewController
        percentageViewController.delegate = self;
        let navigationController = UINavigationController(rootViewController: percentageViewController)
        navigationController.modalPresentationStyle = UIModalPresentationStyle.popover

        let popover = navigationController.popoverPresentationController
        popover?.permittedArrowDirections = UIPopoverArrowDirection(rawValue:0)
        percentageViewController.preferredContentSize = CGSize(width: 220, height: 60)
        popover?.delegate = self
        popover?.sourceView = self.view
        popover?.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)


        self.view.addSubview(blurView)
        billText.resignFirstResponder()
        self.present(navigationController, animated: true, completion: nil)
    }

    //MARK: - PercentageControllerDelegate
    func selectedPercentage(percent: String) {
        tipPercentage.text = percent
        updateValues()
        storeDefaults()
    }

    func popOverDismissed() {
        blurView.removeFromSuperview()
        billText.becomeFirstResponder()
    }

    //MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

