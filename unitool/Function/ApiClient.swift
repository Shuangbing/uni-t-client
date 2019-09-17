//
//  ApiClient.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/19.
//  Copyright © 2018 Shuangbing. All rights reserved.
//

import UIKit
import StatusAlert
import Alamofire
import SwiftyJSON

var ACCESS_TOKEN = ""
var isAgreePolicy = false
var SUPPORT_SCHOOL = JSON("{}").arrayValue
var USER_SCHOOL = JSON("{}").arrayValue
let USER_UUID = UIDevice.current.identifierForVendor?.uuidString
var isTOKEN_UPDATED = false
let public_key = "@"

var selectSchoolNo = -1
var USERNAME = ""
var PASSWORD = ""

var url_attend_1 = "https://call**********.jp/index.php"
var url_attend_2 = "https://call**********.jp/index.php"
var url_webclass_1 = "https://webcl**********.jp/webclass/login.php"
var url_webclass_2 = "https://webcl**********.jp/webclass/?acs_="


func developServer() {
    url_attend_1 = "https://www.uni-t.cc/demo1/attend_1.html"
    url_attend_2 = "https://www.uni-t.cc/demo1/attend_2.html"
    url_webclass_1 = "https://www.uni-t.cc/demo1/webclass.html?"
    url_webclass_2 = "https://www.uni-t.cc/demo1/webclass.html?"
}

class UnitSchool: NSObject{
    
    func check(completion:((_ success: Bool, _ result: String?, _ attendData: [JSON])->Void)?, user:String, psw:String) {
        if (user == "g0000000" && psw == "demo20180707") {
            developServer()
            let UserData = User()
            UserData.id = 0
            UserData.email = "dev@uni-t.cc"
            UserData.token = "@"
            UserData.refresh_token = "@"
            UserData.school = 10001
            UserData.schoolAccount = "\(user)|\(psw)"
            addUser(user: UserData)
            return (completion?(true, "ログイン完了", []))!
        }
        //---------check---------
        var resJson = JSON.init()
        let webc_login_data: Parameters = [
            "username": user,
            "val": psw,
            "useragent": "",
            "language": "JAPANESE"]
        
        Alamofire.request(url_webclass_1, method: .post, parameters: webc_login_data ,encoding: URLEncoding.httpBody).responseString { (res) in
            let html = res.result.value
            let acs_msg = (html?.slice(from: "acs_=", to:"\""))!
            
            if(acs_msg.count == 8) {
                resJson["code"] = 200
                resJson["message"] = "認証が完了しました"
                let UserData = User()
                UserData.id = 0
                UserData.email = "@"
                UserData.token = "@"
                UserData.refresh_token = "@"
                UserData.school = 10001
                UserData.schoolAccount = "\(user)|\(psw)"
                addUser(user: UserData)
            }else{
                resJson["code"] = 400
                resJson["message"] = "認証できません"
            }

            if resJson["code"] == 200 {
            //updateToken(token_new: RSA_SCHOOL_ACCOUNT(user: user, psw: psw))
            completion?(true, resJson["message"].stringValue, [])
                }else{
            completion?(false, resJson["message"].stringValue, [])
            }

        }
        //---------check---------
    }
    
    func getSubject(completion:((_ success: Bool, _ result: String?, _ attendData: JSON)->Void)?, year: String, semester: Int) {
        //---------getSubject---------

        let schoolAccount = UserData.schoolAccount.split(separator: "|")
        
        let webc_login_data: Parameters = [
            "username": schoolAccount[0],
            "val": schoolAccount[1],
            "useragent": "",
            "language": "JAPANESE"]
        Alamofire.request(url_webclass_1, method: HTTPMethod.post, parameters: webc_login_data ,encoding: URLEncoding.httpBody).responseString { (res) in
            let html = res.result.value
            let acs_msg = (html?.slice(from: "acs_=", to:"\""))!

            if(acs_msg.count == 8) {
                Alamofire.request(url_webclass_2 + acs_msg + "&year=\(year)&semester=\(semester+3)").responseString { (response) in
                    let html:String = String(data: response.data!, encoding: .utf8)!
                    let week_japanese = ["月曜日","火曜日","水曜日","木曜日","金曜日","土曜日","日曜日"]
                    var lesson_list = [[]]
                    let main_msg = (html.slice(from: "<div class=\"visible-xs list-group schedule-list\">", to: "コースの追加")) ?? ""
                    var weekd_data = ""
                    var dayd_data = ""
                    print(html)
                    if main_msg != "" {
                        lesson_list.removeAll()
                        for j in 0...6 {
                            weekd_data = (main_msg.slice(from: week_japanese[j], to: "list-group-item list-group-label-item") ?? "")!
                            if weekd_data == "" {
                                weekd_data = (main_msg.slice(from: week_japanese[j], to: "margin-top") ?? "")!
                                if weekd_data == "" {continue}
                            }
                            for i in 1...5 {
                                dayd_data = (weekd_data.slice(from: String(i)+"限", to: ")</h4>") ?? "")!
                                if dayd_data == "" {continue}
                                print(dayd_data)
                                let name_1 = dayd_data.slice(from: "&raquo; ", to: " (")!
                                let name_2 = dayd_data.slice(from: "、", to: "、") ?? ""
                                lesson_list.append([j,i,name_1,name_2])
                            }
                        }
                        completion?(true, "同期が完了しました", JSON(lesson_list))
                    }else{
                        completion?(false, "同期可能な情報がありません", JSON(lesson_list))
                    }
                }
            }else{
                completion?(false, "同期できませんでした", [])
            }
            
        }
        //---------getSubject---------
    }
    
