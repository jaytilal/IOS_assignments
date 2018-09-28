//: Playground - noun: a place where people can play

import UIKit
import Foundation

//Question 1
protocol LinkListProtocol{
    var count: Int {get set}
    var isEmpty: Bool {get}
    func append(value: Any)
    func prepend(value: Any)
    func removeFirst() -> Node?
    func removeLast() -> Node?

}



//Question2
public class Node{
    
    public var value: Any
    var next: Node? = nil
    
    public init(value: Any) {
        self.value = value
    }
    public var nodeDescription: String {
        get {
            return "\(value)"
        }
    }
    
}

public class LinkList : LinkListProtocol{
    public var head: Node? {
        didSet {
            if tail == nil {
                tail = head
            }
        }
    }
    
    private var tail: Node? {
        didSet {
            if head == nil {
                head = tail
            }
        }
    }
    
    internal var count: Int = 0
    

    public subscript(index:Int) -> Node? {
        if count > 0 && index <= count{
                var current = head
                for _ in 0...index{
                    current = current?.next
                }
                return current
            }
        else{
            print("RangeException")
            return head
        }
    }
    
    
    public func append(value: Any) {
        if isEmpty{
            head = Node(value:value)
        }
        else{
            let previousTail = tail
            tail = Node(value: value)
            previousTail?.next = tail
        }
        count += 1
    }
    
    public func prepend(value: Any){
        let previousHead = head
        head = Node(value:value)
        head?.next = previousHead
        
        count += 1
     }
    
    public func removeFirst() -> Node?{
        let previousHead = head
        
        head = head?.next
        count -= 1
        previousHead?.next = nil
        return previousHead
    }
    
    public func removeLast() -> Node?{
        if(!isEmpty){
            let previousTail = tail
            
            var current =  head
            var newTail : Nod
            while current?.next != nil{
                
                current = current?.next
            }
            count -= 1
            
            tail = current
            print(tail?.value)
            tail?.next = nil
            return previousTail
        }
        return nil
    }
    
    
     private func elements(separatedBy : String) -> NSString{
        var result = ""
        if count > 0{
            if head != nil{
                var current = head
                for _ in 0...count-2{
                    result += (current?.nodeDescription)!
                    result += separatedBy
                    current = current?.next
                }
                result += (tail?.nodeDescription)!;
                
            }
            
            
        }
        return result as NSString
        
    }
    
    public func description() -> String{
        var result = "("
        if head != nil{
            var current = head
            for _ in 0...count-2{
                    result += (current?.nodeDescription)!
                    result += ","
                    current = current?.next
                }
                result += (tail?.nodeDescription)!;
        
            }
        result += ")"
        return result
    }
    
    func test(splitBy : String) -> NSString {
        return elements(separatedBy: splitBy )
    }
    
    //Question 3
    
    public init() {
        count = 0;
    }
    
    public init(repeating:Any,count:Int){
        for _ in 0...count-1{
            append(value: repeating)
        }
    }
    public var isEmpty: Bool {
        get {
            return count == 0
        }
    }
    
    public func toArray() -> [Any]{
        var array = [Any]();
        
        if count > 0{
            if head != nil{
                var current = head
                for _ in 0...count-2{
                    array.append((current?.value)!)
                    current = current?.next
                }
                array.append((tail?.value)!);
                
            }
            
            
        }
        return array
    }
    
//Question 3
    public func map<T>(Element: (Any) -> T) -> LinkList {
        let result = LinkList()
        var current = self.head
        while current != nil {
            result.append(value: Element(current!.value))
            current = current!.next
        }
        return result
    }

    
    
    public func reduce<T>(Result initial: T, Function combine: (T, Any) -> T) -> T {
        var current = head
        var result = initial
        while current != nil {
            result = combine(result,current!.value)
            current = current!.next
        }
        return result
    }
    
    
}


