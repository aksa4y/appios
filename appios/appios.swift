import SwiftUI

@main
struct MoveApp: App {
    @AppStorage("move.didOnboard") private var didOnboard = false

    var body: some Scene {
        WindowGroup {
            Group {
                if didOnboard {
                    MainTabView()
                } else {
                    OnboardingView { didOnboard = true }
                }
            }
            .preferredColorScheme(.dark)
            .tint(.moveLime)
        }
    }
}

// MARK: - Design system

extension Color {
    static let moveLime = Color(red: 0.78, green: 0.96, blue: 0.22)
    static let moveBlack = Color(red: 0.035, green: 0.04, blue: 0.035)
    static let moveCard = Color(red: 0.09, green: 0.095, blue: 0.085)
    static let moveMuted = Color(red: 0.62, green: 0.64, blue: 0.60)
    static let moveCream = Color(red: 0.91, green: 0.91, blue: 0.82)
}

enum ActivityCategory: String, CaseIterable, Identifiable {
    case all = "Все"
    case running = "Бег"
    case gym = "Зал"
    case yoga = "Йога"
    case cycling = "Велосипед"

    var id: String { rawValue }
    var symbol: String {
        switch self {
        case .all: "sparkles"
        case .running: "figure.run"
        case .gym: "dumbbell.fill"
        case .yoga: "figure.yoga"
        case .cycling: "bicycle"
        }
    }
}

struct Activity: Identifiable, Hashable {
    let id: String
    let title: String
    let venue: String
    let category: ActivityCategory
    let symbol: String
    let date: String
    let time: String
    let distance: String
    let difficulty: String
    let duration: String
    let people: Int
    let description: String
    let limeArtwork: Bool

    static let samples: [Activity] = [
        Activity(id: "run", title: "Утренний забег", venue: "Парк у реки", category: .running, symbol: "figure.run", date: "Сб, 12 июля", time: "7:00", distance: "5 км", difficulty: "Легко", duration: "30 мин", people: 127, description: "Спокойный групповой забег, чтобы начать день с хорошей энергией. Подходит для любого уровня подготовки.", limeArtwork: true),
        Activity(id: "yoga", title: "Поток йоги", venue: "Студия «Точка»", category: .yoga, symbol: "figure.yoga", date: "Вс, 13 июля", time: "9:30", distance: "45 мин", difficulty: "Легко", duration: "45 мин", people: 89, description: "Мягкая практика на дыхание, мобильность и восстановление. Возьми коврик и приходи без спешки.", limeArtwork: false),
        Activity(id: "strength", title: "Силовая тренировка", venue: "Core Club", category: .gym, symbol: "dumbbell.fill", date: "Пн, 14 июля", time: "18:00", distance: "Все тело", difficulty: "Средне", duration: "50 мин", people: 64, description: "Базовые упражнения и понятный темп. Тренер поможет подобрать нагрузку под твой уровень.", limeArtwork: false),
        Activity(id: "ride", title: "Велопрогулка", venue: "Городской маршрут", category: .cycling, symbol: "bicycle", date: "Вт, 15 июля", time: "19:00", distance: "12 км", difficulty: "Средне", duration: "55 мин", people: 92, description: "Едем по тихим улицам и набережной. Нужен исправный велосипед и шлем.", limeArtwork: true)
    ]
}

enum MoveTab: String, CaseIterable {
    case explore = "Обзор"
    case schedule = "План"
    case progress = "Прогресс"
    case profile = "Профиль"

