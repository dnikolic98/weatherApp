//
//  NSPredicate+Extensions.swift
//  weatherApp
//
//  Created by Dario Nikolic on 27/08/2020.
//  Copyright © 2020 Dario Nikolic. All rights reserved.
//

import Foundation

extension NSPredicate {
    
    func and(_ predicate: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(andPredicateWithSubpredicates: [self, predicate])
    }
    
    func or(_ predicate: NSPredicate) -> NSPredicate {
        return NSCompoundPredicate(orPredicateWithSubpredicates: [self, predicate])
    }
    
}
