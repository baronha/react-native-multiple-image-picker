package com.margelo.nitro.multipleimagepicker

import android.app.Activity
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.net.Uri
import androidx.core.content.ContextCompat
import com.facebook.react.bridge.BaseActivityEventListener
import com.facebook.react.bridge.ColorPropConverter
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.luck.picture.lib.app.IApp
import com.luck.picture.lib.app.PictureAppMaster
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.engine.PictureSelectorEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnCustomLoadingListener
import com.luck.picture.lib.interfaces.OnMediaEditInterceptListener
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.luck.picture.lib.language.LanguageConfig
import com.luck.picture.lib.style.BottomNavBarStyle
import com.luck.picture.lib.style.PictureSelectorStyle
import com.luck.picture.lib.style.PictureWindowAnimationStyle
import com.luck.picture.lib.style.SelectMainStyle
import com.luck.picture.lib.style.TitleBarStyle
import com.luck.picture.lib.utils.DateUtils
import com.luck.picture.lib.utils.DensityUtil
import com.luck.picture.lib.utils.MediaUtils
import com.yalantis.ucrop.UCrop
import com.yalantis.ucrop.UCrop.Options
import com.yalantis.ucrop.UCrop.REQUEST_CROP
import com.yalantis.ucrop.model.AspectRatio
import java.io.File
import java.net.HttpURLConnection
import java.net.URL


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
    private var dataList = mutableListOf<LocalMedia>()


    @ReactMethod
    fun openPicker(
        options: NitroConfig,
        resolved: (result: Array<PickerResult>) -> Unit,
        rejected: (reject: Double) -> Unit
    ) {
        PictureAppMaster.getInstance().app = this
        val activity = currentActivity
        val imageEngine = GlideEngine.createGlideEngine()

        // set global config
        config = options

        setStyle() // set style for UI
        handleSelectedAssets(config)

        val chooseMode = getChooseMode(config.mediaType)

        val maxSelect = config.maxSelect?.toInt() ?: 20
        val maxVideo = config.maxVideo?.toInt() ?: 20
        val isPreview = config.isPreview ?: true
        val maxFileSize = config.maxFileSize?.toLong()
        val maxDuration = config.maxVideoDuration?.toInt()
        val minDuration = config.minVideoDuration?.toInt()
        val allowSwipeToSelect = config.allowSwipeToSelect ?: false
        val isMultiple = config.selectMode == SelectMode.MULTIPLE
        val selectMode = if (isMultiple) SelectModeConfig.MULTIPLE else SelectModeConfig.SINGLE

        val isCrop = config.crop != null

        PictureSelector.create(activity)
            .openGallery(chooseMode)
            .setImageEngine(imageEngine)
            .setSelectedData(dataList)
            .setSelectorUIStyle(style)
            .apply {
                if (isCrop) {
                    setCropOption(config.crop)
                    // Disabled force crop engine for multiple
                    if (!isMultiple) setCropEngine(CropEngine(cropOption))
                    else setEditMediaInterceptListener(setEditMediaEvent())
                }
                maxDuration?.let {
                    setFilterVideoMaxSecond(it)
                }

                minDuration?.let {
                    setFilterVideoMinSecond(it)
                }

                maxFileSize?.let {
                    setFilterMaxFileSize(it)
                }

                isDisplayCamera(config.camera != null)

                config.camera?.let {
                    val cameraConfig = NitroCameraConfig(
                        mediaType = MediaType.ALL,
                        presentation = Presentation.FULLSCREENMODAL,
                        language = Language.SYSTEM,
                        crop = null,
                        isSaveSystemAlbum = false,
                        color = config.primaryColor,
                        cameraDevice = it.cameraDevice,
                        videoMaximumDuration = it.videoMaximumDuration
                    )

                    setCameraInterceptListener(CameraEngine(appContext, cameraConfig))
                }
            }
            .setVideoThumbnailListener(VideoThumbnailEngine(getVideoThumbnailDir()))
            .setImageSpanCount(config.numberOfColumn?.toInt() ?: 3)
            .setMaxSelectNum(maxSelect)
            .isDirectReturnSingle(true)
            .isSelectZoomAnim(true)
            .isPageStrategy(true, 50)
            .isWithSelectVideoImage(true)
            .setMaxVideoSelectNum(if (maxVideo != 20) maxVideo else maxSelect)
            .isMaxSelectEnabledMask(true)
            .isAutoVideoPlay(true)
            .isFastSlidingSelect(allowSwipeToSelect)
            .isPageSyncAlbumCount(true)
            // isPreview
            .isPreviewImage(isPreview)
            .isPreviewVideo(isPreview)
            .isDisplayTimeAxis(true)
            .setSelectionMode(selectMode)
            .isOriginalControl(config.isHiddenOriginalButton == false)
            .setLanguage(getLanguage(config.language))
            .isPreviewFullScreenMode(true)
            .forResult(object : OnResultCallbackListener<LocalMedia?> {
                override fun onResult(localMedia: ArrayList<LocalMedia?>?) {
                    var data: Array<PickerResult> = arrayOf()
                    if (localMedia?.size == 0 || localMedia == null) {
                        resolved(arrayOf())
                        return
                    }

                    // set dataList
                    dataList = localMedia.filterNotNull().toMutableList()

                    localMedia.forEach { item ->
                        if (item != null) {
                            val media = getResult(item)
                            data += media  // Add the media to the data array
                        }
                    }
                    resolved(data)
                }

                override fun onCancel() {
                    //
                }
            })
    }

    @ReactMethod
    fun openCrop(
        image: String,
        options: NitroCropConfig,
        resolved: (result: CropResult) -> Unit,
        rejected: (reject: Double) -> Unit
    ) {
        cropOption = Options()

        setCropOption(
            PickerCropConfig(
                circle = options.circle,
                ratio = options.ratio,
                defaultRatio = options.defaultRatio,
                freeStyle = options.freeStyle
            )
        )

        try {
            val uri = when {
                // image network
                image.startsWith("http://") || image.startsWith("https://") -> {
                    // Handle remote URL
                    val url = URL(image)
                    val connection = url.openConnection() as HttpURLConnection
                    connection.doInput = true
                    connection.connect()

                    val inputStream = connection.inputStream
                    // Create a temp file to store the image
                    val file = File(appContext.cacheDir, "CROP_")
                    file.outputStream().use { output ->
                        inputStream.copyTo(output)
                    }

                    Uri.fromFile(file)
                }

                else -> Uri.parse(image)
            }

            val destinationUri = Uri.fromFile(
                File(getSandboxPath(appContext), DateUtils.getCreateFileName("CROP_") + ".jpeg")
            )
            val uCrop = UCrop.of<Any>(uri, destinationUri).withOptions(cropOption)

            // set engine
            uCrop.setImageEngine(CropImageEngine())
            // start edit

            val cropActivityEventListener = object : BaseActivityEventListener() {
                override fun onActivityResult(
                    activity: Activity,
                    requestCode: Int,
                    resultCode: Int,
                    data: Intent?
                ) {
                    if (resultCode == Activity.RESULT_OK && requestCode == REQUEST_CROP) {
                        val resultUri = UCrop.getOutput(data!!)
                        val width = UCrop.getOutputImageWidth(data).toDouble()
                        val height = UCrop.getOutputImageHeight(data).toDouble()

                        resultUri?.let {
                            val result = CropResult(
                                path = it.toString(),
                                width,
                                height,
                            )
                            resolved(result)
                        }
                    } else if (resultCode == UCrop.RESULT_ERROR) {
                        val cropError = UCrop.getError(data!!)
                        rejected(0.0)
                    }

                    // Remove listener after getting result
                    reactApplicationContext.removeActivityEventListener(this)
                }
            }

            // Add listener before starting UCrop
            reactApplicationContext.addActivityEventListener(cropActivityEventListener)

            currentActivity?.let { uCrop.start(it, REQUEST_CROP) }
        } catch (e: Exception) {
            rejected(0.0)
        }
    }

    @ReactMethod
    fun openPreview(media: Array<MediaPreview>, index: Int, config: NitroPreviewConfig) {
        val imageEngine = GlideEngine.createGlideEngine()

        val assets: ArrayList<LocalMedia> = arrayListOf()

        val previewStyle = PictureSelectorStyle()
        val titleBarStyle = TitleBarStyle()

        previewStyle.windowAnimationStyle.setActivityEnterAnimation(R.anim.anim_modal_in)
        previewStyle.windowAnimationStyle.setActivityExitAnimation(com.luck.picture.lib.R.anim.ps_anim_modal_out)
        previewStyle.selectMainStyle.previewBackgroundColor = Color.BLACK

        titleBarStyle.previewTitleBackgroundColor = Color.BLACK
        previewStyle.titleBarStyle = titleBarStyle

        media.forEach { mediaItem ->
            var asset: LocalMedia? = null

            mediaItem.path?.let { path ->
                // network asset
                if (path.startsWith("https://") || path.startsWith("http://")) {
                    val localMedia = LocalMedia.create()
                    localMedia.path = path
                    localMedia.mimeType =
                        if (mediaItem.type == ResultType.VIDEO) "video/mp4" else MediaUtils.getMimeTypeFromMediaHttpUrl(
                            path
                        ) ?: "image/jpg"
                    asset = localMedia
                } else {
                    asset = LocalMedia.generateLocalMedia(appContext, path)
                }
            }

            asset?.let { assets.add(it) }
        }

        PictureSelector
            .create(currentActivity)
            .openPreview()
            .setImageEngine(imageEngine)
            .setLanguage(getLanguage(config.language))
            .setSelectorUIStyle(previewStyle)
            .isPreviewFullScreenMode(true)
            .isAutoVideoPlay(config.videoAutoPlay == true)
            .setVideoPlayerEngine(ExoPlayerEngine())
            .isVideoPauseResumePlay(true)
            .setCustomLoadingListener(getCustomLoadingListener())
            .startActivityPreview(index, false, assets)
    }

    private fun getCustomLoadingListener(): OnCustomLoadingListener {
        return OnCustomLoadingListener { context -> LoadingDialog(context) }
    }

    @ReactMethod
    fun openCamera(
        config: NitroCameraConfig,
        resolved: (result: CameraResult) -> Unit,
        rejected: (reject: Double) -> Unit
    ) {
        val activity = currentActivity
        val chooseMode = getChooseMode(config.mediaType)

        PictureSelector
            .create(activity)
            .openCamera(chooseMode)
            .setLanguage(getLanguage(config.language))
            .setCameraInterceptListener(CameraEngine(appContext, config))
            .isQuickCapture(true)
            .isOriginalControl(true)
            .setVideoThumbnailListener(VideoThumbnailEngine(getVideoThumbnailDir()))
            .apply {
                if (config.crop != null) {
                    setCropEngine(CropEngine(cropOption))
                }
            }
            .forResultActivity(object : OnResultCallbackListener<LocalMedia?> {
                override fun onResult(results: java.util.ArrayList<LocalMedia?>?) {
                    results?.first()?.let {
                        val result = getResult(it)

                        resolved(
                            CameraResult(
                                path = result.path,
                                type = result.type,
                                width = result.width,
                                height = result.height,
                                duration = result.duration,
                                thumbnail = result.thumbnail,
                                fileName = result.fileName
                            )
                        )
                    }
                }

                override fun onCancel() {
//                    rejected(0.0)
                }
            })
    }

    private fun getChooseMode(mediaType: MediaType): Int {
        return when (mediaType) {
            MediaType.VIDEO -> SelectMimeType.ofVideo()
            MediaType.IMAGE -> SelectMimeType.ofImage()
            else -> SelectMimeType.ofAll()
        }
    }

    private fun getVideoThumbnailDir(): String {
        val externalFilesDir: File? = appContext.getExternalFilesDir("")
        val customFile = File(externalFilesDir?.absolutePath, "Thumbnail")
        if (!customFile.exists()) {
            customFile.mkdirs()
        }
        return customFile.absolutePath + File.separator
    }


    private fun getLanguage(language: Language): Int {
        return when (language) {
            Language.VI -> LanguageConfig.VIETNAM  // -> 🇻🇳 My country. Yeahhh
            Language.EN -> LanguageConfig.ENGLISH
            Language.ZH_HANS -> LanguageConfig.CHINESE
            Language.ZH_HANT -> LanguageConfig.TRADITIONAL_CHINESE
            Language.DE -> LanguageConfig.GERMANY
            Language.KO -> LanguageConfig.KOREA
            Language.FR -> LanguageConfig.FRANCE
            Language.JA -> LanguageConfig.JAPAN
            Language.AR -> LanguageConfig.AR
            Language.RU -> LanguageConfig.RU
            else -> LanguageConfig.SYSTEM_LANGUAGE
        }
    }

    private fun setCropOption(config: PickerCropConfig?) {
        cropOption.setShowCropFrame(true)
        cropOption.setShowCropGrid(true)
        cropOption.setCircleDimmedLayer(config?.circle ?: false)
        cropOption.setCropOutputPathDir(getSandboxPath(appContext))
        cropOption.isCropDragSmoothToCenter(true)
        cropOption.isForbidSkipMultipleCrop(true)
        cropOption.setMaxScaleMultiplier(100f)
        cropOption.setToolbarWidgetColor(Color.BLACK)
        cropOption.setStatusBarColor(Color.WHITE)
        cropOption.isDarkStatusBarBlack(true)
        cropOption.isDragCropImages(true)
        cropOption.setFreeStyleCropEnabled(config?.freeStyle ?: true)
        cropOption.setSkipCropMimeType(*getNotSupportCrop())


        val ratioCount = config?.ratio?.size ?: 0

        if (config?.defaultRatio != null || ratioCount > 0) {

            var ratioList = arrayOf(AspectRatio("Original", 0f, 0f))

            if (ratioCount > 0) {
                config?.ratio?.take(4)?.toTypedArray()?.forEach { item ->
                    ratioList += AspectRatio(
                        item.title, item.width.toFloat(), item.height.toFloat()
                    )
                }
            }

            // Add default Aspects
            ratioList += arrayOf(
                AspectRatio(null, 1f, 1f),
                AspectRatio(null, 16f, 9f),
                AspectRatio(null, 4f, 3f),
                AspectRatio(null, 3f, 2f)
            )

            config?.defaultRatio?.let {
                val defaultRatio = AspectRatio(it.title, it.width.toFloat(), it.height.toFloat())
                ratioList = arrayOf(defaultRatio) + ratioList

            }

            cropOption.apply {

                setAspectRatioOptions(
                    0,
                    *ratioList.take(5).toTypedArray()
                )
            }
        }
    }


    private fun getNotSupportCrop(): Array<String> {
        return arrayOf(PictureMimeType.ofGIF(), PictureMimeType.ofWEBP())
    }


    private fun setEditMediaEvent(): OnMediaEditInterceptListener {
        return MediaEditInterceptListener(getSandboxPath(appContext), cropOption)
    }

    private fun setStyle() {
        val primaryColor = ColorPropConverter.getColor(config.primaryColor, appContext)
        val isNumber =
            config.selectMode == SelectMode.MULTIPLE && config.selectBoxStyle == SelectBoxStyle.NUMBER
        val selectType = if (isNumber) R.drawable.picture_selector else R.drawable.checkbox_selector
        val isDark = config.theme == Theme.DARK

        val backgroundDark = ColorPropConverter.getColor(config.backgroundDark, appContext)
            ?: ContextCompat.getColor(
                appContext, com.luck.picture.lib.R.color.ps_color_33
            )

        val foreground = if (isDark) Color.WHITE else Color.BLACK
        val background = if (isDark) backgroundDark else Color.WHITE

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
        mainStyle.adapterPreviewGalleryBackgroundResource =
            if (isDark) com.luck.picture.lib.R.drawable.ps_preview_gallery_bg else R.drawable.preview_gallery_white_bg
        mainStyle.adapterPreviewGalleryFrameResource = R.drawable.preview_gallery_item
        mainStyle.previewBackgroundColor = background

        bottomBar.isCompleteCountTips = false
        bottomBar.bottomOriginalTextSize = Constant.TOOLBAR_TEXT_SIZE
        bottomBar.bottomSelectNumTextSize = Constant.TOOLBAR_TEXT_SIZE
//        bottomBar.bottomPreviewNormalTextSize = Constant.TOOLBAR_TEXT_SIZE
//        bottomBar.bottomEditorTextSize = Constant.TOOLBAR_TEXT_SIZE

        // MAIN STYLE
        mainStyle.isCompleteSelectRelativeTop = false
        mainStyle.isPreviewDisplaySelectGallery = true
        mainStyle.isAdapterItemIncludeEdge = true
        mainStyle.isPreviewSelectRelativeBottom = false
//        mainStyle.previewSelectTextSize = Constant.TOOLBAR_TEXT_SIZE
        mainStyle.selectTextColor = primaryColor
//        mainStyle.selectTextSize = Constant.TOOLBAR_TEXT_SIZE
        mainStyle.selectBackground = selectType
        mainStyle.isSelectNumberStyle = isNumber
        mainStyle.previewSelectBackground = selectType
        mainStyle.isPreviewSelectNumberStyle = isNumber

        // custom toolbar text
        config.text.let { text ->
            text?.finish.let {
                mainStyle.selectText = it
                mainStyle.selectNormalText = it
                mainStyle.selectText = it
            }

            text?.preview.let {
                mainStyle.previewSelectText = it
            }

            text?.original.let {
                bottomBar.bottomOriginalText = it
            }

            text?.edit.let {
                bottomBar.bottomEditorText = it
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

    private fun handleSelectedAssets(config: NitroConfig) {
        val assets = config.selectedAssets
        val assetIds = assets.map { it.localIdentifier }.toSet()
        dataList = dataList.filter { media ->
            assetIds.contains(media.id.toString())
        }.toMutableList()
    }

    private fun getResult(item: LocalMedia): PickerResult {

        val type: ResultType =
            if (item.mimeType.startsWith("video/")) ResultType.VIDEO else ResultType.IMAGE

        var path = item.path
        var width: Double = item.width.toDouble()
        var height: Double = item.height.toDouble()

        val thumbnail = item.videoThumbnailPath?.let {
            if (!it.startsWith("file://")) "file://$it" else it
        }

        if (item.isCut) {
            path = "file://${item.cutPath}"
            width = item.cropImageWidth.toDouble()
            height = item.cropImageHeight.toDouble()
        }

        if (!path.startsWith("file://") && !path.startsWith("content://") && type == ResultType.IMAGE)
            path = "file://$path"

        val media = PickerResult(
            localIdentifier = item.id.toString(),
            width,
            height,
            mime = item.mimeType,
            size = item.size.toDouble(),
            bucketId = item.bucketId.toDouble(),
            realPath = item.realPath,
            parentFolderName = item.parentFolderName,
            creationDate = item.dateAddedTime.toDouble(),
            crop = item.isCut,
            path,
            type,
            fileName = item.fileName,
            thumbnail = thumbnail,
            duration = item.duration.toDouble()
        )

        return media
    }

    override fun getAppContext(): Context {
        return reactApplicationContext
    }

    override fun getPictureSelectorEngine(): PictureSelectorEngine {
        return PictureSelectorEngineImp()
    }
}