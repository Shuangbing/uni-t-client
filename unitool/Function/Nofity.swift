//
//  Nofity.swift
//  unitool
//
//  Created by Shuangbing on 2018/12/13.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import UserNotifications

class PushNofity{
    var description: String = ""
    
    func offPush(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        center.removeAllPendingNotificationRequests()
    }
    
    func onPush(){
        let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications()
        
        center.removeAllPendingNotificationRequests();
        center.requestAuthorization(options:[.badge, .alert, .sound]) {
            (granted, error) in if granted { print("通知許可")}
        }
        
        for SubjectNofity in timetableData{
            let weekdayInt = SubjectNofity.week
            let comaInt = SubjectNofity.coma
            let Time = UserSetting["timetable"]["periodList"][comaInt-1]
            if (Time.count == 2)
            {
                if weekdayInt <= weekDayNum, comaInt <= comaNum{
                    var classroom = SubjectNofity.classroom
                    if classroom == "" {classroom = "教室未設定"}
                    let bodyStr = "\(SubjectNofity.subject) | \(classroom) 🕐\(Int(Time[0].intValue/60)):\(String(format: "%02d", Time[0].intValue%60))~"
                    center.add(createNewPush(week: weekdayInt+2, time: Time[0].intValue-10, body: bodyStr))
                }
            }
            
        }
    }
    
    func createNewPush(week:Int, time: Int, body: String)->UNNotificationRequest{
        var notificationTime = DateComponents()
        let content = UNMutableNotificationContent()
        content.title = "次の授業まもなく始まります"
        content.body = body
        content.sound = UNNotificationSound.default
        notificationTime.weekday = week
        notificationTime.hour = Int(time/60)
        notificationTime.minute = time % 60
        let trigger = UNCalendarNotificationTrigger(dateMatching: notificationTime, repeats: true)
        let request = UNNotificationRequest(identifier: "SubjectNofity\(week)_\(time)", content: content, trigger: trigger)
        return request
    }
}
