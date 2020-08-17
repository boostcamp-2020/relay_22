# week3릴레이

# 기능 1 : 얼굴 사진 잘라내기

S002_강병민

S017 박성민

S028 신은지

S040 이은정

S055 조수정

- 매우 긴 코드 주의

    ```swift
    import UIKit
    import Vision
    class ViewController: UIViewController {
      @IBOutlet weak var lableView: UILabel!
      @IBOutlet weak var buttonView: UIButton!
      @IBOutlet weak var imageView: UIImageView!
      @IBOutlet weak var filterBook: UIImageView!

      override func viewDidLoad() {
        lableView.text = “강병민”
        super.viewDidLoad()
        imageView.downloaded(from: “https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=http%3A%2F%2Fcfile27.uf.tistory.com%2Fimage%2F99719E475A4DB112087077”)
        // Do any additional setup after loading the view.
      }
      @IBAction func pressedButton(_ sender: UIButton) {
        let rect = CGRect(x: 300.0, y: 300.0, width: 40.0, height: 40.0)
        imageView.image?.draw(in: rect)
      }
      @IBAction func pictureChangeButton(_ sender: UIButton) {
        if let inputImage = imageView.image {
          let ciImage = CIImage(cgImage: inputImage.cgImage!)
          let options = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
          let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: options)!
          let faces = faceDetector.features(in: ciImage)
          if let face = faces.first as? CIFaceFeature {
            print(“Found face at \(face.bounds)“)
            if face.hasLeftEyePosition {
              print(“Found left eye at \(face.leftEyePosition)“)
            }
            if face.hasRightEyePosition {
              print(“Found right eye at \(face.rightEyePosition)“)
            }
            if face.hasMouthPosition {
              print(“Found mouth at \(face.mouthPosition)“)
            }
            let cropped = ciImage.cropped(to: face.bounds)
            print(cropped)
    //        let croppedCGImage:CGImage = (inputImage.cgImage?.cropping(to: face.bounds))!
            let croppedImage = UIImage(ciImage: cropped)
            print(croppedImage)
            imageView.image = croppedImage
          }
          //      imageView.frame = CGRect(x: 0, y: 0, width: 500, height: 500) // The size of the background image
          //
          //      filterBook.frame = CGRect(x: 150, y: 300, width: 50, height: 50)
          //      imageView.addSubview(filterBook)
        }
      }
      func cropImage1(image: UIImage, rect: CGRect) -> UIImage {
        let cgImage = image.cgImage! // better to write “guard” in realm app
        let croppedCGImage = cgImage.cropping(to: rect)
        return UIImage(cgImage: croppedCGImage!)
      }
      private func drawOccurrencesOnImage(_ occurrences: [CGRect], _ image: UIImage) -> UIImage? {
        let imageSize = image.size
        let scale: CGFloat = 0.0
        UIGraphicsBeginImageContextWithOptions(imageSize, false, scale)
        image.draw(at: CGPoint.zero)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.addRects(occurrences)
        ctx?.setStrokeColor(UIColor.red.cgColor)
        ctx?.setLineWidth(2.0)
        ctx?.strokePath()
        let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return drawnImage
      }
    }
    extension UIImageView {
      func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
          guard
            let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
            let mimeType = response?.mimeType, mimeType.hasPrefix(“image”),
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
    ```

    ```swift
    import UIKit

    class ViewController: UIViewController {

        @IBOutlet weak var insertButton: UIButton!
        @IBOutlet weak var extractButton: UIButton!
        @IBOutlet weak var imageView: UIImageView!
        
        override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
        }
        
        @IBAction func insertImage(_ sender: UIButton) {
            imageView.downloaded(from: "https://img1.daumcdn.net/thumb/R1280x0/?scode=mtistory2&fname=http%3A%2F%2Fcfile27.uf.tistory.com%2Fimage%2F99719E475A4DB112087077")
        }
        
        @IBAction func extractImage(_ sender: UIButton) {
            print("pressed")
            let image = imageView.getFaceImage()
            imageView.image = image
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
                       //faceImage = UIImage(ciImage: faceCroped)
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
    //       let resizedScreenShotImage = screenShotImage.scaleImage(toSize: CGSize(width: self.bounds.size.height * aspectRatio * scaleTo, height: self.bounds.size.height * scaleTo))
    //       return resizedScreenShotImage!
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
    ```

