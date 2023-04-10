package com.reactnativemultipleimagepicker

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import android.net.Uri
import android.widget.ImageView
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.luck.picture.lib.engine.CropFileEngine
import com.reactnativemultipleimagepicker.ImageLoaderUtils.assertValidRequest
import com.yalantis.ucrop.UCrop
import com.yalantis.ucrop.UCropImageEngine
import java.io.File


class CropEngine(cropOption: UCrop.Options) : CropFileEngine {
    private val options: UCrop.Options = cropOption
    override fun onStartCrop(
        fragment: Fragment,
        srcUri: Uri?,
        destinationUri: Uri?,
        dataSource: ArrayList<String?>?,
        requestCode: Int
    ) {
        val uCrop = UCrop.of(srcUri!!, destinationUri!!, dataSource)
        uCrop.withOptions(options)
        uCrop.setImageEngine(object : UCropImageEngine {
            override fun loadImage(context: Context, url: String, imageView: ImageView) {
                if (!assertValidRequest(context)) {
                    return
                }
                Glide.with(context).load(url).override(180, 180).into(imageView)
            }

            override fun loadImage(
                context: Context,
                url: Uri,
                maxWidth: Int,
                maxHeight: Int,
                call: UCropImageEngine.OnCallbackListener<Bitmap>
            ) {
                Glide.with(context).asBitmap().load(url).override(maxWidth, maxHeight)
                    .into(object : CustomTarget<Bitmap?>() {
                        override fun onResourceReady(
                            resource: Bitmap,
                            transition: Transition<in Bitmap?>?
                        ) {
                            call.onCall(resource)
                        }

                        override fun onLoadCleared(placeholder: Drawable?) {
                            call.onCall(null)
                        }
                    })
            }
        })
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


