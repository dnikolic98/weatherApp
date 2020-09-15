import RxSwift
import CoreData

class FetchedResultsControllerEntityObserver: NSObject, NSFetchedResultsControllerDelegate, Disposable {
    
    typealias Observer = AnyObserver<[NSManagedObject]>
    
    let observer: Observer
    let frc: NSFetchedResultsController<NSFetchRequestResult>
    
    init(observer: Observer, frc: NSFetchedResultsController<NSFetchRequestResult>) {
        self.observer = observer
        self.frc = frc
        
        super.init()
        
        self.frc.delegate = self
        
        do {
            try self.frc.performFetch()
        } catch let error as NSError {
            observer.onError(error)
        }
        
        sendNextElement()
    }
    
    func sendNextElement() {
        let entities = frc.fetchedObjects as! [NSManagedObject]
        observer.onNext(entities)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        sendNextElement()
    }
    
    func dispose() {
        frc.delegate = nil
    }
    
}
