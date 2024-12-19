import Foundation

struct DailySpending: Codable, Identifiable {
    var id = UUID() // Unique identifier for each instance
    var date: Date // Date for the spending record
    var amount: Double // Amount spent on the date

    // Custom initializer to create DailySpending instances with date and amount
    init(date: Date, amount: Double) {
        self.date = date
        self.amount = amount
    }
}
