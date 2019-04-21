//
//  HapticFeedback.swift
//  unitool
//
//  Created by Shuangbing on 2018/11/20.
//  Copyright © 2018 Shuangbing. All rights reserved.
//
import AudioToolbox.AudioServices


open class HapticFeedback {
    
    public struct Notification {
        
        
        public static func peek() {
            let peek = SystemSoundID(1519)
            AudioServicesPlaySystemSound(peek)
        }
        
        public static func pop() {
            let pop = SystemSoundID(1520)
            AudioServicesPlaySystemSound(pop)
        }
        
        public static func cancelled() {
            let cancelled = SystemSoundID(1521)
            AudioServicesPlaySystemSound(cancelled)
        }
        
        public static func tryAgain() {
            let tryAgain = SystemSoundID(1102)
            AudioServicesPlaySystemSound(tryAgain)
        }
        
        
        public static func failed() {
            let failed = SystemSoundID(1107)
            AudioServicesPlaySystemSound(failed)
        }
        
    }
    
}
