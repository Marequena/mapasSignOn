//
//  PDFCreator.swift
//  SolutionApp
//
//  Created by Miguel Angel Requena on 26-01-23.
//

import Foundation
import PDFKit

class PDFCreator {
    
    func createPDF() -> Data {
      // 1
      let pdfMetaData = [
        kCGPDFContextCreator: "Miguel Requena",
        kCGPDFContextAuthor: "Miguel Requena"
      ]
      let format = UIGraphicsPDFRendererFormat()
      format.documentInfo = pdfMetaData as [String: Any]

      // 2
      let pageWidth = 8.5 * 72.0
      let pageHeight = 11 * 72.0
      let pageRect = CGRect(x: 0, y: 0, width: pageWidth, height: pageHeight)

      // 3
      let renderer = UIGraphicsPDFRenderer(bounds: pageRect, format: format)
      // 4
      let data = renderer.pdfData { (context) in
        // 5
        context.beginPage()
        // 6
        let attributes = [
          NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)
        ]
          let clsLoc : [locationsMap]? = UserDefaults.standard.retrieveCodable(for: "locationsMap")
          var txt :String = ""
          clsLoc?.forEach({ loc in
              txt += "Lat :\(loc.lat) Lan :\(loc.lan) \n"
          })
          txt.draw(at: CGPoint(x: 0, y: 0), withAttributes: attributes)
          
          
      }

      return data
    }
    
}
