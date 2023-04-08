package com.reactnativemultipleimagepicker

import android.content.Context
import android.graphics.Bitmap
import android.net.Uri
import android.widget.ImageView
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.engine.CropEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.utils.DateUtils
import com.yalantis.ucrop.UCrop
import com.yalantis.ucrop.UCropImageEngine
import java.io.File


class CropEngine(
    appContext: Context,
    cropOption: UCrop.Options
) : CropEngine {
    private val context = appContext
    private val option: UCrop.Options = cropOption
    override fun onStartCrop(
        fragment: Fragment, currentLocalMedia: LocalMedia,
        dataSource: ArrayList<LocalMedia>, requestCode: Int
    ) {
        val currentCropPath = currentLocalMedia.availablePath
        val inputUri: Uri =
            if (PictureMimeType.isContent(currentCropPath) || PictureMimeType.isHasHttp(
                    currentCropPath
                )
            ) {
                Uri.parse(currentCropPath)
            } else {
                Uri.fromFile(File(currentCropPath))
            }
        val fileName: String = DateUtils.getCreateFileName("CROP_") + ".jpg"
        val destinationUri = Uri.fromFile(File(getSandboxPath(context), fileName))
        val dataCropSource: ArrayList<String> = ArrayList()
        for (i in 0 until dataSource.size) {
            val media = dataSource[i]
            dataCropSource.add(media.availablePath)
        }
        val uCrop = UCrop.of(inputUri, destinationUri, dataCropSource)
        uCrop.setImageEngine(object : UCropImageEngine {
            override fun loadImage(context: Context, url: String, imageView: ImageView) {
                Glide.with(context).load(url).into(imageView)
            }

            override fun loadImage(
                context: Context?,
                url: Uri?,
                maxWidth: Int,
                maxHeight: Int,
                call: UCropImageEngine.OnCallbackListener<Bitmap>?
            ) {
                TODO("Not yet implemented")
            }
        })
        uCrop.withOptions(option)
        uCrop.start(fragment.requireActivity(), fragment, requestCode)
    }
}

fun getSandboxPath(context: Context): String {
    val externalFilesDir: File? = context.getExternalFilesDir("")
    val customFile = File(externalFilesDir?.absolutePath, "Sandbox")
    if (!customFile.exists()) {
        customFile.mkdirs()
    }
    return customFile.absolutePath + File.separator
}


