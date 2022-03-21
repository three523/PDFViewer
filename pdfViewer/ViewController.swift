//
//  ViewController.swift
//  pdfViewer
//
//  Created by apple on 2022/02/14.
//

import UIKit

class ViewController: UIViewController {
    
    let downloadLink: UIButton = {
        let btn = UIButton()
        btn.setTitle("download PDF", for: .normal)
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
    
    var pdfURL: URL?
    var task: URLSessionDownloadTask? = nil
    let fileManager = FileManager.default

    override func viewDidLoad() {
        super.viewDidLoad()
        
        downloadLink.translatesAutoresizingMaskIntoConstraints = true
        downloadLink.center = view.center
        downloadLink.addTarget(self, action: #selector(downloadPdf), for: .touchUpInside)
        
        nextControllerBtn.center = view.center
        nextControllerBtn.center.y = downloadLink.center.y + downloadLink.bounds.height
        nextControllerBtn.addTarget(self, action: #selector(presentPDFViewer), for: .touchUpInside)
        
        activityVCBtn.center = view.center
        activityVCBtn.center.y = nextControllerBtn.center.y + nextControllerBtn.bounds.height
        activityVCBtn.addTarget(self, action: #selector(presentActivityVC), for: .touchUpInside)
        
        
        view.addSubview(downloadLink)
        view.addSubview(nextControllerBtn)
        view.addSubview(activityVCBtn)
    }
    
    @objc
    func downloadPdf() {
        
        guard let url = URL(string: "https://www.tutorialspoint.com/swift/swift_tutorial.pdf") else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: nil)

        task = urlSession.downloadTask(with: url)
        task?.resume()
        
    }
    
    @objc
    func presentPDFViewer() {
        let vc = PDFViewController()
        guard let pdfURL = pdfURL else {
            return
        }
        vc.setURL(at: pdfURL)

        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc
    func presentActivityVC() {
        
        let vc = DocumentBrowserViewController(forOpeningFilesWithContentTypes: ["public.composite-content"])

        vc.allowsDocumentCreation = true
        vc.allowsPickingMultipleItems = false
        self.present(vc, animated: true, completion: nil)
        
    }
    
    private func fileDownLoad(url: URL) {
        
        let destinationURL = localFilePath(path: url.path)
                
        do {
            try fileManager.moveItem(at: url, to: destinationURL)
        } catch {
            print("Could not copy file to disk: \(error.localizedDescription)")
        }
        
        pdfURL = destinationURL
    }
    
    private func localFilePath(path: String) -> URL {
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("DH",
        isDirectory: true)
        if !fileManager.fileExists(atPath: documentsURL.path) {
            
            do {
                try fileManager.createDirectory(atPath: documentsURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                NSLog("Coludn't create document directory")
            }
        }
        
        guard let fileName = task?.originalRequest?.url?.lastPathComponent else {
            return documentsURL.appendingPathComponent((path as NSString).lastPathComponent)
        }
                
        let destinationURL = documentsURL.appendingPathComponent(fileName)
        
        return destinationURL
    }
}

extension ViewController: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("downloadLocation:", location)
        
        fileDownLoad(url: location)
    }
}

