//
//  main.swift
//  SimpleDomainModel
//
//  Created by Ted Neward on 4/6/16.
//  Copyright © 2016 Ted Neward. All rights reserved.
//

import Foundation

print("Hello, World!")

public func testMe() -> String {
  return "I have been tested"
}

public class TestMe {
  public func Please() -> String {
    return "I have been tested"
  }
}

////////////////////////////////////
// Money
//
public struct Money {
  public var amount : Int
  public var currency : String
  
  public mutating func convert(to: String) -> Money {
    let currencyConverter: [String: Double] = ["USD": 1, "GBP": 0.5, "EUR": 1.5, "CAN": 1.25]
    amount = Int(Double(amount) * (currencyConverter[to]! / currencyConverter[currency]!))
    currency = to
    return(Money(amount: self.amount, currency: self.currency))
    }
  
  public mutating func add(to: Money) -> Money {
    if(currency == to.currency) {
        amount += to.amount
        return(Money(amount: self.amount, currency: self.currency))
    } else {
        // Different currencies
        amount = convert(to.currency).amount
        amount += to.amount
        return(Money(amount: self.amount, currency: self.currency))
    }
  }
    
  public mutating func subtract(from: Money) -> Money {
    if(currency == from.currency) {
        amount = amount - from.amount
        return(Money(amount: self.amount, currency: self.currency))
    } else {
        // Different currencies
        amount = convert(from.currency).amount
        amount = amount - from.amount
        return(Money(amount: self.amount, currency: self.currency))
    }
  }
}

////////////////////////////////////
// Job
//
public class Job {
  public enum JobType {
    case Hourly(Double)
    case Salary(Int)
  }
    public var title : String
    public var type : JobType
    
  public init(title : String, type : JobType) {
    self.title = title
    self.type = type
  }
  
  public func calculateIncome(hours: Int) -> Int {
    switch type {
    case .Hourly(let value):
        return(hours * Int(value))
    case .Salary(let value):
        return value
    }
  }
}

////////////////////////////////////
// Person
//

public class Person {
  public var firstName : String = ""
  public var lastName : String = ""
  public var age : Int = 0

  public var job : Job? {
    get {
        return self.job
    }
    set(inputJob) {
        if age >= 16 {
            self.job = Job(title: inputJob!.title, type: inputJob!.type)
        } else {
            self.job = nil
        }
    }
  }
  
  public var spouse : Person? {
    get {
        return self.spouse
    }
    set(value) {
        if age >= 18 {
            self.spouse = Person(firstName: value!.firstName, lastName: value!.lastName, age: value!.age)
        } else {
            self.spouse = nil
        }
    }
  }
  
  public init(firstName : String, lastName: String, age : Int) {
    self.firstName = firstName
    self.lastName = lastName
    self.age = age
  }
  
  public func toString() -> String {
    return("[Person: firstName:\(firstName) lastName:\(lastName) age:\(age) job:\(job) spouse:\(spouse)]")
  }
}

////////////////////////////////////
// Family
//
public class Family {
  private var members : [Person] = []
  
  public init(spouse1: Person, spouse2: Person) {
    if(spouse1.age >= 18 && spouse2.age >= 18) {
        if(spouse1.spouse == nil && spouse2.spouse == nil) {
            spouse1.spouse = spouse2
            spouse2.spouse = spouse1
            members.append(spouse1)
            members.append(spouse2)
        }
    }
  }
  
  public func haveChild(child: Person) -> Bool {
    var canhave = false
    for person: Person in members {
        if(person.age >= 21) {
            canhave = true
        }
        if(canhave) {
            members.append(Person(firstName: child.firstName, lastName: child.lastName, age: child.age))
        }
    }
    return(canhave)
  }
  
  public func householdIncome() -> Int {
    var totalIncome = 0
    for person: Person in members {
        if(person.job != nil) {
            totalIncome += person.job!.calculateIncome(2000)
        }
    }
    return(totalIncome)
  }
}


