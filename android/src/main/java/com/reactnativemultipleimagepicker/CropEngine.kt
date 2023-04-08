//package com.reactnativemultipleimagepicker
//
//import android.content.Context
//import android.graphics.Bitmap
//import android.net.Uri
//import android.widget.ImageView
//import androidx.core.content.ContextCompat
//import androidx.fragment.app.Fragment
//import com.bumptech.glide.Glide
//import com.luck.picture.lib.engine.CropFileEngine
//import com.luck.picture.lib.interfaces.OnCallbackListener
//import com.luck.picture.lib.style.TitleBarStyle
//import com.luck.picture.lib.utils.StyleUtils
//import com.yalantis.ucrop.UCrop
//import com.yalantis.ucrop.UCropImageEngine
//import java.security.AccessController.getContext
//
//class ImageFileCropEngine : CropFileEngine {
//    fun onStartCrop(
//        fragment: Fragment,
//        srcUri: Uri?,
//        destinationUri: Uri?,
//        dataSource: ArrayList<String?>?,
//        requestCode: Int
//    ) {
//        val options: UCrop.Options = buildOptions()
//        val uCrop: UCrop = UCrop.of(srcUri, destinationUri, dataSource)
//        uCrop.withOptions(options)
//        uCrop.setImageEngine(object : UCropImageEngine() {
//            fun loadImage(context: Context?, url: String?, imageView: ImageView?) {
//                if (!ImageLoaderUtils.assertValidRequest(context)) {
//                    return
//                }
//                GlideEngine.with(context).load(url).override(180, 180).into(imageView)
//            }
//
//            fun loadImage(
//                context: Context?,
//                url: Uri?,
//                maxWidth: Int,
//                maxHeight: Int,
//                call: OnCallbackListener<Bitmap?>?
//            ) {
//                Glide.with(context).asBitmap().load(url).override(maxWidth, maxHeight)
//                    .into(object : CustomTarget<Bitmap?>() {
//                        fun onResourceReady(
//                            @NonNull resource: Bitmap?,
//                            @Nullable transition: Transition<in Bitmap?>?
//                        ) {
//                            if (call != null) {
//                                call.onCall(resource)
//                            }
//                        }
//
//                        fun onLoadCleared(@Nullable placeholder: Drawable?) {
//                            if (call != null) {
//                                call.onCall(null)
//                            }
//                        }
//                    })
//            }
//        })
//        uCrop.start(fragment.requireActivity(), fragment, requestCode)
//    }
//}
//
//private fun buildOptions(): UCrop.Options {
//    val options = UCrop.Options()
////    options.setHideBottomControls(!cb_hide.isChecked())
////    options.setFreeStyleCropEnabled(cb_styleCrop.isChecked())
////    options.setShowCropFrame(cb_showCropFrame.isChecked())
////    options.setShowCropGrid(cb_showCropGrid.isChecked())
////    options.setCircleDimmedLayer(cb_crop_circular.isChecked())
////    options.withAspectRatio(aspect_ratio_x, aspect_ratio_y)
////    options.setCropOutputPathDir(getSandboxPath())
////    options.isCropDragSmoothToCenter(false)
////    options.setSkipCropMimeType(getNotSupportCrop())
////    options.isForbidCropGifWebp(cb_not_gif.isChecked())
////    options.isForbidSkipMultipleCrop(true)
////    options.setMaxScaleMultiplier(100f)
//
//    if (selectorStyle != null && selectorStyle.getSelectMainStyle().getStatusBarColor() !== 0) {
//        val mainStyle: SelectMainStyle = selectorStyle.getSelectMainStyle()
//        val isDarkStatusBarBlack: Boolean = mainStyle.isDarkStatusBarBlack()
//        val statusBarColor: Int = mainStyle.getStatusBarColor()
//        options.isDarkStatusBarBlack(isDarkStatusBarBlack)
//        if (StyleUtils.checkStyleValidity(statusBarColor)) {
//            options.setStatusBarColor(statusBarColor)
//            options.setToolbarColor(statusBarColor)
//        } else {
//            options.setStatusBarColor(ContextCompat.getColor(getContext(), R.color.ps_color_grey))
//            options.setToolbarColor(ContextCompat.getColor(getContext(), R.color.ps_color_grey))
//        }
//        val titleBarStyle: TitleBarStyle = selectorStyle.getTitleBarStyle()
//        if (StyleUtils.checkStyleValidity(titleBarStyle.getTitleTextColor())) {
//            options.setToolbarWidgetColor(titleBarStyle.getTitleTextColor())
//        } else {
//            options.setToolbarWidgetColor(
//                ContextCompat.getColor(
//                    getContext(),
//                    R.color.ps_color_white
//                )
//            )
//        }
//    } else {
//        options.setStatusBarColor(ContextCompat.getColor(getContext(), R.color.ps_color_grey))
//        options.setToolbarColor(ContextCompat.getColor(getContext(), R.color.ps_color_grey))
//        options.setToolbarWidgetColor(ContextCompat.getColor(getContext(), R.color.ps_color_white))
//    }
//    return options
//}
