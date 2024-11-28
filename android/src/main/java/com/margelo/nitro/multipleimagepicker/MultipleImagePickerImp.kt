package com.margelo.nitro.multipleimagepicker

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.media.MediaMetadataRetriever
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.ColorPropConverter
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.ReadableNativeArray
import com.facebook.react.bridge.ReadableNativeMap
import com.facebook.react.bridge.ReadableType
import com.luck.picture.lib.app.IApp
import com.luck.picture.lib.app.PictureAppMaster
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.engine.PictureSelectorEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.entity.LocalMedia.generateLocalMedia
import com.luck.picture.lib.interfaces.OnMediaEditInterceptListener
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.luck.picture.lib.style.BottomNavBarStyle
import com.luck.picture.lib.style.PictureSelectorStyle
import com.luck.picture.lib.style.PictureWindowAnimationStyle
import com.luck.picture.lib.style.SelectMainStyle
import com.luck.picture.lib.style.TitleBarStyle
import com.luck.picture.lib.utils.DensityUtil
import com.yalantis.ucrop.UCrop.Options
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.util.UUID

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
    private var cropOption = Options()


    @ReactMethod
    fun openPicker(
        options: NitroConfig,
        resolved: (result: Array<Result>) -> Unit,
        rejected: (reject: Double) -> Unit
    ): Unit {
        PictureAppMaster.getInstance().app = this
        val activity = currentActivity
        val imageEngine = GlideEngine.createGlideEngine()

        // set global config
        config = options

        setStyle() // set style for UI

        val chooseMode = when (config.mediaType) {
            MediaType.VIDEO -> SelectMimeType.ofVideo()
            MediaType.IMAGE -> SelectMimeType.ofImage()
            else -> SelectMimeType.ofAll()
        }

        val selectedAssets = config.selectedAssets
        val maxSelect = config.maxSelect?.toInt() ?: 20
        val maxVideo = config.maxVideo?.toInt() ?: 20
        val maxPhoto = config.maxPhoto?.toInt() ?: 20
        val isPreview = config.isPreview ?: true
        val maxFileSize = config.maxFileSize?.toLong()
        val maxDuration = config.maxVideoDuration?.toInt()
        val allowSwipeToSelect = config.allowSwipeToSelect ?: false

        val isMultiple = config.selectMode == SelectMode.MULTIPLE
        val selectMode = if (isMultiple) SelectModeConfig.MULTIPLE else SelectModeConfig.SINGLE


        val isCrop = config.crop != null

        PictureSelector.create(activity).openGallery(chooseMode).setImageEngine(imageEngine)
            .setSelectorUIStyle(style).apply {
                if (isCrop) {
                    setCropOption()
                    // Disabled force crop engine for multiple
                    if (!isMultiple) setCropEngine(CropEngine(cropOption))
                    setEditMediaInterceptListener(setEditMediaEvent())
                }
                maxDuration?.let {
                    setFilterVideoMaxSecond(it)
                }
                maxFileSize?.let {
                    setFilterMaxFileSize(it)
                }
            }.setMaxSelectNum(maxSelect).setImageSpanCount(config.numberOfColumn?.toInt() ?: 3)
            .setSkipCropMimeType(*getNotSupportCrop()).isDirectReturnSingle(true)
            .isSelectZoomAnim(true).isPageStrategy(true, 50).isWithSelectVideoImage(true)
            .setMaxVideoSelectNum(if (maxVideo != 20) maxVideo else maxSelect)
            .isMaxSelectEnabledMask(true).isAutoVideoPlay(true)
            .isFastSlidingSelect(allowSwipeToSelect).isPageSyncAlbumCount(true)
//            .setSelectedData([])
            .isPreviewImage(isPreview).isPreviewVideo(isPreview)
            .isDisplayCamera(config.allowedCamera ?: true).isDisplayTimeAxis(true)
            .setSelectionMode(selectMode).isOriginalControl(config.isHiddenOriginalButton == false)
            .isPreviewFullScreenMode(true)
            .forResult(object : OnResultCallbackListener<LocalMedia?> {
                override fun onResult(localMedia: ArrayList<LocalMedia?>?) {

                    println("localMedia ne: $localMedia")
                    var data: Array<Result> = arrayOf()

                    if (localMedia?.size == 0) {
                        resolved(arrayOf())

                        return
                    }
                    if (localMedia?.size == selectedAssets.size && (localMedia.last()?.id.toString() == (selectedAssets[selectedAssets.size - 1].localIdentifier))) {
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

    private fun setCropOption() {
        val mainStyle: SelectMainStyle = style.selectMainStyle

        cropOption.setShowCropFrame(true)
        cropOption.setShowCropGrid(true)
        cropOption.setCircleDimmedLayer(config.crop?.circle ?: false)
        cropOption.setCropOutputPathDir(getSandboxPath(appContext))
        cropOption.isCropDragSmoothToCenter(true)
        cropOption.isForbidSkipMultipleCrop(true)
        cropOption.setMaxScaleMultiplier(100f)
        cropOption.setToolbarWidgetColor(Color.BLACK)
        cropOption.setStatusBarColor(mainStyle.statusBarColor)
        cropOption.isDarkStatusBarBlack(mainStyle.isDarkStatusBarBlack)
        cropOption.isDragCropImages(true)
        cropOption.setFreeStyleCropEnabled(true)
        cropOption.setSkipCropMimeType(*getNotSupportCrop())
    }


    private fun getNotSupportCrop(): Array<String> {
        return arrayOf(PictureMimeType.ofGIF(), PictureMimeType.ofWEBP())
    }


    private fun setEditMediaEvent(): OnMediaEditInterceptListener {
        return MediaEditInterceptListener(getSandboxPath(appContext), cropOption)
    }

    private fun setStyle() {
        val primaryColor = ColorPropConverter.getColor(config.primaryColor, null)
        val isNumber = config.selectBoxStyle == SelectBoxStyle.NUMBER
        val selectType = if (isNumber) R.drawable.picture_selector else R.drawable.checkbox_selector
        val isDark = config.theme == Theme.DARK
        val foreground = if (isDark) Color.WHITE else Color.BLACK
        val background = if (isDark) ContextCompat.getColor(appContext, com.luck.picture.lib.R.color.ps_color_33) else Color.WHITE

        val titleBar = TitleBarStyle()
        val bottomBar = BottomNavBarStyle()
        val mainStyle = SelectMainStyle()
        val iconBack =
            if (isDark) com.luck.picture.lib.R.drawable.ps_ic_back else com.luck.picture.lib.R.drawable.ps_ic_black_back

        cropOption.setLogoColor(primaryColor)

        // TITLE BAR
        titleBar.titleBackgroundColor = background
        titleBar.isAlbumTitleRelativeLeft = true
        titleBar.titleAlbumBackgroundResource = com.luck.picture.lib.R.drawable.ps_album_bg
        titleBar.titleDrawableRightResource = com.luck.picture.lib.R.drawable.ps_ic_grey_arrow
        titleBar.previewTitleLeftBackResource = iconBack
        titleBar.titleLeftBackResource = iconBack
        titleBar.isHideCancelButton = true

        // BOTTOM BAR
        bottomBar.bottomPreviewNormalTextColor = foreground
        bottomBar.bottomPreviewSelectTextColor = foreground
        bottomBar.bottomNarBarBackgroundColor = background
        bottomBar.bottomEditorTextColor = foreground
        bottomBar.bottomOriginalTextColor = foreground
        bottomBar.bottomPreviewNarBarBackgroundColor = background

        mainStyle.mainListBackgroundColor = foreground
        mainStyle.selectNormalTextColor = foreground
        mainStyle.isDarkStatusBarBlack = !isDark
        mainStyle.statusBarColor = background
        mainStyle.mainListBackgroundColor = background
        mainStyle.adapterPreviewGalleryItemSize = DensityUtil.dip2px(appContext, 52f);


        bottomBar.isCompleteCountTips = false
        bottomBar.bottomOriginalTextSize = Constant.TOOLBAR_TEXT_SIZE
        bottomBar.bottomSelectNumTextSize = Constant.TOOLBAR_TEXT_SIZE
        bottomBar.bottomPreviewNormalTextSize = Constant.TOOLBAR_TEXT_SIZE
        bottomBar.bottomEditorTextSize = Constant.TOOLBAR_TEXT_SIZE

        // MAIN STYLE
        mainStyle.isCompleteSelectRelativeTop = false
        mainStyle.isPreviewDisplaySelectGallery = true
        mainStyle.adapterPreviewGalleryBackgroundResource =
            com.luck.picture.lib.R.drawable.ps_preview_gallery_bg
        mainStyle.isAdapterItemIncludeEdge = true
        mainStyle.isPreviewSelectRelativeBottom = false
//        mainStyle.previewSelectTextSize = Constant.TOOLBAR_TEXT_SIZE
        mainStyle.selectTextColor = primaryColor
//        mainStyle.selectTextSize = Constant.TOOLBAR_TEXT_SIZE
        mainStyle.selectBackground = selectType
        mainStyle.isSelectNumberStyle = isNumber
        mainStyle.previewSelectBackground = selectType
        mainStyle.isPreviewSelectNumberStyle = isNumber

        // custom finish text
        config.text.let { text ->
            text?.finish.let {
                mainStyle.selectText = it
                mainStyle.selectNormalText = it
                mainStyle.selectText = it
            }
        }

        // SET STYLE
        style.titleBarStyle = titleBar
        style.bottomBarStyle = bottomBar
        style.selectMainStyle = mainStyle

        // ANIMATION SLIDE FROM BOTTOM
        val animationStyle = PictureWindowAnimationStyle()
        animationStyle.setActivityEnterAnimation(com.luck.picture.lib.R.anim.ps_anim_up_in)
        animationStyle.setActivityExitAnimation(com.luck.picture.lib.R.anim.ps_anim_down_out)

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
