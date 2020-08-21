//
//  RecommandController.swift
//  Relay22
//
//  Created by A on 2020/08/21.
//  Copyright © 2020 gicho. All rights reserved.
//

import UIKit
import Alamofire

class RecommandController: UIViewController {
    
    let User = Friend(id: Friend.makeID(), name: "부스트캠퍼", school: "멤버쉽", age: 20, interest: "넷플릭스", gender: "남자")
    
    var friends = [Friend](){
        didSet {
            DispatchQueue.main.async {
                self.friendTableView.reloadData()
            }
        }
    }
    
    
    let hobbies = ["축구", "야구", "농구", "수영", "개발", "프로그래밍", "자바스크립트", "코틀린", "스위프트", "리그오브레전드", "발로란트", "인벤", "재즈", "락", "댄스", "카트라이더", "잠자기", "여행", "해외여행", "국내여행", "음악", "넷플릭스", "왓챠", "레인보우식스", "파이썬", "SW", "개발자", "웨이브", "네이버웹툰"]
    
    let schools = ["부스트", "캠프", "커넥트", "네이버", "챌린지", "멤버쉽"]
    
    
    func makeFriends() {
        for _ in 0..<1000 {
            friends.append(Friend(id: Friend.makeID(), name: Friend.makeName(), school: schools.randomElement()!, age: Int.random(in: 20...30), interest: hobbies.randomElement()!, gender: "남자"))
        }
    }
    
    func findSameInterest(myInterest: String, completion: @escaping ([String]) -> Void ) {
        
        var returnArray = [String]()
        
        guard let url = URL(string: "http://api.adams.ai/datamixiApi/deeptopicrankTrend") else{
         print("error")
         return
        }
        AF.request(url,
                   method: .get,
                   parameters: ["target": "news", "keyword":myInterest, "max":"50", "key":"8042670081526743573"])
            .validate()
            .responseJSON(completionHandler: { res in
                switch res.result{
                case .success(let data):
                    let dic = data as? [String:Any]
                    let retn = dic?["return_object"] as? [String:Any]
                    let trends = retn?["trends"] as? [[String:Any]]
                    
                    for trend in trends! {
                        let nodes = trend["nodes"] as? [[String:Any]]
                        for node in nodes! {
                            returnArray.append(node["name"]! as! String)
                        }
                    }
                    completion(returnArray)
                    print(returnArray)
                case .failure(let err):
                    print("Fail")
                }
            })
        
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeFriends()
        //findSameSchool()
        findSameInterest(myInterest: User.interest) { (interests) in
            self.friends = self.friends.filter {
                $0.school == self.User.school && interests.contains($0.interest)
            }
        }
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var friendTableView: UITableView!
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}


extension RecommandController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as? CustomCellTableViewCell else { return UITableViewCell() }
        cell.nameLabel.text = friends[indexPath.row].name
        cell.informationLabel.text = friends[indexPath.row].school + "고 " + friends[indexPath.row].interest
        return cell
    }
    
    
}

