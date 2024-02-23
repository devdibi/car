import AVFoundation

// 카메라의 회전 설정을 변경하는 함수
func setCameraRotation(cameraId: String, rotation: Int) {
    guard let camera = AVCaptureDevice.default(for: .video) else { return }
    if let connection = camera.connection(with: .video) {
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = .landscapeRight // 가로로 고정
        }
    }
}
