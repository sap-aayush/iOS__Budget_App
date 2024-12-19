import Foundation

class BudgetManager: ObservableObject {
    @Published var targetSpending: Double
    @Published var averageSpending: Double
    @Published var todaySpending: Double
    @Published var totalSpending: Double
    @Published var elapsedDays: Int = 0
    @Published var daysForTarget: Int {
        didSet {
            if daysForTarget < 0 {
                daysForTarget = 0
            }
            recalculateAverageSpending()
            saveData()
        }
    }
    @Published var daysLeft: Int

    private var dayChangeTimer: Timer?
    private let userDefaultsKey = "BudgetManagerData"

    private var targetStartDate: Date? {
        didSet {
            // Calculate the elapsed days from the target start date to today
            if let startDate = targetStartDate {
                elapsedDays = Calendar.current.dateComponents([.day], from: startDate, to: Date()).day ?? 0
                let test = daysLeft
                daysLeft = max(daysForTarget - elapsedDays, 0)
                
                if(daysLeft != test){
                    todaySpending = 0.0
                }
                
                saveData()
            }
        }
    }

    init(targetSpending: Double, averageSpending: Double, todaySpending: Double, totalSpending: Double, daysForTarget: Int, daysLeft: Int) {
        self.targetSpending = targetSpending
        self.averageSpending = averageSpending
        self.todaySpending = todaySpending
        self.totalSpending = totalSpending
        self.daysForTarget = daysForTarget
        self.daysLeft = daysLeft

        loadStoredData()
    }

    private func loadStoredData() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let budgetData = try? JSONDecoder().decode(BudgetData.self, from: data) {
            targetSpending = budgetData.targetSpending
            averageSpending = budgetData.averageSpending
            todaySpending = budgetData.todaySpending
            totalSpending = budgetData.totalSpending
            daysForTarget = budgetData.daysForTarget
            targetStartDate = budgetData.targetStartDate
        } else {
            // If no data found in UserDefaults, initialize the values with defaults
            averageSpending = 0.0
            todaySpending = 0.0
            daysForTarget = 0
            targetStartDate = nil
        }
    }

    private func saveData() {
        let budgetData = BudgetData(targetSpending: targetSpending, averageSpending: averageSpending, todaySpending: todaySpending, totalSpending: totalSpending, daysForTarget: daysForTarget, targetStartDate: targetStartDate)
        if let encodedData = try? JSONEncoder().encode(budgetData) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
        }
    }

    func addSpending(_ amount: Double) {
        todaySpending += amount
        totalSpending += amount
        averageSpending = (targetSpending - totalSpending)/Double(daysLeft)
        saveData()
    }

    func setTarget(_ amount: Double) {
        totalSpending = 0.0
        targetSpending = amount
        targetStartDate = Date()// Save the current date as the target start date
        saveData()
    }

    func setDaysForTarget(_ days: Int) {
        daysForTarget = days
        saveData()
    }

    private func recalculateAverageSpending() {
        if daysLeft == 0 {
            averageSpending = 0.0
        } else {
            let totalDays = Double(daysLeft)
            averageSpending = (targetSpending - totalSpending) / totalDays
        }
    }

    func resetDailySpending() {
        todaySpending = 0.0
        saveData()
    }

}

// Helper struct to store BudgetManager data for encoding/decoding
struct BudgetData: Codable {
    let targetSpending: Double
    let averageSpending: Double
    let todaySpending: Double
    let totalSpending: Double
    let daysForTarget: Int
    let targetStartDate: Date?
}
