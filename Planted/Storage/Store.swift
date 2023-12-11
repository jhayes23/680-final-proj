import Foundation

import CoreData

extension PlantItem {
    init(_ entity: PlantItemEntity) throws {
        guard let id = entity.id else {
            throw StoreError.missingProperty
        }
        let refId = entity.refId
        guard let commonName = entity.commonName else {
            throw StoreError.missingProperty
        }
        guard let scientificName = entity.scientificName else {
            throw StoreError.missingProperty
        }
        guard let otherName = entity.otherName else {
            throw StoreError.missingProperty
        }
        guard let family = entity.plantFamily else {
            throw StoreError.missingProperty
        }
        guard let origin = entity.origin else {
            throw StoreError.missingProperty
        }
        guard let plantType = entity.plantType else {
            throw StoreError.missingProperty
        }
        guard let cycle = entity.cycle else {
            throw StoreError.missingProperty
        }
        guard let watering = entity.watering else {
            throw StoreError.missingProperty
        }
        guard let sunlight = entity.sunlight else {
            throw StoreError.missingProperty
        }
        guard let propagation = entity.propagation else {
            throw StoreError.missingProperty
        }
        guard let soil = entity.soil else {
            throw StoreError.missingProperty
        }
        guard let maintenence = entity.maintenence else {
            throw StoreError.missingProperty
        }
        guard let careLevel = entity.careLevel else {
            throw StoreError.missingProperty
        }
        guard let desc = entity.desc else {
            throw StoreError.missingProperty
        }
        guard let smallThumbnail = entity.smallThumbnail else {
            throw StoreError.missingProperty
        }
        guard let detailImage = entity.detailImage else {
            throw StoreError.missingProperty
        }
        self.init(id: id,
                  refId: Int(refId),
                  common_name: commonName,
                  scientific_name: scientificName,
                  other_name: otherName ,
                  plantFamily: family,
                  origin: origin,
                  plantType: plantType,
                  cycle: cycle,
                  watering: watering,
                  sunlight: sunlight ,
                  propagation: propagation ,
                  soil: soil ,
                  maintenance: maintenence,
                  careLevel: careLevel,
                  desc: desc,
                  smallThumbnail: smallThumbnail,
                  detailImage: detailImage
                  
        )
    }
    func entity(in context:  NSManagedObjectContext) {
        let entity = PlantItemEntity(context: context)
        
        entity.id = self.id
        entity.refId = Int64(self.refId)
        entity.commonName = self.common_name
        entity.scientificName = self.scientific_name
        entity.otherName = self.other_name
        entity.plantFamily = self.plantFamily
        entity.origin = self.origin
        entity.plantType = self.plantType
        entity.cycle = self.cycle
        entity.watering = self.watering
        entity.sunlight = self.sunlight
        entity.propagation = self.propagation
        entity.soil = self.soil
        entity.maintenence = self.maintenance
        entity.careLevel = self.careLevel
        entity.desc = self.desc
        entity.smallThumbnail = self.smallThumbnail
        entity.detailImage = self.detailImage
        
    }
    
    
}


enum StoreError: Error {
    case missingProperty
    case noEntityWithThatId
}

class Store: ObservableObject {
    
    private let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Planted")
        container.loadPersistentStores { description, maybeError in
            // - Migrations can prevent errors where a user has an incompatible database (you created a breaking change to your core data tables)
            print(description.url?.path(percentEncoded: false) ?? "")
        }
    }
    
    func insert(_ PlantItem: PlantItem) throws {
        let context = container.viewContext
        PlantItem.entity(in: context)
        try context.save()
    }
    
    func fetchPlantItems() throws -> [PlantItem] {
        let context = container.viewContext
        let request = PlantItemEntity.fetchRequest()
        let entities = try context.fetch(request)
        return try entities.map { entity in
            try PlantItem(entity)
        }
    }
    
    func getPlant(WateringReminderWithrefId refId: Int64) throws -> PlantItem? {
        let context = container.viewContext
        let request = NSFetchRequest<PlantItemEntity>(entityName: "PlantItemEntity")
        request.predicate = NSPredicate(format: "refId = %lld", refId)
        
        do {
            if let entity = try context.fetch(request).first {
                return try PlantItem(entity)
            }
        } catch {
            throw error
        }
        
        return nil
    }
    
    
    
    func insert(_ WateringReminder: WateringReminder) throws {
        let context = container.viewContext
        WateringReminder.entity(in: context)
        try context.save()
    }
    
    func fetchReminders() throws -> [WateringReminder] {
        let context = container.viewContext
        let request = WateringEntity.fetchRequest()
        let entities = try context.fetch(request)
        return try entities.map { entity in
            try WateringReminder(entity)
        }
    }
    
    func delete(WateringReminderWithId WateringReminderId: UUID) throws {
        let context = container.viewContext
        let request = WateringEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", WateringReminderId as CVarArg)
        request.fetchLimit = 1
        guard let entity = try context.fetch(request).first else {
            throw StoreError.noEntityWithThatId
        }
        context.delete(entity)
        try context.save()
    }
    
        func updateWateringDate(newDate: Date, for wateringId: UUID) throws {
            let context = container.viewContext
            let request = WateringEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id = %@", wateringId as CVarArg)
            request.fetchLimit = 1
            guard let entity = try context.fetch(request).first else {
                throw StoreError.noEntityWithThatId
            }
            entity.nextWatering = newDate
            try context.save()
        }
    
    func delete(plantItemWithId plantItemId: UUID) throws {
        let context = container.viewContext
        let request = PlantItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id = %@", plantItemId as CVarArg)
        request.fetchLimit = 1
        
        guard let entity = try context.fetch(request).first else {
            throw StoreError.noEntityWithThatId
        }
        
        context.delete(entity)
        try context.save()
    }
    
    func deleteWateringReminders(for plantrefId: Int) throws {
        let context = container.viewContext
        let request = NSFetchRequest<WateringEntity>(entityName: "WateringEntity")
        request.predicate = NSPredicate(format: "refId == %d", plantrefId)
        
        do {
            let remindersToDelete = try context.fetch(request)
            print(remindersToDelete.count)
            for reminder in remindersToDelete {
                context.delete(reminder)
            }
            try context.save()
        } catch {
            throw error
        }
    }
}


extension WateringReminder {
    init(_ entity: WateringEntity) throws {
        let refId = entity.refId

        guard let id = entity.id else {
            throw StoreError.missingProperty
        }
        guard let nextWatering = entity.nextWatering else {
            throw StoreError.missingProperty
        }
         let repeatWatering = entity.repeatWatering

        self.init(id: id, refId: Int(refId), nextWatering: nextWatering, repeatWatering: repeatWatering)
    }

    func entity(in context: NSManagedObjectContext) {
        let entity = WateringEntity(context: context)

            entity.id = self.id
            entity.refId = Int64(self.refId)
            entity.nextWatering = self.nextWatering
        
    }
}
