//
//  ViewController.swift
//  pdfViewer
//
//  Created by apple on 2022/02/14.
//

import UIKit
import WeScan_English
import PDFKit
import UniformTypeIdentifiers



class ViewController: UIViewController, ImageScannerControllerDelegate, UIDocumentPickerDelegate, PickerViewDelegate {
    func dismissPickerViewController(url: URL) {
        self.pdfURL = url
        presentPDFViewer()
    }
    
    var document: UIDocument?
    var pdfURL: URL?
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        createPDF(Image: results.croppedScan.image)
        print(results.croppedScan.image)
        dismiss(animated: true, completion: nil)
    }
    
    func pdfSetting(url: URL) {
        self.pdfURL = url
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        print(error)
    }
    
    
    let scanVCBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("Scan", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.sizeToFit()
        return btn
    }()
    
    let nextControllerBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("PDFViewer", for: .normal)
        btn.setTitleColor(.blue, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.sizeToFit()
        return btn
    }()
    
    let activityVCBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("fileApp", for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.gray, for: .highlighted)
        btn.sizeToFit()
        return btn
    }()
    
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        scanVCBtn.translatesAutoresizingMaskIntoConstraints = true
        scanVCBtn.center = view.center
        scanVCBtn.addTarget(self, action: #selector(scanBtnClick), for: .touchUpInside)
        
        nextControllerBtn.center = view.center
        nextControllerBtn.center.y = scanVCBtn.center.y + scanVCBtn.bounds.height
        nextControllerBtn.addTarget(self, action: #selector(presentPDFViewer), for: .touchUpInside)
        
        activityVCBtn.center = view.center
        activityVCBtn.center.y = nextControllerBtn.center.y + nextControllerBtn.bounds.height
        activityVCBtn.addTarget(self, action: #selector(presentActivityVC), for: .touchUpInside)
        
        
        view.addSubview(scanVCBtn)
        view.addSubview(nextControllerBtn)
        view.addSubview(activityVCBtn)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        document?.open(completionHandler: { (success) in
            print(success)
        })
    }
        
    @objc
    func scanBtnClick() {
        let scanVC = ImageScannerController()
        scanVC.imageScannerDelegate = self
        present(scanVC, animated: true, completion: nil)
        
    }
    
    @objc
    func presentPDFViewer() {
        let vc = PDFViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.pdfURL = pdfURL
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    func presentActivityVC() {
        
        let vc = DocumentPickerViewController(forOpeningContentTypes: [UTType.pdf], asCopy: false)
        vc.delegate = self
        vc.pdfDelegate = self
        vc.modalPresentationStyle = .formSheet
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func createPDF(Image: UIImage) {
        let defalutName = UUID().uuidString
        
        let pdfDocument = PDFDocument()
        let pdfPage = PDFPage(image: Image)!
        pdfDocument.insert(pdfPage, at: 0)
        
        let data = pdfDocument.dataRepresentation()
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let docURL = documentDirectory.appendingPathComponent(defalutName)
        let path = docURL.path
        
        do {
            try data?.write(to: docURL)
        } catch (let error) {
            print(error.localizedDescription)
        }
    }
}

