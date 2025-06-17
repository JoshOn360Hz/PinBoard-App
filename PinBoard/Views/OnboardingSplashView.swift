import SwiftUI

struct OnboardingSplashView: View {
    @Binding var showOnboarding: Bool
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    private let pageCount = 3
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                welcomeView
                    .tag(0)
                
                liveActivitiesView
                    .tag(1)
                
                widgetsView
                    .tag(2)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            VStack {
                Spacer()
                
                Button(action: {
                    if currentPage < pageCount - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        hasCompletedOnboarding = true
                        showOnboarding = false
                    }
                }) {
                    Text(currentPage < pageCount - 1 ? "Continue" : "Get Started")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(height: 56)
                        .frame(width: UIScreen.main.bounds.width - 48)
                        .background(
                            RoundedRectangle(cornerRadius: 28)
                                .fill(Color(red: 0.4, green: 0.4, blue: 0.9))
                        )
                }
                .buttonStyle(PlainButtonStyle())
                .padding(.bottom, 34)
            }
        }
        .background(Color(UIColor.systemBackground))
    }
    
    
    var welcomeView: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Image("applogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
                .cornerRadius(30)
            
            Text("Welcome to PinBoard")
                .font(.system(size: 38, weight: .bold))
                .padding(.top, 20)
            
            Text("Quick notes. Redefined")
                .font(.title2)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            
            Spacer()
            
            Color.clear.frame(height: 100)
        }
        .padding()
    }
    
    var liveActivitiesView: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Image(systemName: "pin.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 85, height: 85)
                .foregroundColor(.orange)
                .padding(.bottom, 10)
            
            Text("Pin Notes to Dynamic Island")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 22) {
                featureRow(icon: "1.circle.fill", text: "Tap the pin icon on any note to pin it")
                featureRow(icon: "2.circle.fill", text: "Pinned notes appear in the Dynamic Island")
                featureRow(icon: "3.circle.fill", text: "Access your important note without opening the app")
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 220, height: 40)
                    .foregroundColor(.black)
                
                HStack {
                    Image(systemName: "note.text")
                        .foregroundColor(.blue)
                    Text("")
                        .foregroundColor(.white)
                        .font(.footnote)
                    Spacer()
                    Image(systemName: "pin.fill")
                        .foregroundColor(.blue)
                }
                .padding(.horizontal, 20)
                .frame(width: 220)
            }
            .padding(.vertical, 20)
            
            Color.clear.frame(height: 80)
        }
        .padding()
    }
    
    var widgetsView: some View {
        VStack(spacing: 25) {
            Spacer()
            
            Image(systemName: "rectangle.grid.1x2")
                .resizable()
                .scaledToFit()
                .frame(width: 85, height: 85)
                .foregroundColor(.green)
                .padding(.bottom, 10)
            
            Text("Add Notes to Home Screen")
                .font(.system(size: 32, weight: .bold))
                .multilineTextAlignment(.center)
            
            VStack(alignment: .leading, spacing: 22) {
                featureRow(icon: "1.circle.fill", text: "Pin a note to make it available in widgets")
                featureRow(icon: "2.circle.fill", text: "Long-press your home screen and add PinBoard widget")
                featureRow(icon: "3.circle.fill", text: "See your pinned note at a glance")
            }
            .padding(.horizontal, 20)
            .padding(.top, 10)
            
            Spacer()
            
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 300, height: 150)
                    .foregroundColor(Color(.systemGray6))
                
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        Text("Meeting Notes")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    
                    Text("Discuss project timeline and resources")
                        .foregroundColor(.secondary)
                        .padding(.top, 5)
                    
                    Spacer()
                }
                .padding()
                .frame(width: 300, height: 150, alignment: .leading)
            }
            .padding(.vertical, 20)
            
            Color.clear.frame(height: 80)
        }
        .padding()
    }
    
    func featureRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .font(.title3)
            
            Text(text)
                .foregroundColor(.primary)
        }
    }
}

#Preview {
    OnboardingSplashView(showOnboarding: .constant(true))
}
