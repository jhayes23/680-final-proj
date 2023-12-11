import SwiftUI
import UserNotifications


class NotificationManager {
    static let instance = NotificationManager()
    
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error{
                print("Error requesting notifications: \(error)")
            }
        }
    }
    
    func scheduleNotification(waterReminderID: WateringReminder.ID, date: Date, repeats: Bool) {
        let calendar = Calendar.current
        var dateComponent = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        
        dateComponent.hour = 23
        dateComponent.minute = 08
        
        let content = UNMutableNotificationContent()
        content.title = "Time to water your plant!"
        content.sound = .default
        content.badge = 1
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: repeats)
        let request = UNNotificationRequest(identifier: waterReminderID.uuidString , content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
        
    }
    
    func getDateFromNotification( uuid: UUID, completion: @escaping (Date?) -> Void) {
        let center = UNUserNotificationCenter.current()
        center.getPendingNotificationRequests { requests in
            for request in requests {
                if let trigger = request.trigger as? UNCalendarNotificationTrigger,
                   let triggerUUID = UUID(uuidString: request.identifier),
                   triggerUUID == uuid {
                    completion(trigger.nextTriggerDate())
                    return
                }
            }
            completion(nil)
        }
    }
    
    func cancelReminderWithIdentifier(identifier : String) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notificationRequests) in
           var identifiers: [String] = []
           for notification:UNNotificationRequest in notificationRequests {
               if notification.identifier == identifier {
                  identifiers.append(notification.identifier)
               }
           }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }
    
    func removeDeliveredReminderWithIdentifier(identifier: String) {
        UNUserNotificationCenter.current().getDeliveredNotifications { notificationRequests in
            let matchingRequests = notificationRequests.filter { $0.request.identifier == identifier }
            let identifiers = matchingRequests.map { $0.request.identifier }
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: identifiers)
        }
    }

    
}

class ReminderManager: ObservableObject {
    @Published var wateringReminders: [WateringReminder] = []
    
    func fetchReminders(from store: Store) {
        do {
            self.wateringReminders = try store.fetchReminders()
        } catch {
        }
    }
}

struct ReminderView: View {
    @EnvironmentObject var store: Store
    @ObservedObject var reminderManager = ReminderManager()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(sortWateringReminders(), id: \.id) { reminder in
                    if let plantData = try? store.getPlant(WateringReminderWithrefId: Int64(reminder.refId)) {
                        ReminderBox(waterReminder: reminder, plantName: plantData.common_name, plantURL: plantData.smallThumbnail, nextWatering: reminder.nextWatering)
                            .padding(.bottom, 5)
                    }
                }
            }
        }
        .onAppear {
            NotificationManager.instance.requestAuthorization()
            UNUserNotificationCenter.current().setBadgeCount(0, withCompletionHandler: { error in
                if let error = error {
                    print("Error setting badge count: \(error)")
                }
            })
            reminderManager.fetchReminders(from: store)
        }
    }
    
    func sortWateringReminders() -> [WateringReminder] {
            reminderManager.wateringReminders.sorted {
                $0.nextWatering < $1.nextWatering
            }
        }
}

