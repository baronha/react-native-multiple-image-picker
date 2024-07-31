package com.reactnativemultipleimagepicker

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
import com.yalantis.ucrop.UCrop.Options
import java.io.*
import java.util.*


class MultipleImagePickerModule(reactContext: ReactApplicationContext) :
        ReactContextBaseJavaModule(reactContext), IApp {

    override fun getName(): String {
        return "MultipleImagePicker"
    }

    private var style = PictureSelectorStyle()

    private var selectedAssets: List<LocalMedia> = ArrayList()
    private var singleSelectedMode: Boolean = false
    private var maxVideoDuration: Int = 60
    private var numberOfColumn: Int = 3
    private var maxSelectedAssets: Int = 20
    private var mediaType: String = "all"
    private var isPreview: Boolean = true
    private var isExportThumbnail: Boolean = false
    private var maxVideo: Int = 20
    private var isCamera: Boolean = true
    private var cropOption: Options? = null
    private var primaryColor: Int = Color.BLACK


    @ReactMethod
    fun openPicker(options: ReadableMap?, promise: Promise): Unit {
        PictureAppMaster.getInstance().app = this
        val activity = currentActivity
        val imageEngine = GlideEngine.createGlideEngine()

        // set config
        setConfiguration(options)

        PictureSelector.create(activity)
                .openGallery(if (mediaType == "video") SelectMimeType.ofVideo() else if (mediaType == "image") SelectMimeType.ofImage() else SelectMimeType.ofAll())
                .setImageEngine(imageEngine)
                .setMaxSelectNum(maxSelectedAssets)
                .setImageSpanCount(numberOfColumn)
                .setCropEngine(onSetCropEngine())
                .isDirectReturnSingle(true)
                .isSelectZoomAnim(true)
                .isPageStrategy(true, 50)
                .isWithSelectVideoImage(true)
                .setRecordVideoMaxSecond(maxVideoDuration)
                .setMaxVideoSelectNum(if (maxVideo != 20) maxVideo else maxSelectedAssets)
                .isMaxSelectEnabledMask(true)
                .setSelectedData(selectedAssets)
                .setSelectorUIStyle(style)
                .isPreviewImage(isPreview)
                .isPreviewVideo(isPreview)
                .isDisplayCamera(isCamera)
                .setSelectionMode(if (singleSelectedMode) SelectModeConfig.SINGLE else SelectModeConfig.MULTIPLE)
                .forResult(object : OnResultCallbackListener<LocalMedia?> {
                    override fun onResult(result: ArrayList<LocalMedia?>?) {
                        val localMedia: WritableArray = WritableNativeArray()
                        if (result?.size == 0) {
                            promise.resolve(localMedia)
                            return
                        }
                        if (result?.size == selectedAssets.size && (result[result.size - 1] as LocalMedia).id == (selectedAssets[selectedAssets.size - 1].id)) {
                            return
                        }
                        if (result != null) {
                            for (i in 0 until result.size) {
                                val item: LocalMedia = result[i] as LocalMedia
                                val media: WritableMap = createAttachmentResponse(item)
                                localMedia.pushMap(media)
                            }
                        }
                        promise.resolve(localMedia)
                    }

                    override fun onCancel() {
                        promise.reject("PICKER_CANCELLED", "User has canceled", null)
                    }
                })
    }

    private fun onSetCropEngine(): CropEngine? {
        return cropOption?.let { CropEngine(it) }
    }

    private fun setConfiguration(options: ReadableMap?) {
        if (options != null) {
            handleSelectedAssets(options)
            singleSelectedMode = options.getBoolean("singleSelectedMode")
            maxVideoDuration = options.getInt("maxVideoDuration")
            numberOfColumn = options.getInt("numberOfColumn")
            maxSelectedAssets = options.getInt("maxSelectedAssets")
            mediaType = options.getString("mediaType").toString()
            isPreview = options.getBoolean("isPreview")
            isExportThumbnail = options.getBoolean("isExportThumbnail")
            maxVideo = options.getInt("maxVideo")
            isCamera = options.getBoolean("usedCameraButton")

            setStyle(options) // set style for UI

            val isCrop = options.getBoolean("isCrop") && singleSelectedMode

            if (isCrop) {
                setCropOptions(options)
            } else {
                cropOption = null
            }
        }
    }

    @SuppressLint("ResourceAsColor")
    private fun setCropOptions(libOption: ReadableMap) {
        val options = Options()
        val mainStyle: SelectMainStyle = style.selectMainStyle

        options.setShowCropFrame(true)
        options.setShowCropGrid(true)
        options.setCircleDimmedLayer(libOption.getBoolean("isCropCircle"))
        options.setCropOutputPathDir(getSandboxPath(appContext))
        options.isCropDragSmoothToCenter(false)
        options.isForbidSkipMultipleCrop(true)
        options.setMaxScaleMultiplier(100f)
        options.setLogoColor(primaryColor)
        options.setToolbarWidgetColor(Color.BLACK)
        options.setStatusBarColor(mainStyle.statusBarColor)
        options.isDarkStatusBarBlack(mainStyle.isDarkStatusBarBlack)

        cropOption = options
    }

    private fun setStyle(options: ReadableMap) {
        val doneTitle = options.getString("doneTitle")

        primaryColor = Color.parseColor(options.getString("selectedColor"))

        // ANIMATION SLIDE FROM BOTTOM
        val animationStyle = PictureWindowAnimationStyle()
        animationStyle.setActivityEnterAnimation(R.anim.ps_anim_up_in)
        animationStyle.setActivityExitAnimation(R.anim.ps_anim_down_out)

        // TITLE BAR
        val titleBar = TitleBarStyle()
        titleBar.titleBackgroundColor =
                ContextCompat.getColor(appContext, R.color.app_color_white)

        titleBar.isHideCancelButton = true
        titleBar.isAlbumTitleRelativeLeft = true

        titleBar.titleAlbumBackgroundResource = R.drawable.ps_album_bg
        titleBar.titleDrawableRightResource = R.drawable.ps_ic_grey_arrow
        titleBar.previewTitleLeftBackResource = R.drawable.ps_ic_black_back
        titleBar.titleLeftBackResource = R.drawable.ps_ic_black_back
        titleBar.isHideCancelButton = true

        // BOTTOM BAR
        val bottomBar = BottomNavBarStyle()
        bottomBar.bottomPreviewNormalTextColor =
                ContextCompat.getColor(appContext, R.color.app_color_pri)
        bottomBar.bottomPreviewSelectTextColor =
                ContextCompat.getColor(appContext, R.color.app_color_pri)
        bottomBar.bottomNarBarBackgroundColor =
                ContextCompat.getColor(appContext, R.color.ps_color_white)
        bottomBar.bottomSelectNumResources = R.drawable.num_oval_orange
        bottomBar.bottomEditorTextColor =
                ContextCompat.getColor(appContext, R.color.ps_color_53575e)
        bottomBar.bottomOriginalTextColor =
                ContextCompat.getColor(appContext, R.color.ps_color_53575e)
        bottomBar.bottomPreviewNormalTextColor = R.color.app_color_53575e
        bottomBar.bottomPreviewNormalTextColor = Color.BLACK
        bottomBar.isCompleteCountTips = false

        // MAIN STYLE
        val mainStyle = SelectMainStyle()

        mainStyle.isPreviewSelectRelativeBottom = true
        mainStyle.isSelectNumberStyle = !singleSelectedMode
        mainStyle.isPreviewSelectNumberStyle = true
        mainStyle.isSelectNumberStyle = true
        mainStyle.selectBackground = R.drawable.picture_selector
        mainStyle.mainListBackgroundColor =
                ContextCompat.getColor(appContext, R.color.ps_color_white)
        mainStyle.previewSelectBackground =
                R.drawable.picture_selector

        // custom select text on top
        mainStyle.selectText = doneTitle
        mainStyle.isCompleteSelectRelativeTop = true
        mainStyle.selectNormalText = doneTitle


        mainStyle.selectNormalTextColor =
                ContextCompat.getColor(appContext, R.color.ps_color_9b)
        mainStyle.selectTextColor = primaryColor
        mainStyle.selectText = doneTitle

        mainStyle.statusBarColor = ContextCompat.getColor(
            appContext,
            R.color.app_color_white
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
                    selectedAssets = list
                    return
                }
                selectedAssets = emptyList()
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

    private fun createAttachmentResponse(item: LocalMedia): WritableMap {
        val media: WritableMap = WritableNativeMap()
        val type: String = if (item.mimeType.startsWith("video/")) "video" else "image"
        media.putString("path", item.path)
        media.putString("realPath", item.realPath)
        media.putString("fileName", item.fileName)
        media.putInt("width", item.width)
        media.putInt("height", item.height)
        media.putString("mime", item.mimeType)
        media.putString("type", type)
        media.putInt("localIdentifier", item.id.toInt())
        media.putInt("position", item.position)
        media.putInt("chooseModel", item.chooseModel)
        media.putDouble("duration", item.duration.toDouble())
        media.putDouble("size", item.size.toDouble())
        media.putDouble("bucketId", item.bucketId.toDouble())
        media.putString("parentFolderName", item.parentFolderName)
        if (item.isCut) {
            val crop = WritableNativeMap()
            crop.putString("path", "file://${item.cutPath}")
            crop.putDouble("width", item.cropImageWidth.toDouble())
            crop.putDouble("height", item.cropImageHeight.toDouble())
            media.putMap("crop", crop)
        }
        if (type === "video" && isExportThumbnail) {
            val thumbnail = createThumbnail(item.realPath)
            media.putString("thumbnail", thumbnail)
        }
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