//Question 4
extension String{
    func integerValues() -> [Int?]{
        var result : [Int?] = []
        
        let wordArray = self.components(separatedBy: ",")
        for i in wordArray{
            if Int(i) != nil{
                let arg : Int? = Int(i)
                result.append((arg)!)
            }
                else{
                    result.append(nil)
                }
            }
        return result
        
    }
    

}

struct CurrencySpecifications {
    var code : String
    var symbol : String
    var exchangeRate : Double
    
    init(code : String , symbol : String , exchangeRate : Double){
        self.code = code;
        self.symbol = symbol;
        self.exchangeRate = exchangeRate;
    }
}

enum Currency : String{
    case Euro
    case USDollar
    case IndianRupee
    case MexicanPeso
    
    func getAPI() -> CurrencySpecifications {
        switch self {
        case .Euro:
            return CurrencySpecifications(code : "EUR", symbol : "\u{20AC}", exchangeRate : 0.8904)
        case .USDollar:
            return CurrencySpecifications(code : "USD", symbol : "\u{24}", exchangeRate : 1)
        case .IndianRupee:
            return CurrencySpecifications(code : "INR", symbol : "\u{20B9}", exchangeRate : 66.7)
        case .MexicanPeso:
            return CurrencySpecifications(code : "MXN", symbol : "\u{24}", exchangeRate : 18.88)
            
        }
    }
}

struct Money {
    var currency : Currency
    var amount : Double
    
    func description() -> String{
        var result = ""
        result.append(self.currency.getAPI().symbol)
        result.append(String(self.amount)+" "+self.currency.getAPI().code)
        
        return result
    }

}

func +(left : Money, right : Money) -> Money{
    if left.currency == right.currency{
        var result = Money(currency : left.currency , amount : 0)
        result.amount = left.amount + right.amount
        return result
    }
    else{
        var result = Money(currency : left.currency, amount : 0)
        result.amount = left.amount + (((right.amount)*((left.currency.getAPI().exchangeRate)/(right.currency.getAPI().exchangeRate))))
        return result
    }
}
func -(left : Money, right : Money) -> Money{
    if left.currency == right.currency{
        var result = Money(currency : left.currency , amount : 0)
        result.amount = left.amount - right.amount
        return result
    }
    else{
        var result = Money(currency : left.currency, amount : 0)
        result.amount = left.amount - ((right.amount)*((left.currency.getAPI().exchangeRate)/(right.currency.getAPI().exchangeRate)))
        if result.amount < 0{
            result.amount = 0
            print("Amount of money can not be negative")
        }
        return result
    }
}
struct Rectangle {
    var width = 0
    var height = 0
}



print("_________________________________Solution 1 & 2_______________________________\n")
var list = LinkList()
list.append(value: 20)
list.append(value: 30)
list.append(value: 50)


list.prepend(value: Rectangle(width: 20, height : 25))
list.prepend(value: "Hello")
list.prepend(value: 10.034)

print("Description : " + list.description())
print("RemoveFirst : \((list.removeFirst()?.value)!)")
print("Description : " + list.description())

print("RemoveLast  : \((list.removeLast()?.value)!)")
print("Description : " + list.description())

print(list.test(splitBy: "-"))
print((list.description()))


print("2,3,4".integerValues())
print("2,foo,5,boo,6,7".integerValues())
print("foo".integerValues())
print("2".integerValues())

var m : Money = Money(currency : Currency.Euro , amount : 120)
print(m)
var n : Money = Money(currency : Currency.MexicanPeso , amount : 120)
var curr = m + n
print(curr.description())



let x = list.map { element in "Value of Node :\(element)" + " Datatype of Value : \(type(of: element))\n" }
//print(x.description())


//var arr: Int = 5
//let red: Int = list.reduce(&arr, { (arr: inout Int,node: Any) -> Int in  arr += (node as! Int); return arr; } )
//print(red)

var arr = ""
var z = ""
var y: String = list.reduce(Result: arr, Function:{ (arr:String, element: Any) -> String in z.append(String(describing : element)); return arr;})
