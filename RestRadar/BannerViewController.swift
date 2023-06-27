//
//  BannerViewController.swift
//  RestRadar
//
//  Created by Paul Dippold on 6/27/23.
//

import SwiftUI
import GoogleMobileAds
import UIKit

private struct BannerVC: UIViewControllerRepresentable {
    var bannerID: String
    var width: CGFloat
    private let bannerView = GADBannerView(adSize: GADAdSizeFluid)

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        #if DEBUG
        bannerView.adUnitID = "ca-app-pub-5261168092302860/5745936375"
        #else
        bannerView.adUnitID = bannerID
        #endif
        bannerView.rootViewController = viewController
        viewController.view.addSubview(bannerView)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        bannerView.load(GADRequest())
    }
}

struct Banner: View {
    var bannerID: String
    var width: CGFloat

    var size: CGSize {
        return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width).size
    }

    var body: some View {
        BannerVC(bannerID: bannerID, width: width)
            .frame(width: size.width, height: size.height)
    }
}

struct Banner_Previews: PreviewProvider {
    static var previews: some View {
        Banner(bannerID: "ca-app-pub-7487306403748963/2790855579", width: UIScreen.main.bounds.width)
    }
}
