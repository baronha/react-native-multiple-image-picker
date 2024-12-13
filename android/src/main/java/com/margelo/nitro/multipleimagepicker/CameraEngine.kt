package com.margelo.nitro.multipleimagepicker

import android.content.Context
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.luck.lib.camerax.SimpleCameraX
import com.luck.picture.lib.interfaces.OnCameraInterceptListener
import java.io.File

class CameraEngine(private val appContext: Context, val config: PickerCameraConfig) : OnCameraInterceptListener {
    override fun openCamera(fragment: Fragment, cameraMode: Int, requestCode: Int) {
        val camera = SimpleCameraX.of()
        camera.isAutoRotation(true)
        camera.setCameraMode(cameraMode)
        camera.isDisplayRecordChangeTime(true)
        camera.isManualFocusCameraPreview(true)
        camera.isZoomCameraPreview(true)
        camera.setOutputPathDir(getSandboxCameraOutputPath())
        camera.setRecordVideoMaxSecond(config.videoMaximumDuration?.toInt() ?: 60)

//        camera.setPermissionDeniedListener(getSimpleXPermissionDeniedListener())
//        camera.setPermissionDescriptionListener(getSimpleXPermissionDescriptionListener())
        camera.setImageEngine { context, url, imageView ->
            Glide.with(context).load(url).into(imageView)
        }
        camera.start(fragment.requireActivity(), fragment, requestCode)
    }

    private fun getSandboxCameraOutputPath(): String {
        val externalFilesDir: File? = appContext.getExternalFilesDir("")
        val customFile = File(externalFilesDir?.absolutePath, "Sandbox")
        if (!customFile.exists()) {
            customFile.mkdirs()
        }
        return customFile.absolutePath + File.separator

    }
}