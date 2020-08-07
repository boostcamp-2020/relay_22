//
//  ViewController.swift
//  Relay22
//
//  Created by 조기현 on 2020/08/07.
//  Copyright © 2020 gicho. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var textView: UITextView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
        configureTextView()
	}
	
    func configureTextView() {
        textView.delegate = self
        textView.text = "자기소개를 입력하세요."
        textView.textColor = UIColor.lightGray
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 8
    }
    
    @IBAction func send() {
		let msg = Message(text: textView.text ?? "")
		let json = try! JSONEncoder().encode(msg)
		
		NetworkManager.request("http://localhost:5000/data",method: .POST, body: json ) { (data, _, _) in
            guard let data = data else { return }
			let nouns = try! JSONDecoder().decode(Array<String>.self, from: data)
			print(nouns)
        }
    }
}

extension ViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
	
	struct Message: Codable {
		var text: String
	}
}
