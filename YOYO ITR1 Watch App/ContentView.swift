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
    @State private var shuttle = "5.1"
    
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
                                  "LOCK IN",
                                  "MINDSET",
                                  "NOW",
                                  "OWN IT",
                                  "PUSH",
                                  "QUIET",
                                  "RELENTLESS",
                                  "STRONG",
                                  "TRUST",
                                  "UP",
                                  "VICTORY",
                                  "WANT, WILL",
                                  "XCEED",
                                  "YES",
                                  "ZERO EXCUSES",
                                  "AGAIN",
                                  "BREATHE",
                                  "CLIMB",
                                  "DO THE THANG",
                                  "EXTRA",
                                  "GRIND",
                                  "FIGHT",
                                  "HAUL ASS",
                                  "ICE"]
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
                                  "14.2",
                                  "14.3",
                                  "14.4",
                                  "14.5",
                                  "14.6",
                                  "14.7",
                                  "14.8",
                                  "15.1",
                                  "15.2",
                                  "15.3",
                                  "15.4",
                                  "15.5",
                                  "15.6",
                                  "15.7",
                                  "15.8",
                                  "16.1",
                                  "16.2",
                                  "16.3",
                                  "16.4",
                                  "16.5",
                                  "16.6",
                                  "16.7",
                                  "16.8"]

    
    let startSchedule = TimeConstants.startSchedule
    let finishSchedule = TimeConstants.finishSchedule
    let halfSchedule = TimeConstants.halfSchedule
    let warningSchedule = TimeConstants.warningSchedule
    

    var body: some View {
        VStack() {
            Text(shuttle)
                .font(.caption)
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
        shuttle = "\(shuttleNums[shuttleIndex % shuttleNums.count])"
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
                    shuttle = "\(shuttleNums[shuttleIndex % shuttleNums.count])"
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
