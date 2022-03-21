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
<<<<<<< HEAD
        vc.setURL(at: sourceURL)
=======
        vc.getURL(at: sourceURL)
>>>>>>> 08b8d36a6501214cb1d908c26971cde23aaf524d
        
        present(vc, animated: true, completion: nil)
        
    }

}
