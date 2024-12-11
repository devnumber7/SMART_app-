//
//  QRCodeScannerView.swift
//  SMART
//
//  Created by Anson Jiang on 12/7/24.
//

import SwiftUI
import UIKit

struct QRCodeScannerView: UIViewControllerRepresentable {
    
    typealias UIViewControllerType = QRCodeViewController
    func makeUIViewController(context: Context) -> QRCodeViewController {
        return QRCodeViewController()
    }
    
    func updateUIViewController(_ uiView: QRCodeViewController, context: Context) {
       
    }
}
