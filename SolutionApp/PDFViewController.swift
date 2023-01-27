//
//  PDFViewController.swift
//  SolutionApp
//
//  Created by Miguel Angel Requena on 26-01-23.
//


import UIKit

import PDFKit

class PDFViewController: UIViewController {

    @IBOutlet var pdfView: UIView!
    public var documentData: Data?

    @IBAction func sharePdf(_ sender: Any) {
        let pdfCreator = PDFCreator()
        let pdfData = pdfCreator.createPDF()
        let vc = UIActivityViewController(
          activityItems: [pdfData],
          applicationActivities: []
        )
        present(vc, animated: true, completion: nil)
    }
    
  override func viewDidLoad() {
    super.viewDidLoad()
      // Add PDFView to view controller.
         let pdfView = PDFView(frame: self.view.bounds)
         pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
         self.view.addSubview(pdfView)
         
         // Fit content in PDFView.
         pdfView.autoScales = true
         
      if let data = documentData {
        pdfView.document = PDFDocument(data: data)
        pdfView.autoScales = true
          
      }
  }
}

class clsLocations{
    var loc : [locationsMap] = []
}

struct locationsMap : Codable {
    var lat : String?
    var lan : String?
}



