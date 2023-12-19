package com.reactnativemultipleimagepicker

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Color
import android.media.MediaMetadataRetriever
import android.os.Build
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat
import com.bumptech.glide.Glide
import com.facebook.react.bridge.*
import com.luck.lib.camerax.SimpleCameraX
import com.luck.picture.lib.app.IApp
import com.luck.picture.lib.app.PictureAppMaster
import com.luck.picture.lib.basic.PictureSelector
import com.luck.picture.lib.config.SelectMimeType
import com.luck.picture.lib.config.SelectModeConfig
import com.luck.picture.lib.engine.CompressFileEngine
import com.luck.picture.lib.engine.PictureSelectorEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.entity.LocalMedia.generateLocalMedia
import com.luck.picture.lib.entity.MediaExtraInfo
import com.luck.picture.lib.interfaces.OnResultCallbackListener
import com.luck.picture.lib.style.*
import com.luck.picture.lib.utils.MediaUtils
import com.yalantis.ucrop.UCrop
import top.zibin.luban.Luban
import top.zibin.luban.OnNewCompressListener
import java.io.*
import java.util.*


@Suppress("INCOMPATIBLE_ENUM_COMPARISON", "UNCHECKED_CAST")
class MultipleImagePickerModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext), IApp {

    override fun getName(): String {
        return "MultipleImagePicker"
    }

    var style = PictureSelectorStyle()

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
    private var cropOption: UCrop.Options? = null;
    private var primaryColor: Int = Color.BLACK;
    private var compressSize: Int = 10240; //Do not compress when the origin image file size less than one value, default 10Kb


    @ReactMethod
    fun openPicker(options: ReadableMap?, promise: Promise): Unit {
        PictureAppMaster.getInstance().app = this
        val activity = currentActivity
        var imageEngine = GlideEngine.createGlideEngine();

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
            .setCameraInterceptListener { fragment, cameraMode, requestCode ->
                val camera = SimpleCameraX.of()
                camera.setCameraMode(cameraMode)
                camera.setImageEngine { context, url, imageView ->
                    Glide.with(
                        context
                    ).load(url).into(imageView)
                }
                camera.start(fragment.requireActivity(), fragment, requestCode)
            }
            .setCompressEngine(CompressFileEngine { context, source, call ->
                Luban.with(context).load(source).ignoreBy(compressSize).setCompressListener(object: OnNewCompressListener{
                    override fun onStart() {
                    }

                    override fun onSuccess(source: String?, compressFile: File?) {
                        if (compressFile != null) {
                            call?.onCallback(source,compressFile.absolutePath)
                        }else{
                            call?.onCallback(source,null)
                        }
                    }

                    override fun onError(source: String?, e: Throwable?) {
                        call?.onCallback(source,null)
                    }
                }).launch()
            })
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
            if(options.hasKey("compressSize")) compressSize = options.getInt("compressSize")
            

            val isCrop = options.getBoolean("isCrop") && singleSelectedMode == true

            if (isCrop) {
                setCropOptions(options)
            } else {
                cropOption = null
            }
        }
    }

    private fun setCropOptions(libOption: ReadableMap) {
        val options = UCrop.Options()
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

    private fun handleSelectedAssets(options: ReadableMap?) {
        if (options?.hasKey("selectedAssets")!!) {
            val assetsType = options.getType("selectedAssets")
            if (assetsType == ReadableType.Array) {
                val assets: ReadableNativeArray =
                    options.getArray("selectedAssets") as ReadableNativeArray
                if (assets.size() > 0) {
                    val list = mutableListOf<LocalMedia>()
                    for (i in 0 until assets.size()) {
                        val asset: ReadableNativeMap = assets.getMap(i) as ReadableNativeMap
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

    @RequiresApi(Build.VERSION_CODES.LOLLIPOP)
    private fun createAttachmentResponse(item: LocalMedia): WritableMap {
        val media: WritableMap = WritableNativeMap()
        var width: Int = item.width;
        var height: Int = item.height;
        var fileSize: Long = item.size;
        var path: String = item.path;
        if(item.isCompressed){
            val info: MediaExtraInfo = MediaUtils.getImageSize(reactApplicationContext,item.compressPath);
            width = info.width
            height = info.height
            fileSize = File(item.compressPath).length()
            path = item.compressPath;
        }
        val type: String = if (item.mimeType.startsWith("video/")) "video" else "image"
        media.putString("path", path)
        media.putString("realPath", item.realPath)
        media.putString("fileName", item.fileName)
        media.putInt("width", width)
        media.putInt("height", height)
        media.putString("mime", item.mimeType)
        media.putString("type", type)
        media.putInt("localIdentifier", item.id.toInt())
        media.putInt("position", item.position)
        media.putInt("chooseModel", item.chooseModel)
        media.putDouble("duration", item.duration.toDouble())
        media.putDouble("size", fileSize.toDouble())
        media.putDouble("bucketId", item.bucketId.toDouble())
        media.putString("parentFolderName", item.parentFolderName)
        if (item.isCut) {
            val crop = WritableNativeMap()
            crop.putString("path", item.cutPath)
            crop.putDouble("width", item.cropImageWidth.toDouble())
            crop.putDouble("height", item.cropImageHeight.toDouble())
            crop.putDouble("size", File(item.cutPath).length().toDouble())
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

    private fun createDirIfNotExists(path: String): File {
        val dir = File(path)
        if (dir.exists()) {
            return dir
        }
        try {
            dir.mkdirs()
            // Add .nomedia to hide the thumbnail directory from gallery
            val noMedia = File(path, ".nomedia")
            noMedia.createNewFile()
        } catch (e: IOException) {
            e.printStackTrace()
        }
        return dir
    }

    override fun getAppContext(): Context {
        return reactApplicationContext
    }

    override fun getPictureSelectorEngine(): PictureSelectorEngine {
        return PictureSelectorEngineImp()
    }

}
