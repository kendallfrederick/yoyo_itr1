//
//  ContentView.swift
//  YOYO ITR1 Watch App
//
//  Created by Kendall Frederick on 8/2/25.
//

import SwiftUI
import WatchKit
import Foundation

struct ContentView: View {
    @State private var isRunning = false
    @State private var shuttleIndex = 0 // Which shuttle we're on (A, B, C…)
    @State private var statusText = "Ready"
    @State private var textColor = Color.primary
    @State private var startTimer: Timer?
    @State private var finishTimer: Timer?
    
    let shuttleWords: [String] = ["ATTACK",
                                  "BREATHE",
                                  "CLIMB",
                                  "DRIVE",
                                  "EFFORT",
                                  "FOCUS",
                                  "GRIT",
                                  "HUSTLE",
                                  "INTENT",
                                  "JOY",
                                  "KEEP IT UP",
                                  "14.1: LOCK IN",
                                  "MINDSET",
                                  "NOW",
                                  "OWN IT",
                                  "PUSH",
                                  "QUIET",
                                  "RELENTLESS",
                                  "STRONG",
                                  "15.1: TRUST",
                                  "UP",
                                  "VICTORY",
                                  "WANT, WILL",
                                  "XCEED",
                                  "YES",
                                  "ZERO EXCUSES",
                                  "AGAIN",
                                  "16.1: BREATHE",
                                  "CLIMB",
                                  "16.3: DO THE THANG",
                                  "EXTRA",
                                  "FIGHT",
                                  "HAUL ASS",
                                  "16.8: ICE"]
    let shuttleNums: [String] = ["5.1",
                                  "9.1",
                                  "11.1",
                                  "11.2",
                                  "12.1",
                                  "12.2",
                                  "12.3",
                                  "13.1",
                                  "13.2",
                                  "13.3",
                                  "13.4",
                                  "14.1",
                                  "MINDSET",
                                  "NOW",
                                  "OWN IT",
                                  "PUSH",
                                  "QUIET",
                                  "RELENTLESS",
                                  "STRONG",
                                  "15.1: TRUST",
                                  "UP",
                                  "VICTORY",
                                  "WANT, WILL",
                                  "XCEED",
                                  "YES",
                                  "ZERO EXCUSES",
                                  "AGAIN",
                                  "16.1: BREATHE",
                                  "CLIMB",
                                  "16.3: DO THE THANG",
                                  "EXTRA",
                                  "FIGHT",
                                  "HAUL ASS",
                                  "16.8: ICE"]

    
    let startSchedule = TimeConstants.startSchedule
    let finishSchedule = TimeConstants.finishSchedule
    let halfSchedule = TimeConstants.halfSchedule
    let warningSchedule = TimeConstants.warningSchedule
    

    var body: some View {
        VStack(spacing: 20) {
            Text(statusText)
                .font(.largeTitle)
                .foregroundColor(textColor)
            Button(action: {
                isRunning ? stopTest() : startTest()
            }) {
                Text(isRunning ? "Stop" : "Start")
            }
        }
    }

    func startTest() {
        isRunning = true
        shuttleIndex = 0
        statusText = "\(shuttleWords[shuttleIndex % shuttleWords.count])"
        textColor = .green
                
        for i in 0..<min(startSchedule.count, finishSchedule.count) {
            let startTime = startSchedule[i]
            let endTime = finishSchedule[i]
            let halfTime = halfSchedule[i]
            let warningTime = warningSchedule[i]
            
            // START
            DispatchQueue.main.asyncAfter(deadline: .now() + startTime) {
                if isRunning {
                    WKInterfaceDevice.current().play(.start)
                    textColor = .green
                }
            }
            
            // HALFWAY
            DispatchQueue.main.asyncAfter(deadline: .now() + halfTime) {
                if isRunning {
                    WKInterfaceDevice.current().play(.directionUp)
                    textColor = .green
                }
            }
            
            // ONE SECOND WARNING
            DispatchQueue.main.asyncAfter(deadline: .now() + warningTime) {
                if isRunning {
                    WKInterfaceDevice.current().play(.click)
                    textColor = .green
                }
            }
            
            // FINISH/ START REST
            DispatchQueue.main.asyncAfter(deadline: .now() + endTime) {
                if isRunning {
                    WKInterfaceDevice.current().play(.success)
                    textColor = .red
                    shuttleIndex += 1
                    statusText = "\(shuttleWords[shuttleIndex % shuttleWords.count])"
                }
            }
            
        }
    }

    func stopTest() {
        isRunning = false
        startTimer?.invalidate()
        finishTimer?.invalidate()
        statusText = "Stopped"
        textColor = .primary
    }
}
