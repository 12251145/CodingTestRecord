//
//  UIControl + CustomPublisher.swift
//  CodingTestRecord
//
//  Created by Hoen on 2022/06/15.
//


import Combine
import UIKit

extension UIControl {
    class EventControlSubscription<S: Subscriber, Control: UIControl>: Subscription where S.Input == Control, S.Failure == Never {
        
        let control: Control
        let event: UIControl.Event
        var subscriber: S?
        
        var currentDemand: Subscribers.Demand = .none
        
        init(control: Control, event: UIControl.Event, subscriber: S) {
            self.control = control
            self.event = event
            self.subscriber = subscriber
            
            control.addTarget(self,
                              action: #selector(eventRaised),
                              for: event
            )
        }
        
        func request(_ demand: Subscribers.Demand) {
            currentDemand += demand
        }
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self,
                                 action: #selector(eventRaised),
                                 for: event
            )
        }
        
        @objc
        func eventRaised() {
            
            if currentDemand > 0 {
                currentDemand += subscriber?.receive(control) ?? .none
                currentDemand -= 1
            }
        }
    }
    
    struct EventControlPublisher<Control: UIControl>: Publisher {
        typealias Output = Control
        typealias Failure = Never
        
        let control: Control
        let controlEvent: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, Control == S.Input {
            let subscription = EventControlSubscription(control: control, event: controlEvent, subscriber: subscriber)
            subscriber.receive(subscription: subscription)
        }
    }
}

protocol Combinable {}
extension UIControl: Combinable {}

extension Combinable where Self: UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventControlPublisher<Self> {
        return UIControl.EventControlPublisher(control: self, controlEvent: event)
    }
}
