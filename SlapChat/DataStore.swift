

import Foundation
import CoreData

class DataStore {
    
    static let sharedInstance = DataStore()
    
    private init() {}
    
    var messages = [Message]() // this will hold fetched objects
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "slapChat")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func generateTestData(){
        //1. managedContext
        let managedContext = persistentContainer.viewContext
        //2. create an entity
        // START MESSAGE 1
        let entity = NSEntityDescription.entity(forEntityName: "Message", in: managedContext)
        //3. create a message
        guard let unwrappedEntity = entity else {return}
        let message1 = NSManagedObject(entity: unwrappedEntity, insertInto: managedContext) as! Message
        // END MESSAGE 1
        message1.content = "Joe"
        message1.createdAt = Date() as NSDate
        
        let message2 = Message(context: managedContext) // use this but know but know what is happening using the code above.
        message2.content = "Jim"
        message1.createdAt = NSDate()
        
        saveContext()
        fetchData()

    }
    
    
    func fetchData(){
        // 1. managedContext: an in-memory scratchpad that you use to work with your managed objects. 

        let managedContext = persistentContainer.viewContext
        // 2. fetchRequest
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        // Or use an alternative way ( THEY ARE THE SAME! )
        //let fetchTwo: NSFetchRequest<Message> = Message.fetchRequest()
        do {
            let fetchedMessages = try managedContext.fetch(fetchRequest)
            let sortedMessages = fetchedMessages.sorted(by: { (messageA, messageB) -> Bool in
                
                if let unwrappedDataA = messageA.createdAt, let unwrappedDataB = messageB.createdAt {
                    let dateA = unwrappedDataA as Date // *** changed to Swift type to use in code from Objective C
                    let dateB = unwrappedDataB as Date
                    return dateA > dateB
                }
                
                return false
            })
            
            self.messages = sortedMessages
            
            if sortedMessages.count == 0 {
                generateTestData()
            }
    
        } catch {
            
        }
        
    }
    
    func deleteAllMessages(){
        let managedContext = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Message> = Message.fetchRequest()
        
        do{
            let fetchedMessages = try managedContext.fetch(fetchRequest)
            for message in fetchedMessages {
                managedContext.delete(message)
            }
            self.messages = []
            saveContext()
        }catch {
            
        }
    }
    

    
}
