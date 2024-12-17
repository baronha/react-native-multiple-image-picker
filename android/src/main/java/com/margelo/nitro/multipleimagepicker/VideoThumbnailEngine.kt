package com.margelo.nitro.multipleimagepicker

import android.content.Context
import android.graphics.Bitmap
import android.graphics.drawable.Drawable
import com.bumptech.glide.Glide
import com.bumptech.glide.request.target.CustomTarget
import com.bumptech.glide.request.transition.Transition
import com.luck.picture.lib.interfaces.OnKeyValueResultCallbackListener
import com.luck.picture.lib.interfaces.OnVideoThumbnailEventListener
import com.luck.picture.lib.utils.PictureFileUtils
import java.io.ByteArrayOutputStream
import java.io.File
import java.io.FileOutputStream
import java.io.IOException


class VideoThumbnailEngine(private val targetPath: String) : OnVideoThumbnailEventListener {
    override fun onVideoThumbnail(
        context: Context, videoPath: String, call: OnKeyValueResultCallbackListener
    ) {
        Glide.with(context).asBitmap().sizeMultiplier(0.6f).load(videoPath)
            .into(object : CustomTarget<Bitmap?>() {
                override fun onResourceReady(
                    resource: Bitmap, transition: Transition<in Bitmap?>?
                ) {
                    val stream = ByteArrayOutputStream()
                    resource.compress(Bitmap.CompressFormat.JPEG, 60, stream)
                    var fos: FileOutputStream? = null
                    var result: String? = null
                    try {
                        val targetFile =
                            File(targetPath, "thumbnails_" + System.currentTimeMillis() + ".jpg")
                        fos = FileOutputStream(targetFile)
                        fos.write(stream.toByteArray())
                        fos.flush()
                        result = targetFile.absolutePath
                    } catch (e: IOException) {
                        e.printStackTrace()
                    } finally {
                        PictureFileUtils.close(fos)
                        PictureFileUtils.close(stream)
                    }
                    call.onCallback(videoPath, result)
                }

                override fun onLoadCleared(placeholder: Drawable?) {
                    call.onCallback(videoPath, "")
                }
            })
    }
}