//
//  DocumentPickerViewController.swift
//  pdfViewer
//
//  Created by apple on 2022/02/15.
//

import UIKit

class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

    }
    
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
        guard let sourceURL = documentURLs.first else { return }
        
        let vc = PDFViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.setURL(at: sourceURL)
        
        present(vc, animated: true, completion: nil)
        
    }

}
