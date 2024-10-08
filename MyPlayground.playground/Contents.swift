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

//----------------------------------------------------------------------------------------------------------------------------
//Struct Singleton
struct structSingleton {
    var isLoading = false
    
    @MainActor static var shared = structSingleton()
    
    private init() {}
}


var localCopy = structSingleton.shared
localCopy.isLoading = true //localCopy will only be affected as struct is a value type

print(structSingleton.shared.isLoading)// the value here will not be changed here, as only the copy of sharedinstance is changed and not the actual instance

structSingleton.shared.isLoading = true //changing sharedinstance directly
print(structSingleton.shared.isLoading)


//structSingleton.shared = structSingleton() // We should not do this as it will break the architecture and there should be only one instance of the shared instance throughout the application

//----------------------------------------------------------------------------------------------------------------------------
//class Singleton
final class classSingleton {
    var isLoading = false
    
    @MainActor static let shared = classSingleton()
    
    private init() {}
}


var localReference = classSingleton.shared
localReference.isLoading = true //localReference will be affected as class is a reference type

print(classSingleton.shared.isLoading)// the value here will be changed here,

classSingleton.shared.isLoading = true //changing sharedinstance directly
print(classSingleton.shared.isLoading)


//----------------------------------------------------------------------------------------------------------------------------
class EagerSingleton {
    @MainActor static let shared = EagerSingleton()
    
    private init() {
        // Initialization code here
    }
}



class LazySingleton {
    @MainActor static let shared: LazySingleton = {
        let instance = LazySingleton()
        // Additional setup if needed
        return instance
    }()
    
    private init() {
        // Initialization code here
    }
}
//----------------------------------------------------------------------------------------------------------------------------
//Protocol Abstraction
protocol DatabaseServiceProtocol {
    func fetchData() -> [String]
}

class DatabaseService: DatabaseServiceProtocol {
    func fetchData() -> [String] {
        // Real implementation
        return ["Data1", "Data2"]
    }
}

class DatabaseManager {
    @MainActor static let shared = DatabaseManager()
    private var dbService: DatabaseServiceProtocol?

    private init() {}

    func configure(with service: DatabaseServiceProtocol) {
        self.dbService = service
    }

    func fetchData() -> [String]? {
        return dbService?.fetchData()
    }
}


//Mock data for protocol Abstraction
class MockDatabaseService: DatabaseServiceProtocol {
    func fetchData() -> [String] {
        return ["MockData1", "MockData2"]
    }
}

// In your test case
@MainActor func testFetchData() {
    let mockService = MockDatabaseService()
    DatabaseManager.shared.configure(with: mockService)
    
    let data = DatabaseManager.shared.fetchData()
    //XCTAssertEqual(data, ["MockData1", "MockData2"])
}