    var symbol: String {
        switch self {
        case .explore: "sparkle.magnifyingglass"
        case .schedule: "calendar"
        case .progress: "chart.bar.xaxis"
        case .profile: "person.crop.circle"
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab: MoveTab = .explore

    var body: some View {
        TabView(selection: $selectedTab) {
            ExploreView().tabItem { Label(MoveTab.explore.rawValue, systemImage: MoveTab.explore.symbol) }.tag(MoveTab.explore)
            ScheduleView().tabItem { Label(MoveTab.schedule.rawValue, systemImage: MoveTab.schedule.symbol) }.tag(MoveTab.schedule)
            ProgressDashboardView().tabItem { Label(MoveTab.progress.rawValue, systemImage: MoveTab.progress.symbol) }.tag(MoveTab.progress)
            ProfileView().tabItem { Label(MoveTab.profile.rawValue, systemImage: MoveTab.profile.symbol) }.tag(MoveTab.profile)
        }
        .tint(.moveLime)
        .toolbarBackground(.visible, for: .tabBar)
        .toolbarBackground(Color.moveBlack, for: .tabBar)
    }
}

// MARK: - Onboarding

struct OnboardingView: View {
    let onContinue: () -> Void

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Color.moveBlack.ignoresSafeArea()
                VStack(alignment: .leading, spacing: 0) {
                    HStack(alignment: .top) {
                        Text("Маленькие\nшаги.\nБольшие\nперемены.")
                            .font(.system(size: 18, weight: .medium, design: .rounded))
                            .foregroundStyle(.white)
                        Spacer()
                        Text("КАЖДЫЙ\nДЕНЬ")
                            .font(.system(size: 13, weight: .black, design: .rounded))
                            .tracking(1.5)
                            .foregroundStyle(.black)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 22)
                            .background(.moveLime, in: Capsule())
                            .rotationEffect(.degrees(12))
                    }
                    .padding(.top, 18)

                    ZStack {
                        Circle().fill(Color.moveLime).frame(width: proxy.size.width * 0.82)
                            .overlay(alignment: .topTrailing) {
                                Text("ДВИГАЙСЯ В СВОЁМ РИТМЕ")
                                    .font(.system(size: 12, weight: .heavy, design: .rounded))
                                    .tracking(2)
                                    .foregroundStyle(.black)
                                    .rotationEffect(.degrees(50))
                                    .offset(x: 10, y: 42)
                            }
                        Circle().stroke(Color.moveBlack, lineWidth: 30)
                            .frame(width: proxy.size.width * 0.54)
                            .rotationEffect(.degrees(-30))
                        Image(systemName: "figure.run")
                            .resizable().scaledToFit()
                            .foregroundStyle(Color.moveBlack)
                            .frame(width: proxy.size.width * 0.56, height: proxy.size.height * 0.34)
                            .rotationEffect(.degrees(-9))
                            .offset(x: -8, y: 18)
                        Image(systemName: "sparkle")
                            .font(.system(size: 30, weight: .bold)).foregroundStyle(.black)
                            .offset(x: -proxy.size.width * 0.27, y: -proxy.size.height * 0.17)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: proxy.size.height * 0.43)
                    .padding(.vertical, 18)

                    Spacer(minLength: 8)
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Найди свой\nследующий шаг")
                            .font(.system(size: 39, weight: .black, design: .rounded))
                            .tracking(-1.4)
                            .lineSpacing(-4)
                            .foregroundStyle(.white)
                        Text("Открывай активности рядом и двигайся к своим целям — по одному шагу за раз.")
                            .font(.system(size: 16))
                            .foregroundStyle(.moveMuted)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(.bottom, 24)

                    Button(action: onContinue) {
                        HStack {
                            Spacer()
                            Text("Начать")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                            Image(systemName: "arrow.right").font(.system(size: 16, weight: .bold))
                            Spacer()
                        }
                        .foregroundStyle(.black)
                        .padding(.vertical, 18)
                        .background(.moveLime, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityHint("Открывает подборку активностей")
                    .padding(.bottom, 12)
                }
                .padding(.horizontal, 25)
            }
        }
    }
}

// MARK: - Explore

struct ExploreView: View {
    @AppStorage("move.joinedActivities") private var joinedRaw = ""
    @State private var category: ActivityCategory = .all
    @State private var selectedActivity: Activity?

    private var joined: Set<String> {
        Set(joinedRaw.split(separator: ",").map(String.init))
    }
    private var visibleActivities: [Activity] {
        category == .all ? Activity.samples : Activity.samples.filter { $0.category == category }
    }

