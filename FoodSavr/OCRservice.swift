//
//  OCRservice.swift
//  FoodSavr
//
//  Created by Xiaowen Feng on 4/13/17.
//  Copyright © 2017 FoodSavr. All rights reserved.
//

import Foundation
import TesseractOCR

//// an extension for NSmutableData to add string
//extension NSMutableData {
//    func appendString(_ string: String) {
//        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: false)
//        append(data!)
//    }
//}

class OCRservice {
    
    
    
    
    
    
    
//        let apiKey = "7b693b0d9488957"
//        let language = "eng"
//    
//    
//    func callOCRSpace(imageData: Data, fileName: String) {
//        print("i am in call ocr")
//        let requestUrl = NSURL(string: "https://api.ocr.space/parse/image")
//        let request  = NSMutableURLRequest(url: requestUrl! as URL)
//        request.httpMethod = "POST"
//        
//        let boundary = "Boundary-\(UUID().uuidString)"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//        let session = URLSession.shared
//        
//        let data = self.createBodyWithBoundary(boundary: boundary, parameters: self.createParam(), data: imageData, filename: fileName)
//        
//        request.httpBody = data
//        
//        // Start data session
//        let task = session.dataTask(with: request as URLRequest,
//                                    completionHandler: {(data, response, error) in
//            if error != nil {
//                print("error: \(String(describing: error))")
//                return
//            }
//            
//            
//            let result = try? JSONSerialization.jsonObject(with: data!, options: []) as! [String : Any]
//            
//            print("result: \(result!)")
//                                        
//        })
//        task.resume()
//        
//    }
//    
//    
//    func createBodyWithBoundary(boundary: String, parameters: [String : AnyObject], data: Data, filename: String) -> Data {
//        
//        let body = NSMutableData()
//        let boundaryPrefix = "--\(boundary)\r\n"
//        
//        for (key, value) in parameters {
//            body.appendString(boundaryPrefix)
//            
//            body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            body.appendString("\(value)\r\n")
//        }
//        
//        body.appendString(boundaryPrefix)
//        body.appendString("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\(filename)\"\r\n")
//        body.appendString("Content-Type: image/jpeg\r\n\r\n")
//        body.append(data)
//        body.appendString("--".appending(boundary.appending("--")))
//        
//        print(String(data: body as Data, encoding: String.Encoding.utf8))
//        return body as Data
//    }
//    
////    func createMultipart(image: UIImage) -> MultipartFormData {
////        
////        let params = self.createParam()
////        return {MultipartFormData in
////            for (key, value) in params {
////                let value : Data = value.data(using: String.Encoding.utf8.rawValue)!
////                MultipartFormData.append(value, withName: key)
////            }
////            let imageData : Data = self.createImageData(img: image) as Data
////            MultipartFormData.append(imageData, withName: "image", fileName: "metroClearImg.jpg", mimeType: "image/jpg")
////        }
////        
////    }
//    
//    func createParam() -> [String : AnyObject]{
//        
//        var dict = [String : AnyObject]()
//        dict["language"] = self.language as AnyObject?
//        dict["apikey"] = self.apiKey as AnyObject?
//        dict["isoverlayrequired"] = "false" as AnyObject?
//        return dict
//        
//    }
    
    

}

