import SwiftUI

struct ContentView: View {
    @StateObject var budgetManager = BudgetManager(targetSpending: 0.0, averageSpending: 0.0, todaySpending: 0.0, totalSpending: 0.0, daysForTarget: 0, daysLeft: 0)

    var body: some View {
        VStack {
            
            Spacer(minLength: 100)
            
            Text("Welcome to Your Budget App!")
                .font(.title)
                .fontWeight(.bold)
                .padding()
            
            BudgetView(budgetManager: budgetManager)
                .padding()
        }
        .foregroundColor(.white)
        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .top, endPoint: .bottom))
        .edgesIgnoringSafeArea(.all)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
