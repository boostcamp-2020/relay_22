//
//  GreyToColorViewController.swift
//  Relay22
//
//  Created by kante on 2020/08/14.
//  Copyright © 2020 gicho. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct HTTPBinResponse: Decodable { let url: String }

class GreyToColorViewController: UIViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet weak var photoButton: UIButton!
    @IBOutlet weak var extractFaceButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    var data: Data?
    var imageData: Data?
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
        data = nil
        imageData = nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let url = URL(string: "https://i.ibb.co/3ffFbLs/blackJK.png")
//        data = try? Data(contentsOf: url!)
//        imageView.image = UIImage(data: data!)
//        imageData = imageView.image?.jpegData(compressionQuality: 0.50)
    }
    
    @IBAction func setOriginalImage(){
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary
                imagePicker.allowsEditing = false
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
        
    //    func extractImage(){
    //        let image = imageView.getFaceImage()
    //        imageView.image = image
    //    }
        
        @IBAction func setFaceImageOnly(){
            let image = imageView.getFaceImage()
            imageView.image = image
        }
        
        
        // Image Picker Delegate
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
                imageView.image = image
            }
            dismiss(animated: true, completion: nil)
        }
    
    @IBAction func onClick(_ sender: Any) {
        let headers: HTTPHeaders = [
            "api-key": "186e88d3-bb5c-4682-8d8b-476e247d1511",
            "Accept": "application/json"
        ]
        
        let imageDataWillColor = imageView.image?.jpegData(compressionQuality: 0.50)
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(imageDataWillColor!, withName: "image", fileName: "greyImage.jpeg", mimeType: "image/jpeg")
        }, to: "https://api.deepai.org/api/colorizer", method: .post, headers: headers)
            .responseJSON { response in
                var json: JSON
                switch response.result{
                case .success(let value):
                    json = JSON(value)
                default: return
                }
                
                let toColorUrlJson = json["output_url"].string
                let toColorUrl = URL(string: toColorUrlJson!)
                let toColorData = try? Data(contentsOf: toColorUrl!)
                self.imageView.image = UIImage(data: toColorData!)
                
        }
    }
}


extension UIView {
    func getFaceImage() -> UIImage? {
        let faceDetectorOptions: [String: AnyObject] = [CIDetectorAccuracy: CIDetectorAccuracyHigh as AnyObject]
        let faceDetector: CIDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: faceDetectorOptions)!
        let viewScreenShotImage = generateScreenShot(scaleTo: 1.0)
        
        if viewScreenShotImage.cgImage != nil {
            let sourceImage = CIImage(cgImage: viewScreenShotImage.cgImage!)
            let features = faceDetector.features(in: sourceImage)
            if features.count > 0 {
                var faceBounds = CGRect.zero
                var faceImage: UIImage?
                for feature in features as! [CIFaceFeature] {
                    faceBounds = feature.bounds
                    let faceCroped: CIImage = sourceImage.cropped(to: faceBounds)
                    let cgImage: CGImage = {
                        let context = CIContext(options: nil)
                        return context.createCGImage(faceCroped, from: faceCroped.extent)!
                    }()
                    faceImage = UIImage(cgImage: cgImage)
                }
                return faceImage
            } else {
                return nil
            }
        } else {
            return nil
        }
    }
    func generateScreenShot(scaleTo: CGFloat = 3.0) -> UIImage {
        let rect = self.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()
        self.layer.render(in: context!)
        let screenShotImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        let aspectRatio = screenShotImage.size.width / screenShotImage.size.height
        return screenShotImage

    }
}
extension UIImageView {
  func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
    contentMode = mode
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else { return }
      DispatchQueue.main.async() { [weak self] in
        self?.image = image
      }
    }.resume()
  }
  func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
    guard let url = URL(string: link) else { return }
    downloaded(from: url, contentMode: mode)
  }
}