    private let columns = [GridItem(.flexible(), spacing: 12), GridItem(.flexible(), spacing: 12)]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    Text("Найди свой\nследующий шаг")
                        .font(.system(size: 35, weight: .black, design: .rounded))
                        .tracking(-1.1)
                        .lineSpacing(-4)
                        .foregroundStyle(.white)
                    categoryPicker
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(visibleActivities) { activity in
                            Button { selectedActivity = activity } label: {
                                ActivityCard(activity: activity, joined: joined.contains(activity.id))
                            }
                            .buttonStyle(.plain)
                            .accessibilityLabel("\(activity.title), \(activity.venue), \(activity.people) участников")
                        }
                    }
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Сильнее")
                                .font(.system(size: 17, weight: .semibold, design: .rounded))
                            Text("каждый день")
                                .font(.system(size: 24, weight: .black, design: .rounded))
                                .foregroundStyle(.moveLime)
                        }
                        Spacer()
                        Text("ДОБРАЯ\nПРИВЫЧКА")
                            .font(.system(size: 11, weight: .bold, design: .rounded))
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(.moveMuted)
                    }
                    .padding(.top, 4)
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 28)
            }
            .background(Color.moveBlack)
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(item: $selectedActivity) { activity in
                ActivityDetailView(activity: activity)
            }
        }
    }

    private var header: some View {
        HStack {
            HStack(spacing: 7) {
                Circle().fill(.moveLime).frame(width: 9, height: 9)
                Text("MOVE").font(.system(size: 15, weight: .black, design: .rounded)).tracking(2.2)
            }
            Spacer()
            Button {} label: {
                Image(systemName: "location.fill")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(.moveLime)
                    .padding(11)
                    .background(Color.moveCard, in: Circle())
            }
            .accessibilityLabel("Моё местоположение")
        }
    }

    private var categoryPicker: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(ActivityCategory.allCases) { item in
                    Button { category = item } label: {
                        HStack(spacing: 6) {
                            if item == .all { Image(systemName: item.symbol).font(.system(size: 11, weight: .bold)) }
                            Text(item.rawValue).font(.system(size: 14, weight: .semibold, design: .rounded))
                        }
                        .foregroundStyle(category == item ? .black : .white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 10)
                        .background(category == item ? Color.moveLime : Color.moveCard, in: Capsule())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

struct ActivityCard: View {
    let activity: Activity
    let joined: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ActivityArtwork(activity: activity)
                .frame(height: 138)
                .overlay(alignment: .topTrailing) {
                    if joined {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .black))
                            .foregroundStyle(.black)
                            .padding(8)
                            .background(.moveLime, in: Circle())
                            .padding(9)
                    }
                }
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title)
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .foregroundStyle(.primary)
                Text(activity.venue)
                    .font(.system(size: 12))
                    .lineLimit(1)
                    .foregroundStyle(.secondary)
                HStack(spacing: 5) {
                    AvatarStack()
                    Text("+\(activity.people)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(.secondary)
                    Spacer(minLength: 2)
                    Image(systemName: "arrow.up.right")
                        .font(.system(size: 12, weight: .black))
                        .foregroundStyle(activity.limeArtwork ? .moveLime : .black)
                        .frame(width: 30, height: 30)
                        .background(activity.limeArtwork ? Color.black : Color.moveLime, in: Circle())
                }
                .padding(.top, 7)
            }
            .padding(.horizontal, 11)
            .padding(.top, 10)
            .padding(.bottom, 11)
        }
        .background(activity.limeArtwork ? Color.moveLime : Color.moveCream, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .foregroundStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct ActivityArtwork: View {
    let activity: Activity

    var body: some View {
        ZStack {
            (activity.limeArtwork ? Color.moveLime : Color.moveCream)
            Circle().fill(Color.black.opacity(0.07))
                .frame(width: 130, height: 130)
                .offset(x: 53, y: -51)
            Circle().stroke(Color.black.opacity(0.11), lineWidth: 1)
                .frame(width: 155, height: 155)
                .offset(x: 48, y: -47)
            Image(systemName: activity.symbol)
                .resizable()
                .scaledToFit()
                .foregroundStyle(Color.black)
                .frame(width: activity.category == .running ? 100 : 86, height: 105)
                .rotationEffect(.degrees(activity.category == .yoga ? -8 : 0))
                .offset(x: 9, y: 10)
            Text(activity.category == .running ? "RUN" : activity.category.rawValue.uppercased())
                .font(.system(size: 10, weight: .black, design: .rounded))
                .tracking(2)
                .foregroundStyle(.black.opacity(0.6))
                .rotationEffect(.degrees(-90))
                .offset(x: -68, y: 1)
            Image(systemName: "sparkle")
                .font(.system(size: 19, weight: .black))
                .foregroundStyle(.black)
                .offset(x: -43, y: -37)
        }
        .clipped()
        .accessibilityHidden(true)
    }
}

struct AvatarStack: View {
    private let colors: [Color] = [.moveBlack, .gray, .moveMuted]
    var body: some View {
        HStack(spacing: -7) {
            ForEach(colors.indices, id: \.self) { index in
                Circle()
                    .fill(colors[index])
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(.white.opacity(0.88))
                    }
                    .frame(width: 23, height: 23)
                    .overlay(Circle().stroke(Color.white, lineWidth: 1.5))
            }
        }
        .accessibilityHidden(true)
    }
}

