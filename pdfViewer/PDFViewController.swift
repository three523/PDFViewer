//
//  PDFViewController.swift
//  pdfViewer
//
//  Created by apple on 2022/02/14.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    let backBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Back", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.sizeToFit()
        return btn
    }()
    
    var pdfURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        backBtn.center = view.center
        backBtn.addTarget(self, action: #selector(backVC), for: .touchUpInside)
        let pdfView = PDFView(frame: view.bounds)

        view.addSubview(pdfView)
        view.addSubview(backBtn)
        
        guard let pdfURL = pdfURL else {
            return
        }
        
        pdfView.document = PDFDocument(url: pdfURL)

        
    }
    
    func setURL(at url: URL) {
        pdfURL = url
    }
    
    @objc
    func backVC() {
        self.dismiss(animated: true, completion: nil)
    }

}
