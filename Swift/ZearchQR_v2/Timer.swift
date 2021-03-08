//
//  Timer.swift
//  ZearchQR_v2
//
//  Created by Erik Zettergren on 2021-03-06.
//  Found some code on StackOverflow in a post, my timer didn't keep running in the backround and you can either make it run in the backround thread using notifications
//  Or you could use this where it calculates the difference in date/time since start once the user returns to the app. Thought it was a clean implementation.
//  Made some additions to it.
//

import Foundation
import Combine

class Stopwatch: ObservableObject {
    /// String to show in UI
    @Published private(set) var message = ""
    @Published private(set) var time_sec: Double = 0

    /// Is the timer running?
    @Published private(set) var isRunning = false

    /// Time that we're counting from
    private var startTime: Date?                        { didSet { saveStartTime() } }

    /// The timer
    private var timer: AnyCancellable?

    init() {
        startTime = fetchStartTime()

        if startTime != nil {
            start()
        }
    }
}

// MARK: - Public Interface

extension Stopwatch {
    func start() {
        timer?.cancel()               // cancel timer if any

        if startTime == nil {
            startTime = Date()
        }

        message = ""
        time_sec = 0
        
        timer = Timer
            .publish(every: 0.1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard
                    let self = self,
                    let startTime = self.startTime
                else { return }

                let now = Date()
                let elapsed = now.timeIntervalSince(startTime)

                guard elapsed < 5000 else {
                    self.stop()
                    return
                }
                //        let hours   = Int(time) / 3600
                //        let minutes = Int(time) / 60 % 60
                //        let seconds = Int(time) % 60
                let hours: Int = Int(elapsed/36000)
                let minutes: Int = Int(elapsed) / 60 % 60
                let seconds: Int = Int(elapsed) % 60
                
                self.time_sec = elapsed
                
                if elapsed < 3600
                {
                    self.message = String(format: "%0.2i:%0.2i", minutes,seconds)
                }
                else if elapsed > 3600
                {
                    self.message = String(format: "%0.2i%:0.2i:%0.2i", hours,minutes,seconds)
                }
            }

        isRunning = true
    }

    func stop() {
        timer?.cancel()
        timer = nil
        startTime = nil
        isRunning = false
        message = ""
        time_sec = 0
    }
}

// MARK: - Private implementation

private extension Stopwatch {
    func saveStartTime() {
        if let startTime = startTime {
            UserDefaults.standard.set(startTime, forKey: "startTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }

    func fetchStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }
}