// MARK: - Activity detail

struct ActivityDetailView: View {
    let activity: Activity
    @AppStorage("move.joinedActivities") private var joinedRaw = ""
    @Environment(\.dismiss) private var dismiss
    @State private var isSaved = false

    private var joined: Bool { joinedRaw.split(separator: ",").contains(Substring(activity.id)) }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 0) {
                ZStack(alignment: .top) {
                    ActivityArtwork(activity: activity)
                        .frame(height: 390)
                        .overlay {
                            LinearGradient(colors: [.black.opacity(0.2), .clear, .black.opacity(0.42)], startPoint: .top, endPoint: .bottom)
                        }
                    HStack {
                        CircleIconButton(symbol: "chevron.left", label: "Назад") { dismiss() }
                        Spacer()
                        CircleIconButton(symbol: isSaved ? "bookmark.fill" : "bookmark", label: isSaved ? "Убрать из сохранённого" : "Сохранить") {
                            isSaved.toggle()
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 12)
                    VStack {
                        Spacer()
                        HStack {
                            Image(systemName: "sparkles").foregroundStyle(.moveLime)
                            Text("ДВИЖЕНИЕ РЯДОМ")
                                .font(.system(size: 11, weight: .black, design: .rounded))
                                .tracking(2)
                                .foregroundStyle(.white)
                            Spacer()
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 24)
                    }
                }

                VStack(alignment: .leading, spacing: 20) {
                    HStack(alignment: .top, spacing: 12) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text(activity.title)
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .tracking(-0.7)
                            Text(activity.venue).font(.system(size: 16)).foregroundStyle(.moveMuted)
                        }
                        Spacer()
                        VStack(spacing: 3) {
                            Text(activity.date.components(separatedBy: ",").first ?? "Сб")
                                .font(.system(size: 13, weight: .bold, design: .rounded))
                            Text(activity.time)
                                .font(.system(size: 15, weight: .black, design: .rounded))
                        }
                        .foregroundStyle(.black)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 12)
                        .background(.moveLime, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                    }
                    HStack(spacing: 8) {
                        AvatarStack()
                        Text("+\(activity.people) идут")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.moveMuted)
                        Spacer()
                    }
                    HStack(spacing: 0) {
                        MetricCell(value: activity.distance, label: activity.category == .running ? "Дистанция" : "Формат")
                        Divider().overlay(.white.opacity(0.2)).frame(height: 35)
                        MetricCell(value: activity.difficulty, label: "Уровень")
                        Divider().overlay(.white.opacity(0.2)).frame(height: 35)
                        MetricCell(value: activity.duration, label: "Длительность")
                    }
                    .padding(.vertical, 16)
                    .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 17, style: .continuous))
                    Text(activity.description)
                        .font(.system(size: 15))
                        .foregroundStyle(.moveMuted)
                        .lineSpacing(4)
                    Button(action: toggleJoin) {
                        HStack(spacing: 9) {
                            Text(joined ? "Ты идёшь" : "Присоединиться")
                                .font(.system(size: 17, weight: .bold, design: .rounded))
                            Image(systemName: joined ? "checkmark" : "arrow.right")
                                .font(.system(size: 15, weight: .black))
                        }
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 17)
                        .background(joined ? Color.moveCream : Color.moveLime, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                    .buttonStyle(.plain)
                }
                .padding(22)
                .background(Color.moveBlack)
                .offset(y: -18)
            }
        }
        .background(Color.moveBlack)
        .ignoresSafeArea(edges: .top)
        .toolbar(.hidden, for: .navigationBar)
    }

    private func toggleJoin() {
        var ids = Set(joinedRaw.split(separator: ",").map(String.init))
        if ids.contains(activity.id) { ids.remove(activity.id) } else { ids.insert(activity.id) }
        joinedRaw = ids.sorted().joined(separator: ",")
    }
}

struct CircleIconButton: View {
    let symbol: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 15, weight: .bold))
                .foregroundStyle(.white)
                .frame(width: 42, height: 42)
                .background(.black.opacity(0.68), in: Circle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }
}

struct MetricCell: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 5) {
            Text(value).font(.system(size: 14, weight: .bold, design: .rounded)).lineLimit(1).minimumScaleFactor(0.8)
            Text(label).font(.system(size: 11)).foregroundStyle(.moveMuted)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Schedule

struct ScheduleView: View {
    @AppStorage("move.joinedActivities") private var joinedRaw = ""
    @State private var selectedDate = 12

