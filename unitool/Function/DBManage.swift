//
//  DBManage.swift
//  unitool
//  Created by Shuangbing on 2018/11/20.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import SwiftyJSON
import RealmSwift

let Database_config = Realm.Configuration(schemaVersion: 2)
let Database = try! Realm(configuration: Database_config)
class User: Object {
    @objc dynamic var id = -1
    @objc dynamic var email = ""
    @objc dynamic var token = ""
    @objc dynamic var refresh_token = ""
    @objc dynamic var school = -1
    @objc dynamic var schoolAccount = ""
}

class TimeTable: Object {
    @objc dynamic var week = -1
    @objc dynamic var coma = -1
    @objc dynamic var subject = ""
    @objc dynamic var classroom = ""
    @objc dynamic var teacher = ""
    @objc dynamic var bgColor = -1
    @objc dynamic var subjectCode = ""
}


func delAllSubject(){
    try! Database.write {
        Database.delete(Database.objects(TimeTable.self))
    }
}


func readAllSubject()->Results<TimeTable>{
    let subjectData = Database.objects(TimeTable.self)
    return subjectData
}

func updateSubject(data: JSON) {
    
    try! Database.write {
        Database.delete(Database.objects(TimeTable.self))
    }
    print(data)
    
    for sub in data {
        let index = Int(sub.0)!
        let subject = TimeTable()
        subject.week = sub.1[0].intValue
        subject.coma = sub.1[1].intValue
        subject.subject = sub.1[2].stringValue
        subject.teacher = sub.1[3].stringValue
        subject.classroom = ""
        if(index <= SubjectColor.count - 1)
        {
            subject.bgColor = index
        }else{
            subject.bgColor = Int(arc4random()%7)
        }
        subject.subjectCode = ""
        try! Database.write {
            Database.add(subject)
        }
    }
}

func updateSubject_from_v1(data: JSON) {
    
    try! Database.write {
        Database.delete(Database.objects(TimeTable.self))
    }
    print(data)
    
    for sub in data {
        let index = Int(sub.0)!
        let subject = TimeTable()
        subject.week = sub.1[0].intValue
        subject.coma = sub.1[1].intValue + 1
        subject.subject = sub.1[2].stringValue
        subject.teacher = sub.1[3].stringValue
        subject.classroom = ""
        if(index <= SubjectColor.count - 1)
        {
            subject.bgColor = index
        }else{
            subject.bgColor = Int(arc4random()%7)
        }
        subject.subjectCode = ""
        try! Database.write {
            Database.add(subject)
        }
    }
}

func delectOneSubject(week: Int, coma: Int) {
    let sub = Database.objects(TimeTable.self).filter("week == \(week) && coma == \(coma)")
    try! Database.write {
        Database.delete(sub)
    }
}

func addOneSubject(subject: TimeTable) {
    delectOneSubject(week: subject.week, coma: subject.coma)
    try! Database.write {
        Database.add(subject)
    }
}

func editOneSubject(week: Int, coma: Int, subject: TimeTable){
    delectOneSubject(week: week, coma: coma)
    try! Database.write {
        Database.add(subject)
    }
}

func addSubject(subject: TimeTable){
    try! Database.write {
        Database.add(subject)
    }
}

func addUser(user: User) {
    try! Database.write {
        Database.add(user)
    }
    UserData = user
}

func readUser() -> User {
    let UserData = Database.objects(User.self).first
    return UserData ?? User()
}

func updateToken(token_new: String){
    let UserData = Database.objects(User.self).first
    try! Database.write {
        UserData?.schoolAccount = token_new
    }
}

func updateTokenByRefresh(access_token: String, refresh_token: String){
    let UserData = Database.objects(User.self).first
    try! Database.write {
        UserData?.token = access_token
        UserData?.refresh_token = refresh_token
    }
}

func logoutUser() {
    //SchoolAPI.logout()
    try! Database.write {
        Database.delete(Database.objects(User.self))
    }
    UserData = User()
}

func isLogined() -> Bool {
    let schoolAccount = UserData.schoolAccount.split(separator: "|")
    if schoolAccount.count == 2{
        return true
    }
    return false
}

func getSchoolAccount() -> Array<Any>{
    let schoolAccount = UserData.schoolAccount.split(separator: "|")
    return [schoolAccount[1],schoolAccount[2]]
}


