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
        @State private var timer: Timer?
        @State private var startTime: Date?
        @State private var shuttle = "5.1"
        
        // Track which events have already been triggered for current shuttle
        @State private var hasTriggeredStart = false
        @State private var hasTriggeredHalf = false
        @State private var hasTriggeredWarning = false
        @State private var hasTriggeredFinish = false
    
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
        startTime = Date()
        shuttleIndex = 0
        isRunning = true
        statusText = shuttleWords[shuttleIndex]
        shuttle = shuttleNums[shuttleIndex]
        
        // Reset event flags
        resetEventFlags()

        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true
        ) { _ in
            guard let start = startTime else { return }
            let elapsed = Date().timeIntervalSince(start)

            // Make sure we don't go out of bounds
            guard shuttleIndex < startSchedule.count else {
                stopTest()
                return
            }

            //check for start times
            if !hasTriggeredStart && elapsed >= startSchedule[shuttleIndex] {
                WKInterfaceDevice.current().play(.notification)
                textColor = .green
                hasTriggeredStart = true
                print("Start triggered for shuttle \(shuttleIndex) at \(elapsed)s")
            }
            
            //check for halfway times
            if !hasTriggeredHalf && elapsed >= halfSchedule[shuttleIndex] {
                WKInterfaceDevice.current().play(.directionUp)
                hasTriggeredHalf = true
                print("Half triggered for shuttle \(shuttleIndex) at \(elapsed)s")
            }
            
            //check for warning times
            if !hasTriggeredWarning && elapsed >= warningSchedule[shuttleIndex] {
                WKInterfaceDevice.current().play(.click)
                hasTriggeredWarning = true
                print("Warning triggered for shuttle \(shuttleIndex) at \(elapsed)s")
            }
            
            //check for finish times
            if !hasTriggeredFinish && elapsed >= finishSchedule[shuttleIndex] {
                WKInterfaceDevice.current().play(.success)
                shuttleIndex += 1
                textColor = .red
                hasTriggeredFinish = true
                print("Finish triggered, advancing to shuttle \(shuttleIndex) at \(elapsed)s")
                
                // Check if we've completed all shuttles
                if shuttleIndex >= shuttleWords.count || shuttleIndex >= shuttleNums.count {
                    stopTest()
                    statusText = "COMPLETE!"
                    return
                }
                
                // Update display for next shuttle
                statusText = shuttleWords[shuttleIndex]
                shuttle = shuttleNums[shuttleIndex]
                
                // Reset flags for next shuttle
                resetEventFlags()
            }
        }
    }
    
    func resetEventFlags() {
        hasTriggeredStart = false
        hasTriggeredHalf = false
        hasTriggeredWarning = false
        hasTriggeredFinish = false
    }

    func stopTest() {
        timer?.invalidate()
        timer = nil
        isRunning = false
        statusText = "Ready"
        textColor = .primary
        shuttleIndex = 0
        shuttle = "5.1"
        resetEventFlags()
    }
}
