//
//  ViewController.swift
//  ExperimentProduct
//
//  Created by hubin on 2021/9/17.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //15
        print("1-5相加结果：\(sum(input: 1,2,3,4,5))")
        
//        typealias PetLike = KittenLike & DogLike
//        SoundChecker.checkPetTalking(pet: PetLike)
        
        //对于那些不需要完全运行，可能提前退出的情况，使用 lazy 来进行性能优化效果会非常有效
        let data = 1...3
        let result = data.lazy.map {
            (i: Int) -> Int in
            print("正在处理 \(i)")
            return i * 2
        }
        
        print("准备访问结果")
        for i in result {
            print("操作后结果为 \(i)")
        }
        
        print("操作完毕")
        
        //虽然说使用 enumerateObjectsUsingBlock: 非常方便，但是其实从性能上来说这个方法并不理想
        var resultx = 0
        for (idx, num) in [1,2,3,4,5].enumerated() {
            resultx += num
            if idx == 2 {
                break
            }
        }
        print("从遍历中中断的数字之和为 \(resultx)")
        
        //循环遍历
        for suit in Suit.allValues {
            for rank in Rank.allValues {
                print("\(suit.rawValue)\(rank.description)")
            }
        }
        
    }

    //累加
    func sum(input: Int...) -> Int {
        return input.reduce(0, +)
    }
    
    func myMethodLocked(anObj: AnyObject!) {
        synchronized(lock: anObj) {
            // 在括号内 anObj 不会被其他线程改变
        }
    }
    
    func synchronized(lock: AnyObject, closure: () -> ()) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
}

enum Suit: String {
    case Spades = "黑桃"
    case Hearts = "红桃"
    case Clubs = "梅花"
    case Diamonds = "方块"
}

enum Rank: Int {
    case Ace = 1
    case Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten
    case Jack, Queen, King
    var description: String {
        switch self {
        case .Ace:
            return "A"
        case .Jack:
            return "J"
        case .Queen:
            return "Q"
        case .King:
            return "K"
        default:
            return String(self.rawValue)
        }
    }
}

protocol EnumeratableEnumType {
    static var allValues: [Self] {get}
}

extension Suit: EnumeratableEnumType {
    static var allValues: [Suit] {
        return [.Spades, .Hearts, .Clubs, .Diamonds]
    }
}

extension Rank: EnumeratableEnumType {
    static var allValues: [Rank] {
        return [.Ace, .Two, .Three,
            .Four, .Five, .Six,
            .Seven, .Eight, .Nine,
            .Ten, .Jack, .Queen, .King]
    }
}

//protocol KittenLike {
//    func meow() -> String
//}
//
//protocol DogLike {
//    func bark() -> String
//}
//
//struct SoundChecker {
//    static func checkPetTalking(pet: KittenLike & DogLike) {
//        //...
//        print("Do you love me?")
//    }
//}