    private var joinedActivities: [Activity] {
        let ids = Set(joinedRaw.split(separator: ",").map(String.init))
        return Activity.samples.filter { ids.contains($0.id) }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text("Твой план")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .tracking(-1)
                    HStack {
                        ForEach(10..<17, id: \.self) { day in
                            Button { selectedDate = day } label: {
                                VStack(spacing: 8) {
                                    Text(["ПН","ВТ","СР","ЧТ","ПТ","СБ","ВС"][day - 10])
                                        .font(.system(size: 10, weight: .bold))
                                        .foregroundStyle(.moveMuted)
                                    Text("\(day)")
                                        .font(.system(size: 15, weight: .bold, design: .rounded))
                                        .foregroundStyle(selectedDate == day ? .black : .white)
                                        .frame(width: 38, height: 38)
                                        .background(selectedDate == day ? Color.moveLime : Color.clear, in: Circle())
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    HStack {
                        Text("СУББОТА, 12 ИЮЛЯ").font(.system(size: 12, weight: .bold, design: .rounded)).tracking(1.3)
                        Spacer()
                        Text("\(joinedActivities.count) событий").font(.system(size: 12)).foregroundStyle(.moveMuted)
                    }
                    if joinedActivities.isEmpty {
                        EmptyScheduleCard()
                    } else {
                        ForEach(joinedActivities) { activity in
                            NavigationLink(value: activity) {
                                ScheduleActivityRow(activity: activity)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    Text("Можно присоединиться").font(.system(size: 20, weight: .bold, design: .rounded))
                    ForEach(Activity.samples.filter { !joinedActivities.contains($0) }.prefix(3)) { activity in
                        NavigationLink(value: activity) {
                            ScheduleActivityRow(activity: activity)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(20)
            }
            .background(Color.moveBlack)
            .navigationDestination(for: Activity.self) { ActivityDetailView(activity: $0) }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct EmptyScheduleCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 11) {
            Image(systemName: "calendar.badge.plus").font(.system(size: 27, weight: .medium)).foregroundStyle(.moveLime)
            Text("Пока план свободен").font(.system(size: 18, weight: .bold, design: .rounded))
            Text("Выбери активность и присоединись — она появится здесь.")
                .font(.system(size: 14)).foregroundStyle(.moveMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct ScheduleActivityRow: View {
    let activity: Activity
    var body: some View {
        HStack(spacing: 13) {
            RoundedRectangle(cornerRadius: 13)
                .fill(.moveLime)
                .frame(width: 54, height: 54)
                .overlay(Image(systemName: activity.symbol).font(.system(size: 22, weight: .bold)).foregroundStyle(.black))
            VStack(alignment: .leading, spacing: 4) {
                Text(activity.title).font(.system(size: 16, weight: .bold, design: .rounded)).foregroundStyle(.white)
                Text("\(activity.venue) · \(activity.time)").font(.system(size: 12)).foregroundStyle(.moveMuted)
            }
            Spacer()
            Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold)).foregroundStyle(.moveMuted)
        }
        .padding(12)
        .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

// MARK: - Progress

struct ProgressDashboardView: View {
    private let bars: [CGFloat] = [0.34, 0.58, 0.43, 0.82, 0.55, 1.0, 0.27]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Text("Твой прогресс")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .tracking(-1)
                    HStack(spacing: 12) {
                        ProgressStat(value: "4", label: "активности", icon: "figure.mixed.cardio")
                        ProgressStat(value: "2 ч 40", label: "в движении", icon: "clock")
                    }
                    VStack(alignment: .leading, spacing: 19) {
                        HStack {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Эта неделя").font(.system(size: 19, weight: .bold, design: .rounded))
                                Text("Ты набираешь темп").font(.system(size: 13)).foregroundStyle(.moveMuted)
                            }
                            Spacer()
                            Text("12,4 км").font(.system(size: 15, weight: .bold, design: .rounded)).foregroundStyle(.moveLime)
                        }
                        HStack(alignment: .bottom, spacing: 10) {
                            ForEach(bars.indices, id: \.self) { index in
                                VStack(spacing: 8) {
                                    RoundedRectangle(cornerRadius: 7)
                                        .fill(index == 5 ? Color.moveLime : Color.moveLime.opacity(0.27))
                                        .frame(height: 108 * bars[index])
                                    Text(["ПН","ВТ","СР","ЧТ","ПТ","СБ","ВС"][index])
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(.moveMuted)
                                }
                                .frame(maxWidth: .infinity)
                            }
                        }
                        .frame(height: 140, alignment: .bottom)
                    }
                    .padding(18)
                    .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
                    VStack(alignment: .leading, spacing: 13) {
                        Text("Твои достижения").font(.system(size: 20, weight: .bold, design: .rounded))
                        AchievementRow(symbol: "flame.fill", title: "Первый шаг", detail: "Первая активность уже позади", unlocked: true)
                        AchievementRow(symbol: "calendar", title: "Ритм недели", detail: "3 активных дня за неделю", unlocked: true)
                        AchievementRow(symbol: "bolt.fill", title: "На одном дыхании", detail: "5 активностей за неделю", unlocked: false)
                    }
                }
                .padding(20)
            }
            .background(Color.moveBlack)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ProgressStat: View {
    let value: String
    let label: String
    let icon: String
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Image(systemName: icon).foregroundStyle(.moveLime)
            Text(value).font(.system(size: 25, weight: .black, design: .rounded))
            Text(label).font(.system(size: 12)).foregroundStyle(.moveMuted)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(17)
        .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
    }
}

struct AchievementRow: View {
    let symbol: String
    let title: String
    let detail: String
    let unlocked: Bool

    var body: some View {
        HStack(spacing: 13) {
            Image(systemName: symbol)
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(unlocked ? Color.moveLime : Color.moveMuted)
                .frame(width: 44, height: 44)
                .background(Color.white.opacity(0.06), in: RoundedRectangle(cornerRadius: 14))
            VStack(alignment: .leading, spacing: 3) {
                Text(title).font(.system(size: 15, weight: .bold, design: .rounded))
                Text(detail).font(.system(size: 12)).foregroundStyle(.moveMuted)
            }
            Spacer()
            if unlocked { Image(systemName: "checkmark.seal.fill").foregroundStyle(.moveLime) }
        }
        .padding(12)
        .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

// MARK: - Profile

struct ProfileView: View {
    @AppStorage("move.didOnboard") private var didOnboard = true
    @AppStorage("move.joinedActivities") private var joinedRaw = ""
    @State private var notificationsEnabled = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 22) {
                    VStack(spacing: 13) {
                        ZStack {
                            Circle().fill(.moveLime).frame(width: 94, height: 94)
                            Image(systemName: "person.fill").font(.system(size: 43, weight: .medium)).foregroundStyle(.black)
                        }
                        Text("Привет, Алекс!").font(.system(size: 25, weight: .black, design: .rounded))
                        Text("Каждый шаг имеет значение").font(.system(size: 14)).foregroundStyle(.moveMuted)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 28)
                    .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
                    VStack(spacing: 0) {
                        ProfileSettingRow(symbol: "bell.badge", title: "Напоминания") {
                            Toggle("Напоминания", isOn: $notificationsEnabled).labelsHidden().tint(.moveLime)
                        }
                        Divider().overlay(.white.opacity(0.08))
                        ProfileSettingRow(symbol: "bookmark", title: "Сохранённые активности") {
                            Text("0").font(.system(size: 14)).foregroundStyle(.moveMuted)
                        }
                        Divider().overlay(.white.opacity(0.08))
                        ProfileSettingRow(symbol: "hand.raised", title: "Конфиденциальность") {
                            Image(systemName: "chevron.right").font(.system(size: 12, weight: .bold)).foregroundStyle(.moveMuted)
                        }
                    }
                    .padding(.horizontal, 15)
                    .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
                    Button(role: .destructive) {
                        joinedRaw = ""
                        didOnboard = false
                    } label: {
                        Text("Сбросить демо-данные")
                            .font(.system(size: 14, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .padding(15)
                            .background(Color.moveCard, in: RoundedRectangle(cornerRadius: 15))
                    }
                    .tint(.moveMuted)
                }
                .padding(20)
            }
            .background(Color.moveBlack)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

struct ProfileSettingRow<Accessory: View>: View {
    let symbol: String
    let title: String
    @ViewBuilder let accessory: Accessory

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: symbol).font(.system(size: 16, weight: .semibold)).foregroundStyle(.moveLime).frame(width: 25)
            Text(title).font(.system(size: 15, weight: .medium))
            Spacer()
            accessory
        }
        .padding(.vertical, 15)
    }
}
