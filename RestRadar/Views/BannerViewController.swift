//
//  BannerViewController.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/27/23.
//

import GoogleMobileAds
import SwiftUI
import UIKit

struct BannerVC: UIViewControllerRepresentable  {
    var size: CGSize
    var adUnitId: String

    init(size: CGSize, adUnitId: String) {
        self.size = size
        self.adUnitId = adUnitId
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADAdSizeFromCGSize(size))
        let viewController = UIViewController()
        view.adUnitID = self.adUnitId
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        
        let gadRequest = GADRequest()
        DispatchQueue.main.async {
            gadRequest.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        }
        view.load(gadRequest)
        
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
