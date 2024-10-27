package com.margelo.nitro.multipleimagepicker

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.media.MediaMetadataRetriever
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.*
import com.luck.picture.lib.app.IApp
import com.luck.picture.lib.app.PictureAppMaster
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.engine.PictureSelectorEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.entity.LocalMedia.generateLocalMedia
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.luck.picture.lib.style.*
import com.margelo.nitro.inappbrowser.R
import com.margelo.nitro.multipleimagepicker.MediaType
import com.margelo.nitro.multipleimagepicker.NitroConfig
import com.margelo.nitro.multipleimagepicker.Result
import com.margelo.nitro.multipleimagepicker.ResultType
import com.margelo.nitro.multipleimagepicker.SelectMode
import com.yalantis.ucrop.UCrop.Options
import java.io.*
import java.util.*
import com.facebook.react.bridge.Dynamic
import com.margelo.nitro.multipleimagepicker.SelectBoxStyle
import com.facebook.react.bridge.ColorPropConverter


class MultipleImagePickerImp(reactContext: ReactApplicationContext?) :
    ReactContextBaseJavaModule(reactContext), IApp {

    override fun getName(): String {
        return "MultipleImagePicker"
    }

    companion object {
        const val TAG = "MultipleImagePicker"
    }

    private var style = PictureSelectorStyle()
    private lateinit var config: NitroConfig
    private var cropOption: Options? = null


    @ReactMethod
    fun openPicker(
        options: NitroConfig,
        resolved: (result: Array<Result>) -> Unit,
        rejected: (reject: Double) -> Unit
    ): Unit {
        PictureAppMaster.getInstance().app = this
        val activity = currentActivity
        val imageEngine = GlideEngine.createGlideEngine()

        // set global
        config = options

        setStyle() // set style for UI

        val mediaType = config.mediaType
        val chooseMode =
            if (mediaType == MediaType.VIDEO) SelectMimeType.ofVideo() else if (mediaType == MediaType.IMAGE) SelectMimeType.ofImage() else SelectMimeType.ofAll()


        val selectedAssets = options.selectedAssets
        val maxSelect = options.maxSelect?.toInt() ?: 20
        val maxVideo = options.maxVideo?.toInt() ?: 20
        val maxPhoto = options.maxPhoto?.toInt() ?: 20
        val isPreview = options.isPreview ?: true
        val selectMode =
            if (options.selectMode == SelectMode.MULTIPLE) SelectModeConfig.MULTIPLE else SelectModeConfig.SINGLE

        val isCrop = options.crop != null

        if (isCrop) {
            setCropOptions(options)
        } else {
            cropOption = null
        }

        PictureSelector.create(activity)
            .openGallery(chooseMode)
            .setImageEngine(imageEngine)
            .setMaxSelectNum(maxSelect)
            .setImageSpanCount(options.numberOfColumn?.toInt() ?: 3)
            .setCropEngine(onSetCropEngine())
            .isDirectReturnSingle(true)
            .isSelectZoomAnim(true)
            .isPageStrategy(true, 50)
            .isWithSelectVideoImage(true)
            .setRecordVideoMaxSecond(options.maxVideoDuration?.toInt() ?: 0)
            .setMaxVideoSelectNum(if (maxVideo != 20) maxVideo else maxSelect)
            .isMaxSelectEnabledMask(true)
//            .setSelectedData([])
            .setSelectorUIStyle(style)
            .isPreviewImage(isPreview)
            .isPreviewVideo(isPreview)
            .isDisplayCamera(options.allowedCamera ?: true)
            .setSelectionMode(selectMode)
            .forResult(object : OnResultCallbackListener<LocalMedia?> {
                override fun onResult(localMedia: ArrayList<LocalMedia?>?) {

                    var data: Array<Result> = arrayOf()

                    if (localMedia?.size == 0) {
                        resolved(arrayOf())

                        return
                    }
                    if (localMedia?.size == selectedAssets.size
                        && (localMedia.last()?.id.toString() == (selectedAssets[selectedAssets.size - 1].localIdentifier))
                    ) {
                        return
                    }

                    localMedia.let { list ->
                        list?.forEach { item ->
                            if (item != null) {
                                val media: Result = getResult(item)
                                data.plus(media)
                            }
                        }

                        resolved(data)
                    }


                }

                override fun onCancel() {
                    rejected(1.0)
                }
            })
    }

    private fun onSetCropEngine(): CropEngine? {
        return cropOption?.let { CropEngine(it) }
    }


    @SuppressLint("ResourceAsColor")
    private fun setCropOptions(options: NitroConfig) {


        cropOption = Options()

        val mainStyle: SelectMainStyle = style.selectMainStyle

        cropOption?.setShowCropFrame(true)
        cropOption?.setShowCropGrid(true)
        cropOption?.setCircleDimmedLayer(options.crop?.circle ?: false)
        cropOption?.setCropOutputPathDir(getSandboxPath(appContext))
        cropOption?.isCropDragSmoothToCenter(false)
        cropOption?.isForbidSkipMultipleCrop(true)
        cropOption?.setMaxScaleMultiplier(100f)

        cropOption?.setToolbarWidgetColor(Color.BLACK)
        cropOption?.setStatusBarColor(mainStyle.statusBarColor)
        cropOption?.isDarkStatusBarBlack(mainStyle.isDarkStatusBarBlack)

//        cropOption = options
    }

    private fun setStyle() {


        val primaryColor = ColorPropConverter.getColor(config.primaryColor, null)

        cropOption?.setLogoColor(primaryColor)

        // ANIMATION SLIDE FROM BOTTOM
        val animationStyle = PictureWindowAnimationStyle()
        animationStyle.setActivityEnterAnimation(com.luck.picture.lib.R.anim.ps_anim_up_in)
        animationStyle.setActivityExitAnimation(com.luck.picture.lib.R.anim.ps_anim_down_out)

        // TITLE BAR
        val titleBar = TitleBarStyle()
        titleBar.titleBackgroundColor = ContextCompat.getColor(appContext, R.color.app_color_white)

        titleBar.isHideCancelButton = true
        titleBar.isAlbumTitleRelativeLeft = true

        titleBar.titleAlbumBackgroundResource = com.luck.picture.lib.R.drawable.ps_album_bg
        titleBar.titleDrawableRightResource = com.luck.picture.lib.R.drawable.ps_ic_grey_arrow
        titleBar.previewTitleLeftBackResource = com.luck.picture.lib.R.drawable.ps_ic_black_back
        titleBar.titleLeftBackResource = com.luck.picture.lib.R.drawable.ps_ic_black_back
        titleBar.isHideCancelButton = true

        // BOTTOM BAR
        val bottomBar = BottomNavBarStyle()
        bottomBar.bottomPreviewNormalTextColor =
            ContextCompat.getColor(appContext, R.color.app_color_pri)
        bottomBar.bottomPreviewSelectTextColor =
            ContextCompat.getColor(appContext, R.color.app_color_pri)
        bottomBar.bottomNarBarBackgroundColor =
            ContextCompat.getColor(appContext, com.luck.picture.lib.R.color.ps_color_white)
        bottomBar.bottomSelectNumResources = R.drawable.num_oval_orange
        bottomBar.bottomEditorTextColor =
            ContextCompat.getColor(appContext, com.luck.picture.lib.R.color.ps_color_53575e)
        bottomBar.bottomOriginalTextColor =
            ContextCompat.getColor(appContext, com.luck.picture.lib.R.color.ps_color_53575e)
        bottomBar.bottomPreviewNormalTextColor = R.color.app_color_53575e
        bottomBar.bottomPreviewNormalTextColor = Color.BLACK
        bottomBar.isCompleteCountTips = false

        // MAIN STYLE
        val mainStyle = SelectMainStyle()

        mainStyle.isPreviewSelectRelativeBottom = true
        mainStyle.isSelectNumberStyle =
            config.selectBoxStyle == SelectBoxStyle.NUMBER

        mainStyle.isPreviewSelectNumberStyle = true
        mainStyle.isSelectNumberStyle = true
        mainStyle.selectBackground = R.drawable.picture_selector
        mainStyle.mainListBackgroundColor =
            ContextCompat.getColor(appContext, com.luck.picture.lib.R.color.ps_color_white)
        mainStyle.previewSelectBackground = R.drawable.picture_selector

        config.text.let { text ->

            text?.finish.let {
                mainStyle.selectText = it
                mainStyle.selectNormalText = it
                mainStyle.selectText = it
            }
        }
        mainStyle.isCompleteSelectRelativeTop = true
        mainStyle.selectNormalTextColor =
            ContextCompat.getColor(appContext, com.luck.picture.lib.R.color.ps_color_9b)
        mainStyle.selectTextColor = primaryColor


        mainStyle.statusBarColor = ContextCompat.getColor(
            appContext, R.color.app_color_white
        )
        mainStyle.isDarkStatusBarBlack = true

        style.titleBarStyle = titleBar
        style.bottomBarStyle = bottomBar
        style.selectMainStyle = mainStyle
        style.windowAnimationStyle = animationStyle
    }

    private fun handleSelectedAssets(options: ReadableMap?) {
        if (options?.hasKey("selectedAssets")!!) {
            val assetsType = options.getType("selectedAssets")
            if (assetsType == ReadableType.Array) {
                val assets: ReadableNativeArray =
                    options.getArray("selectedAssets") as ReadableNativeArray
                if (assets.size() > 0) {
                    val list = mutableListOf<LocalMedia>()
                    for (i in 0 until assets.size()) {
                        val asset: ReadableNativeMap = assets.getMap(i)
                        val localMedia: LocalMedia = handleSelectedAssetItem(asset)
                        list.add(localMedia)
                    }
//                    selectedAssets = list
                    return
                }

//                selectedAssets = emptyList()
            }
            if (assetsType == ReadableType.Map) {
                println("type Map")
            }
        }
    }

    private fun handleSelectedAssetItem(asset: ReadableNativeMap): LocalMedia {
        val path: String? = asset.getString("path")
        return generateLocalMedia(appContext, path)
    }

    private fun getResult(item: LocalMedia): Result {

        val type: ResultType =
            if (item.mimeType.startsWith("video/")) ResultType.VIDEO else ResultType.IMAGE

        var path = item.path
        var width: Double = item.width.toDouble()
        var height: Double = item.height.toDouble()

        if (item.isCut) {
            path = "file://${item.cutPath}"
            width = item.cropImageWidth.toDouble()
            height = item.cropImageHeight.toDouble()
        }


        val media = Result(
            path,
            fileName = item.fileName,
            localIdentifier = item.id.toString(),
            width,
            height,
            mime = item.mimeType,
            size = item.size.toDouble(),
            bucketId = item.bucketId.toDouble(),
            realPath = item.realPath,
            parentFolderName = item.parentFolderName,
            creationDate = item.dateAddedTime.toDouble(),
            type,
            duration = item.duration.toDouble(),
            thumbnail = item.videoThumbnailPath,
            crop = item.isCut
        )

        return media
    }

    private fun createThumbnail(filePath: String): String {
        val retriever = MediaMetadataRetriever()
        retriever.setDataSource(filePath)
        val image = retriever.getFrameAtTime(1000000, MediaMetadataRetriever.OPTION_CLOSEST_SYNC)

        val fullPath: String =
            reactApplicationContext.applicationContext.cacheDir.absolutePath.toString() + "/thumbnails"
        try {
            val fileName = "thumb-" + UUID.randomUUID().toString() + ".jpeg"
            val file = File(fullPath, fileName)
            file.parentFile?.mkdirs()
            file.createNewFile()
            try {
                val fos = FileOutputStream(file)
                image?.compress(Bitmap.CompressFormat.JPEG, 80, fos)
                fos.flush()
                fos.close()

            } catch (e: FileNotFoundException) {
                e.printStackTrace()
            }

            return "file://$fullPath/$fileName"
        } catch (e: Exception) {
            println("Error: " + e.message)
            return ""
        }
    }

    override fun getAppContext(): Context {
        return reactApplicationContext
    }

    override fun getPictureSelectorEngine(): PictureSelectorEngine {
        return PictureSelectorEngineImp()
    }

}





