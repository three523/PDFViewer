//
//  DocumentPickerViewController.swift
//  pdfViewer
//
//  Created by apple on 2022/02/15.
//

import UIKit

protocol PickerViewDelegate {
    func dismissPickerViewController(url: URL)
}

class DocumentPickerViewController: UIDocumentPickerViewController, UIDocumentPickerDelegate {
    
    var pdfDelegate: PickerViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self

    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls)
        pdfDelegate?.dismissPickerViewController(url: urls.first!)
        dismiss(animated: true)
    }

}
