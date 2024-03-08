//
//  Combine+Extensions.swift
//  PomoHabit
//
//  Created by Joon Baek on 2024/03/09.
//

import Combine
import UIKit

extension UIControl {
    func controlPublisher(for event: UIControl.Event) -> UIControl.EventPublisher {
        return UIControl.EventPublisher(control: self, event: event)
      }
    
    // Publisher
    struct EventPublisher: Publisher {
        typealias Output = UIControl
        typealias Failure = Never
        
        let control: UIControl
        let event: UIControl.Event
        
        func receive<S>(subscriber: S) where S : Subscriber, Never == S.Failure, UIControl == S.Input {
            let subscription = EventSubscription(control: control, subscriber: subscriber, event: event)
            subscriber.receive(subscription: subscription)
        }
    }
    
    // Subscription
    fileprivate class EventSubscription<EventSubscriber: Subscriber>: Subscription where EventSubscriber.Input == UIControl, EventSubscriber.Failure == Never {

        let control: UIControl
        let event: UIControl.Event
        var subscriber: EventSubscriber?
        
        init(control: UIControl, subscriber: EventSubscriber, event: UIControl.Event) {
            self.control = control
            self.subscriber = subscriber
            self.event = event
            
            control.addTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        func request(_ demand: Subscribers.Demand) {}
        
        func cancel() {
            subscriber = nil
            control.removeTarget(self, action: #selector(eventDidOccur), for: event)
        }
        
        @objc func eventDidOccur() {
            /// 추가 요청이 있는 경우에만 새로운 값을 전송
            guard let subscriber = subscriber, subscriber.receive(control) != .none else {
                return
            }
        }
    }
}

extension UITextField {
    var textPublisher: AnyPublisher<String?, Never> {
        controlPublisher(for: .editingChanged)
            .map { $0 as? UITextField }
            .map { $0?.text }
            .eraseToAnyPublisher()
    }
    
    var textDidChangePublisher: AnyPublisher<String, Never> {
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
            .compactMap { $0.object as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}

extension UIButton {
    var tapPublisher: AnyPublisher<Void, Never> {
        controlPublisher(for: .touchUpInside)
            .map { _ in }
            .eraseToAnyPublisher()
    }
}

extension UISwitch {
    var statePublisher: AnyPublisher<Bool, Never> {
        controlPublisher(for: .valueChanged)
            .map { $0 as! UISwitch }
            .map { $0.isOn }
            .eraseToAnyPublisher()
    }
}

extension UIView {
    var gesturePublisher: GesturePublisher {
        .init(view: self, gestureType: .tap())
    }
}

