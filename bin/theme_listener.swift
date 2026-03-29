import Cocoa
import Foundation

func currentMode() -> String {
    let style = UserDefaults(suiteName: ".GlobalPreferences")?.string(forKey: "AppleInterfaceStyle")
    return style == "Dark" ? "dark" : "light"
}

func runSwapScript(mode: String) {
    let binDir = URL(fileURLWithPath: CommandLine.arguments[0])
        .resolvingSymlinksInPath()
        .deletingLastPathComponent()
        .path
    let script = "\(binDir)/swap_mode.sh"

    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/bash")
    process.arguments = [script, mode]
    var env = ProcessInfo.processInfo.environment
    let brewPaths = "/opt/homebrew/opt/gnu-sed/libexec/gnubin/:/opt/homebrew/bin:/usr/local/bin"
    env["PATH"] = "\(brewPaths):\(env["PATH"] ?? "/usr/bin:/bin:/usr/sbin:/sbin")"
    process.environment = env
    DispatchQueue.global().async {
        do {
            try process.run()
            process.waitUntilExit()
        } catch {
            fputs("theme_listener: failed to run swap_mode.sh: \(error)\n", stderr)
        }
    }
}

// Sync to current state on startup
let initial = currentMode()
print("theme_listener: startup mode = \(initial)")
runSwapScript(mode: initial)

// Listen for system theme changes
DistributedNotificationCenter.default().addObserver(
    forName: Notification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil,
    queue: .main
) { _ in
    // Brief delay so UserDefaults reflects the new value
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
        let mode = currentMode()
        print("theme_listener: changed to \(mode)")
        runSwapScript(mode: mode)
    }
}

RunLoop.main.run()
