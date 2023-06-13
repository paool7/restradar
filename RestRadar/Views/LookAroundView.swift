//
//  LookAroundView.swift
//  LookAroundMapKit
//
//  Created by Alkın Çakıralar on 21.11.2022.
//

import SwiftUI
import MapKit

struct LookAroundView: UIViewControllerRepresentable {
    typealias UIViewControllerType = MKLookAroundViewController
    
    @Binding var scene: MKLookAroundScene?

    func makeUIViewController(context: Context) -> MKLookAroundViewController {
        let mkView = MKLookAroundViewController()
        mkView.scene = scene

        return mkView
    }
    
    func updateUIViewController(_ uiViewController: MKLookAroundViewController, context: Context) {
        uiViewController.scene = scene
    }
}
