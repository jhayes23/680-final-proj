import SwiftUI

struct CreateReminder: View {
    @EnvironmentObject var store: Store
    @Binding var showPopUp: Bool
    @State private var selectedInterval = 1
    @State private var selectedIntervalType = 0
    @State private var repeatWatering = false
    let intervalTypes = ["Days", "Weeks", "Months"]
    @State private var nextReminderDate: Date?
    @State var referenceId: Int
    
    var body: some View {
        VStack {
            Text("Create a Reminder to Water This Plant")
                .font(.headline)
                .padding()
            Picker("Interval", selection: $selectedIntervalType) {
                ForEach(intervalTypes.indices, id: \.self) { index in
                    Text(self.intervalTypes[index])
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            
            Stepper(value: $selectedInterval, in: 1...30) {
                Text("Every \(selectedInterval) \(intervalTypes[selectedIntervalType])")
            }
            .padding()
            Toggle("Repeat ", isOn: $repeatWatering)
            
            
            Button("Create Notification") {
                calculateNextReminderDate()
                addReminder()
                showPopUp.toggle()
            }
            .padding(10)
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(8)
            .padding(.bottom, 22)
            Button("Cancel") {
                showPopUp.toggle()
            }
            .padding(10)
            .foregroundColor(.white)
            .background(Color.red)
            .cornerRadius(8)
        }
    }
    
    func calculateNextReminderDate() {
        let calendar = Calendar.current
        var dateComponent = DateComponents()
        
                    switch selectedIntervalType {
                    case 0:
                        dateComponent.day = selectedInterval
                    case 1:
                        dateComponent.weekOfYear = selectedInterval
                    case 2:
                        dateComponent.month = selectedInterval
                    default:
                        break
                    }
        
                    if let getDate = calendar.date(byAdding: dateComponent, to: Date()) {
                        nextReminderDate = calendar.startOfDay(for: getDate)
        
                    }
    }
    
    func addReminder(){
        var dateComponent = DateComponents()
        
        NotificationManager.instance.requestAuthorization()
        let uniqueID = UUID()
        let item: WateringReminder = WateringReminder(id: uniqueID, refId: referenceId, nextWatering: nextReminderDate!, repeatWatering: repeatWatering )
        NotificationManager.instance.scheduleNotification(waterReminderID: uniqueID, date: nextReminderDate!, repeats: repeatWatering)
        
        do{
            try store.insert(item)
        } catch {
            
        }
    }
}
