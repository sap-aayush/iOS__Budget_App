import SwiftUI

struct BudgetView: View {
    @ObservedObject var budgetManager: BudgetManager
    @State private var spendingAmount = ""
    @State private var targetAmount = ""
    @State private var daysForTarget = ""
    @State private var keyboardOffset: CGFloat = 0

    var body: some View {
        VStack {
            Text("Your Budget")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .padding(.bottom, 20)

            VStack {
                HStack {
                    Text("Target:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Rs. \(budgetManager.targetSpending, specifier: "%.2f")")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))

                HStack {
                    Text("Days Left:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(budgetManager.daysLeft)")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))

                HStack {
                    Text("Average Spending:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Rs. \(budgetManager.averageSpending, specifier: "%.2f")")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))

                HStack {
                    Text("Today's Spending:")
                        .fontWeight(.bold)
                    Spacer()
                    Text("Rs. \(budgetManager.todaySpending, specifier: "%.2f")")
                }
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.5)))
            }
            .foregroundColor(.white)
            .padding(.horizontal)
            .padding(.vertical, 10)

            Spacer()

            VStack {
                TextField("Enter spending amount", text: $spendingAmount)
                    .padding(.horizontal)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.decimalPad)

                Button(action: {
                    if let amount = Double(spendingAmount) {
                        budgetManager.addSpending(amount)
                        spendingAmount = ""
                    }
                }) {
                    Text("Add Spending")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.vertical, 10)

                HStack {
                    TextField("Enter target amount", text: $targetAmount)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)

                    TextField("Enter days for target", text: $daysForTarget)
                        .padding(.horizontal)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                }
                .padding(.vertical, 10)

                Button(action: {
                    if let amount = Double(targetAmount), let days = Int(daysForTarget) {
                        budgetManager.setTarget(amount)
                        budgetManager.setDaysForTarget(days)
                        targetAmount = ""
                        daysForTarget = ""
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil) // Hide keyboard after setting the target and days
                    }
                }) {
                    Text("Set Target")
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, keyboardOffset)
            }
            .padding(.horizontal)
            .padding(.bottom, 30)
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.blue.opacity(0.2)))
            .onAppear {
                // Subscribe to keyboard notifications
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: .main) { notification in
                    let value = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
                    let height = value.height
                    self.keyboardOffset = height
                }
                NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: .main) { _ in
                    self.keyboardOffset = 0
                }
            }
            .onDisappear {
                // Unsubscribe from keyboard notifications
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
                NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
            }

            Spacer()
        }
        .padding()
        .onAppear {
            budgetManager.resetDailySpending()
        }
        .gesture(DragGesture().onChanged { _ in
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        })
        .onReceive(budgetManager.objectWillChange, perform: { _ in
            withAnimation {
                // Animate changes to budgetManager properties
            }
        })
    }
}
