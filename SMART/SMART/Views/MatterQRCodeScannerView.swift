//
//  MatterQRCodeScannerView.swift
//  SMART
//
//  Created by Aryan Palit on 3/16/25.
//

import SwiftUI

struct MatterQRCodeScannerView: View {
    /// Closure to handle the scanned QR code string.
    var onCodeScanned: (String) -> Void
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            QRCodeScannerView { scannedCode in
                onCodeScanned(scannedCode)
                dismiss()
            }
            .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                Text("Align the QR code within the frame to scan")
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(10)
                    .padding(.bottom, 20)
            }
        }
    }
}


/// A UIViewControllerRepresentable wrapper for the QR code scanner.
struct QRCodeScannerView: UIViewControllerRepresentable {
    var onCodeScanned: (String) -> Void

    func makeUIViewController(context: Context) -> ScannerViewController {
        let scannerVC = ScannerViewController()
        scannerVC.onCodeScanned = onCodeScanned
        return scannerVC
    }
    
    func updateUIViewController(_ uiViewController: ScannerViewController, context: Context) { }
}
