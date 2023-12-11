import SwiftUI

struct markReminder: View {
    @EnvironmentObject
    var store: Store
    
    @Binding  var markPopUp: Bool
    @State var wateringReminder: WateringReminder

    var body: some View {
        VStack {
            if(wateringReminder.nextWatering < Date()){
                Button("Mark As Watered") {
                    markAsWatered()
                    markPopUp.toggle()
                }.padding(10)
                    .foregroundColor(.white)
                    .background(Color.green)
                    .cornerRadius(8)
                    .padding(.bottom, 22)
                    
            }else {
                Button("Mark As Watered") {
                    markAsWatered()
                    markPopUp.toggle()
                }.padding(10)
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(8)
                    .padding(.bottom, 22)
                    .disabled(true)
            }
            Button("Delete Reminder") {
                deleteReminder()
                markPopUp.toggle()
            }.padding(10)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
                .padding(.bottom, 22)
            
            Button("Cancel") {
                markPopUp.toggle()
            }.padding(10)
                .foregroundColor(.white)
                .background(Color.red)
                .cornerRadius(8)
                .padding(.bottom, 22)
        }
    }
    
    func markAsWatered(){
        NotificationManager.instance.removeDeliveredReminderWithIdentifier(identifier: wateringReminder.id.uuidString)
        if(wateringReminder.repeatWatering){
            NotificationManager.instance.getDateFromNotification(uuid: wateringReminder.id) { newDate in
                if let newDate = newDate {
                    do {
                        try store.updateWateringDate(newDate: newDate, for: wateringReminder.id)
                    } catch {
                        print("Error updating watering date: \(error)")
                    }
                } else {
                    print("Date is nil")
                }
            }
        } else{
            deleteReminder()
        }
    }
    
    func deleteReminder(){
        do{
            try store.delete(WateringReminderWithId: wateringReminder.id)
            NotificationManager.instance.cancelReminderWithIdentifier(identifier: wateringReminder.id.uuidString)
            }catch{
        }
        
    }
}
