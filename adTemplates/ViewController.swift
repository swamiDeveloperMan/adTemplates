//
//  ViewController.swift
//  adTemplates
//
//  Created by swami developer man on 11/03/20.
//  Copyright © 2020 swami developer man. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var scoreLabel: UIButton!
    
    var interstitial: GADInterstitial!
    var rewardedAd: GADRewardedAd!
    
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        bannerView.load(GADRequest())
    }
    
    fileprivate func initialSetup(){
        scoreLabel.setTitle("\(score)", for: .normal)
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        bannerView.rootViewController = self
        interstitial = createAndLoadInterstitial()
        rewardedAd = createAndLoadRewardedAd()
    }

    @IBAction func viewInterstitial(_ sender: UIButton) {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("interstitial ad not ready")
        }
    }
    @IBAction func viewVideo(_ sender: UIButton) {
        if rewardedAd.isReady {
            rewardedAd.present(fromRootViewController: self, delegate: self)
        } else {
            print("video ad not ready")
        }
    }
}

extension ViewController: GADInterstitialDelegate{
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
    func createAndLoadInterstitial() -> GADInterstitial {
      var interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
      interstitial.delegate = self
      interstitial.load(GADRequest())
      return interstitial
    }
}


extension ViewController: GADRewardedAdDelegate{
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        score += Int(truncating: reward.amount)
        scoreLabel.setTitle("\(score)", for: .normal)
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.rewardedAd = createAndLoadRewardedAd()
    }
    
    func createAndLoadRewardedAd() -> GADRewardedAd{
      rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
      rewardedAd?.load(GADRequest()) { error in
        if let error = error {
          print("Loading failed: \(error)")
        } else {
          print("Loading Succeeded")
        }
      }
      return rewardedAd
    }
}