[Open the native iOS Camera and Photo Library in Swift](http://xstutorials.com/open-native-ios-camera-and-photo-library-in-swift/)

[Face Detection Tutorial Using the Vision Framework for iOS](https://www.raywenderlich.com/1163620-face-detection-tutorial-using-the-vision-framework-for-ios)

[Image Processing in iOS Part 1: Raw Bitmap Modification](https://www.raywenderlich.com/2335-image-processing-in-ios-part-1-raw-bitmap-modification#toc-anchor-009)

# 기능 2 : 흑백 ↔ 컬러 전환

S047_장지석

S038_이상윤

S033 오동건

### Deepai API 사용법

[Image Colorization](https://deepai.org/machine-learning-model/colorizer)

1. 회원가입 후 api-key 발급
2. Alamofire를 이용한 post요청
3. post요청 예시
- URL

    [https://api.deepai.org/api/colorizer](https://api.deepai.org/api/colorizer)

- method

    'post'

- Header

     key : 'api-key', value : '발급된 api key'

- form data

    key : 'image', value : image data

4. 응답 예시

{
"id": "4ba07365-5b6e-4a24-8b8b-993f712344cd6",
"output_url": "https://output url "
}

![Untitled](https://user-images.githubusercontent.com/28242038/90348929-d012ad80-e072-11ea-8230-f5df2b9bcff0.png)

5. 사진 예시

흑백사진 → 컬러사진 변경됨 💯

<img src="https://user-images.githubusercontent.com/28242038/90348963-ed477c00-e072-11ea-88d8-5c0e2491cdc9.png" alt="Untitled 1" style="zoom:50%;" />
<img src="https://user-images.githubusercontent.com/28242038/90348968-f0db0300-e072-11ea-882c-8745614812ed.png" alt="Untitled 2" style="zoom:50%;" />

### Alamofire

- Alamofire 란
    - Apple의 Foundation networking 기반으로 인터페이스를 제공
    - iOS, macOS를 위한 스위프트 기반 HTTP 네트워킹 라이브러리
    - 일반적인 네트워킹 작업을 단순화

- 기능
    - Request / Response method
    - JSON Parameter
    - Response serialization
    - Authentication 등.. 많은 기능 내포

- 기초 사용법

[Swift, Alamofire가 무엇인지, 어떻게 사용하는지 알아봅니다](https://devmjun.github.io/archive/Alamofire)

### 시작

- PodFile 생성 - 가장 상위에

![Untitled 3](https://user-images.githubusercontent.com/28242038/90349007-1700a300-e073-11ea-998b-30df4111b4cf.png)

```swift
platform :ios, '13.6'
use_frameworks!
target 'Relay22' do
 pod 'Alamofire', '~> 5.2.2'
 pod 'SwiftyJSON'
end
```

![Untitled 4](https://user-images.githubusercontent.com/28242038/90349013-1ff17480-e073-11ea-8aa8-9d5ac033ba34.png)

```swift
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

class GreyToColorViewController: UIViewController {
    
    @IBOutlet weak var uploadImage: UIButton!
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
        
        let url = URL(string: "https://cdn.crowdpic.net/list-thumb/thumb_l_2D4CE204F6AC69BBD12954E21F972814.jpg")
        data = try? Data(contentsOf: url!)
        imageView.image = UIImage(data: data!)
        imageData = imageView.image?.jpegData(compressionQuality: 0.50)
    }
    
    
    @IBAction func onClick(_ sender: Any) {
        let headers: HTTPHeaders = [
            "api-key": "186e88d3-bb5c-4682-8d8b-476e247d1511",
            "Accept": "application/json"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.imageData!, withName: "image", fileName: "greyImage.jpeg", mimeType: "image/jpeg")
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
```

# 기능 3 : 어려보이게 하기

### 구성원

(이름 써주세요)

S060 최동규

S011 김신우

S024 설민주

---

# 회고 및 소감

익명1 : 사진을 자르는데 JK님 얼굴이 웃음벨이였습니다. 즐겁게 프로젝트를 진행할수 있어서 좋았습니다. 

익명2 : 어제 미션 하느라 잠을 제대로 못자서 너무 힘들었는데 다들 너무 재밌고 유쾌해서 많이 웃으면서 프로젝트 할 수 있었던 것 같아요 :) 최고 공신은 사진을 자르자마자 나온 JK님 얼굴ㅎㅎㅎ 아 오늘 너무 재밌네요

익명3 : 😆 이미지 AI라 어려웠는데, 즐거운 팀원들 덕분에 시간가는지 모르고 작업했네요!! 😆

익명4 : 팀으로 프로젝트를 하는데 이렇게 즐거울수 있구나...! 를 느꼈습니다ㅋㅋㅋㅋㅋㅋ

익명5 : 이번주 개인미션이 이해가 잘 되지않아 시간도 많이 걸리고 힘들었는데 오늘 릴레이에서 우리 조원분들과 재밌게 릴레이 미션을 할 수 있어서 힘들었지만 힘들지 않았습니다! 🤣

익명6: 지금 까지 해왔던 릴레이 프로젝트 중 가장 재밌었습니다 iOS 앱 기능도 만들어보고 팀원들과 재밌게 즐겼습니다!!!

익명7: 어렸을적 얼굴로 변환하기 위해서 열심히 노력했지만.... 환경 호환성 문제에서 실패했습니다. 너무 아쉽습니다 ㅠㅠ 다행히 다른 팀원분들께서 과제를 완료해주셨습니다.. 버스태워주셔서 감사합니다..

익명8 : 재밌었어요~~~~~~ 재밌는 릴레이 프로젝트 ~~~~~~

익명9: 집단 지성의 힘을 다시 한번 깨닫게 된 날이었어요~ 다 같이 으쌰으쌰하는 것이 개인에게 얼마나 큰 힘이 되고 도움이 되는지 깨달을 수 있었던 날이었네요~!

익명10 : 어려보이게 하기 너무 어렵네요.. 그래도 재밌었습니다! 

![image_(1)](https://user-images.githubusercontent.com/28242038/90349021-2253ce80-e073-11ea-85ac-f80a48bb8865.png)<img width="1440" alt="Screen_Shot_2020-08-14_at_18 38 20" src="https://user-images.githubusercontent.com/28242038/90349049-37306200-e073-11ea-8102-9c6ca3a7662f.png">

# Reference

- 사진 얼굴 인식
    - [https://life-shelter.tistory.com/132](https://life-shelter.tistory.com/132)
- 사진 자르기
    - [https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping](https://developer.apple.com/documentation/coregraphics/cgimage/1454683-cropping)
    - [https://developer.apple.com/documentation/coreimage/cidetector](https://developer.apple.com/documentation/coreimage/cidetector)
- 사진 흑백 → 컬러 전환
    - [https://deepai.org/machine-learning-model/colorizer](https://deepai.org/machine-learning-model/colorizer)