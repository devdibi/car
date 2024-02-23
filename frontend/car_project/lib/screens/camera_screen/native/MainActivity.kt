import android.hardware.Camera

// 카메라의 회전 설정을 변경하는 함수
fun setCameraRotation(cameraId: Int, rotation: Int) {
    val cameraInfo = Camera.CameraInfo()
    Camera.getCameraInfo(cameraId, cameraInfo)
    val result = 0 // 가로로 고정
    camera!!.setDisplayOrientation(result)
}