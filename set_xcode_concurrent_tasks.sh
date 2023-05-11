defaults write com.apple.dt.xcodebuild PBXNumberOfParallelBuildSubtasks `sysctl -n hw.ncpu`
defaults write com.apple.dt.xcodebuild IDEBuildOperationMaxNumberOfConcurrentCompileTasks `sysctl -n hw.ncpu`
defaults write com.apple.dt.Xcode PBXNumberOfParallelBuildSubtasks `sysctl -n hw.ncpu`
defaults write com.apple.dt.Xcode IDEBuildOperationMaxNumberOfConcurrentCompileTasks `sysctl -n hw.ncpu`

