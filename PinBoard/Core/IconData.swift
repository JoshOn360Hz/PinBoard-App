import Foundation

struct IconDataProvider {
    static let iconCategories: [(name: String, icons: [String])] = [
        ("Default", [
            "note.text", "star.fill", "heart.fill", "flag.fill", "bookmark.fill", 
            "lightbulb.fill", "bell.fill", "tag.fill", "bolt.fill", "flame.fill"
        ]),
        ("Common", [
            "checkmark.circle.fill", "xmark.circle.fill", "exclamationmark.triangle.fill", 
            "info.circle.fill", "questionmark.circle.fill", "lock.fill", "key.fill",
            "doc.fill", "folder.fill", "tray.fill", "paperclip", "link", "square.and.pencil","dog.fill","cat.fill"
        ]),
        ("Time", [
            "calendar", "clock.fill", "timer", "stopwatch.fill", "alarm.fill", "hourglass"
        ]),
        ("Objects", [
            "pencil", "highlighter", "paintbrush.fill", "hammer.fill", "wrench.fill",
            "scissors", "ruler.fill", "envelope.fill", "gift.fill", "cart.fill", 
            "creditcard.fill", "banknote.fill", "bag.fill", "printer.fill"
        ]),
        ("Tech", [
            "desktopcomputer", "laptopcomputer", "iphone", "ipad", "keyboard",
            "tv.fill", "headphones", "gamecontroller.fill", "wifi", "antenna.radiowaves.left.and.right"
        ]),
        ("Media", [
            "music.note", "play.fill", "pause.fill", "stop.fill", "backward.fill", "forward.fill",
            "speaker.wave.3.fill", "mic.fill", "camera.fill", "video.fill", "photo.fill"
        ]),
        ("Transport", [
            "car.fill", "bus.fill", "tram.fill", "airplane", "bicycle",
            "scooter", "ferry.fill", "train.side.front.car", "sailboat.fill"
        ]),
        ("Nature", [
            "sun.max.fill", "moon.fill", "cloud.fill", "cloud.rain.fill",
            "snow", "wind", "leaf.fill", "tree.fill", "flame.fill"
        ]),
        ("Food", [
            "cup.and.saucer.fill", "fork.knife", "wineglass.fill", "birthday.cake.fill",
            "takeoutbag.and.cup.and.straw.fill", "carrot.fill", "fish.fill"
        ]),
        ("Activity", [
            "figure.walk", "figure.run", "figure.hiking", "figure.outdoor.cycle",
            "figure.gymnastics", "figure.yoga", "figure.cooldown", "heart.text.square.fill"
        ])
    ]
}
