import CoreData
import RxSwift

extension NSManagedObjectContext {
    
    func rx_entities(_ query: NSFetchRequest<NSFetchRequestResult>) -> Observable<[NSManagedObject]> {
        return Observable.create { observer in
            let frc = NSFetchedResultsController(fetchRequest: query, managedObjectContext: self, sectionNameKeyPath: nil, cacheName: nil)
            
            let observerAdapter = FetchedResultsControllerEntityObserver(observer: observer, frc: frc)
            
            return Disposables.create {
                observerAdapter.dispose()
            }
        }
    }
    
}
