//
//  ContentView.swift
//  SMLiteContainer
//
//  Created by Vignesh on 17/05/22.
//

import SwiftUI
import Swinject

struct ContentView: View {
    
    let mainApp = MainApp()
    var body: some View {
        Button(action: {
            mainApp.didLoad()
        }, label: {
            Text("INIT")
        })
        Button(action: {
            mainApp.showCalendar()
        }, label: {
            Text("LOAD CALENDAR")
        })
        Button(action: {
            mainApp.showEasyShare()
        }, label: {
            Text("LOAD CALENDAR")
        })
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


protocol ContactModule {
    func fetchUser() -> String
}

struct ContactModuleImpl: ContactModule {
    func fetchUser() -> String {
        return "ME"
    }
}

struct ContactModuleImpl2: ContactModule {
    func fetchUser() -> String {
        return "NEW USER"
    }
}

protocol CalendarModule {
    var contactProvider: ContactModule { get set }
    func loadCalendar()
}

struct CalendarModuleImpl: CalendarModule {
    var contactProvider: ContactModule
    
    func loadCalendar() {
        let userToLoad = contactProvider.fetchUser()
        print("CALENDAR LOADER FOR \(userToLoad)")
    }
}

struct MainApp {
    
    let container = Container()
    
    func didLoad() {
        container.register(ContactModule.self, name: "ContactModuleImpl") { r in
            ContactModuleImpl()
        }
        container.register(ContactModule.self, name: "ContactModuleImpl2") { _ in
            ContactModuleImpl2()
        }
        container.register(CalendarModule.self, factory: { resolver in
            CalendarModuleImpl(contactProvider: resolver.resolve(ContactModule.self)!)
        })
    }
    
    func showCalendar() {
        let calendarModule = container.resolve(CalendarModule.self, name: "ContactModuleImpl")
        calendarModule?.loadCalendar()
    }
    
    func showEasyShare() {
        let easyShare = container.resolve(CalendarModule.self, name: "ContactModuleImpl2")
        easyShare?.loadCalendar()
    }
}
