import Foundation

var greeting = "Hello, playground"

struct Restaurant {
    
}

//Singletons are used where we access one source of data or one value, one shared instance will be there
//Singleton classes
final class RestaurantManager {
    @MainActor static let shared = RestaurantManager()
    
    
    private(set) var cachedRestaurants: [Restaurant] = []
    
    private var timeStamp: Date?
    
    private init() {}
    
    func getData(_ completion: @escaping([Restaurant]) -> Void)  {
        if let _ = timeStamp {
            print("Returning Cached Restaurants")
            completion(cachedRestaurants)
        } else {
            fetchDataFromServer(completion)
        }
    }
    
    private func fetchDataFromServer(_ completion: @escaping([Restaurant]) -> Void) {
        self.timeStamp = Date()
        print("Returning From Server")
        completion([])
    }
}

RestaurantManager.shared.getData { _ in
    print("Received items")
}

RestaurantManager.shared.getData { _ in
    print("Received items")
}


//Struct Singleton
struct structSingleton {
    var isLoading = false
    
    @MainActor static var shared = structSingleton()
}


var localCopy = structSingleton.shared
localCopy.isLoading = true //localCopy will only be affected as struct is a value type

print(structSingleton.shared.isLoading)// the value here will not be changed here, as only the copy of sharedinstance is changed and not the actual instance

structSingleton.shared.isLoading = true //changing sharedinstance directly
print(structSingleton.shared.isLoading)
