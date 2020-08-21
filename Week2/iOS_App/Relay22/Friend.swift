//
//  Friend.swift
//  Relay22
//
//  Created by A on 2020/08/21.
//  Copyright © 2020 gicho. All rights reserved.
//

import Foundation
struct Friend {
    var id: String
    var name: String
    var school: String
    var age: Int
    var interest: String
    var gender: String
    
    static func makeID() -> String{
        let letters = "abcdefghijklmnopqrstuvwxyz0123456789"
        return String((0..<6).map{ _ in
            letters.randomElement()!
        })
    }
    static func makeName() -> String{
        let letters = "김이박최문신윤조오강권모성주다은송주상윤태양병휘명렬승진승언병기철웅"
        return String((0..<3).map{ _ in
            letters.randomElement()!
        })
    }
    
}