    func getScore(completion:((_ success: Bool, _ result: String?, _ attendData: [JSON])->Void)?) {
            completion?(false, "fall", [])
        //---------getScore---------
    }
    
    func getLessonData(html : String) -> [[String]] {
        var data_res:[[String]] = []
        var data:[String] = ["",""]
        var temp = html.slice(from: "\"x\" selected>", to:"<br>")
        let array : Array = temp!.components(separatedBy: "option value")
        for text_temp in array {
            temp = text_temp.slice(from: "<option value=", to:"</option>")
            temp = text_temp.slice(from: "\"", to:"\"")
            if temp != nil {data[0] = temp!} else {continue}
            temp = html.slice(from: data[0]+"\">", to:"</option>")
            if temp != nil {data[1] = temp!} else {continue}
            data_res.append(data)
        }
        return data_res
    }

    func getAttendList(completion:((_ success: Bool, _ result: String?, _ attendData: JSON)->Void)?) {
        
        let schoolAccount = UserData.schoolAccount.split(separator: "|")
        let param : Parameters = [
            "uid": schoolAccount[0],
            "pass": schoolAccount[1],
            "module": "Default",
            "action": "Login"
        ]
        let url = URL(string: "\(url_attend_1)?menuname=%8Fo%90%C8&")
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded; charset=Shift_JIS", forHTTPHeaderField: "Content-Type")
        let encodedRequest = try? URLEncoding.queryString.encode(request, with: param)
        Alamofire.request(encodedRequest!).responseString { (attend_body) in
            //let html:String = attend_body.result.value!
            let html:String = String(data: attend_body.data!, encoding: .shiftJIS)!.replacingOccurrences(of: "&nbsp;", with: "  ")
            print(html)
            let error = html.slice(from: "</head>", to:"</body>")!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "\n", with: "", options: .regularExpression, range: nil)
            var error_msg = error
            var error_msg_logined = error
            let login_result = html.contains(schoolAccount[0])
            if login_result == true {
                let isHaveLesson = html.contains("SelKamoku")
                if isHaveLesson == true{
                    let attend_data = self.getLessonData(html: html)
                    print(JSON(attend_data))
                    completion?(true, "ok!", JSON(attend_data))
                }
                else{
                    if error_msg_logined == "" {error_msg_logined = "該当科目がないため登録できません"}
                    completion?(false, error_msg, [])
                }
            }else{
                if error_msg == "" {error_msg = "ログイン出来ませんでした [-1]"}
                completion?(false, error_msg, [])
            }
        
        }
        //---------getAttendList---------
    }
    
    func sendAttend(completion:((_ success: Bool, _ result: String?, _ attendData: [JSON])->Void)?, attenddata:String, attendno:String) {
        
        let attend_send_data: Parameters = [
            "module": "Sk",
            "action": "ProcedureAcc",
            "SelKamoku": attenddata,
            "InpNo": attendno,
            //"submitButtonName": "出席登録"
        ]
        //---------sendAttend---------
        Alamofire.request("\(url_attend_2)?submitButtonName=%8Fo%90%C8%93o%98%5E&", method: HTTPMethod.post, parameters: attend_send_data ,encoding: URLEncoding.httpBody).responseString { (attend_body) in
            let html:String = String(data: attend_body.data!, encoding: .shiftJIS)!.replacingOccurrences(of: "&nbsp;", with: "  ").replacingOccurrences(of: "<br>", with: "\n")
            let message = html.slice(from: "</head>", to:"</body>")!.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil).replacingOccurrences(of: "\n", with: "", options: .regularExpression, range: nil)
            completion?(true, message, [])
        }
        //---------sendAttend---------
    }

    
}


func showAlert(type: Int, msg: String) {
    let statusAlert = StatusAlert()
    StatusAlert.multiplePresentationsBehavior = .dismissCurrentlyPresented
    switch type {
    case 1:
        statusAlert.title = "完了"
        statusAlert.image = UIImage(named: "success")
        HapticFeedback.Notification.pop()
    case 2:
        statusAlert.title = "エラー"
        statusAlert.image = UIImage(named: "error")
        HapticFeedback.Notification.failed()
    case 3:
        statusAlert.title = nil
        statusAlert.image = nil
        HapticFeedback.Notification.failed()
    default:
        statusAlert.image = UIImage(named: "success")
    }
    
    statusAlert.message = msg
    statusAlert.canBePickedOrDismissed = false
    statusAlert.showInKeyWindow()
}

func showWaitAlert() {
    let statusAlert = StatusAlert()
    statusAlert.image = nil
    statusAlert.title = nil
    statusAlert.isMultipleTouchEnabled = true
    statusAlert.message = "読み取り中..."
    statusAlert.canBePickedOrDismissed = false
    statusAlert.showInKeyWindow()
    //statusAlert.show(multiplePresentationsBehavior: .dismissCurrentlyPresented)
}

func base64Encoding(plainString:String)->String
{
    let plainData = plainString.data(using: String.Encoding.utf8)
    let base64String = plainData?.base64EncodedString(options: NSData.Base64EncodingOptions.init(rawValue: 0))
    return base64String!
}

func base64Decoding(encodedString:String)->String
{
    let decodedData = NSData(base64Encoded: encodedString, options: NSData.Base64DecodingOptions.init(rawValue: 0))
    let decodedString = NSString(data: decodedData! as Data, encoding: String.Encoding.utf8.rawValue)! as String
    return decodedString
}
