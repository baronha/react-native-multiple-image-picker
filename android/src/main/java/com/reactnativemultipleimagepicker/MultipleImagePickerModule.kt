package com.reactnativemultipleimagepicker

import android.content.Context
import android.graphics.Color
import com.facebook.react.bridge.*
import com.luck.picture.lib.PictureSelector
import com.luck.picture.lib.app.IApp
import com.luck.picture.lib.app.PictureAppMaster
import com.luck.picture.lib.config.PictureConfig
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.engine.PictureSelectorEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.listener.OnResultCallbackListener
import com.luck.picture.lib.style.PictureParameterStyle
import java.util.*

@Suppress("INCOMPATIBLE_ENUM_COMPARISON", "UNCHECKED_CAST")
class MultipleImagePickerModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext), IApp {

    override fun getName(): String {
        return "MultipleImagePicker"
    }

    private var selectedAssets: List<LocalMedia> = ArrayList()
    private var mPictureParameterStyle: PictureParameterStyle? = null
    private var singleSelectedMode: Boolean = false;
    private var maxVideoDuration: Int = 60;
    private var numberOfColumn: Int = 3
    private var maxSelectedAssets: Int = 20
    private var allowedVideo: Boolean = true
    private var isPreview: Boolean = true

    @ReactMethod
    public fun openPicker(options: ReadableMap?, promise: Promise): Unit {
        PictureAppMaster.getInstance().app = this
        val activity = currentActivity
        setConfiguration(options)

        PictureSelector.create(activity)
                .openGallery(if (allowedVideo) PictureMimeType.ofAll() else PictureMimeType.ofImage())
                .loadImageEngine(GlideEngine.createGlideEngine())
                .maxSelectNum(maxSelectedAssets)
                .imageSpanCount(numberOfColumn)
                .isZoomAnim(true)
                .isPageStrategy(true, 50)
                .isWithVideoImage(true)
                .videoMaxSecond(maxVideoDuration)
                .maxVideoSelectNum(maxSelectedAssets)
                .isMaxSelectEnabledMask(true)
                .selectionData(selectedAssets)
                .setPictureStyle(mPictureParameterStyle)
                .isPreviewImage(isPreview)
                .isPreviewVideo(isPreview)
                .isReturnEmpty(true)
                .selectionMode(if (singleSelectedMode) PictureConfig.SINGLE else PictureConfig.MULTIPLE)
                .forResult(object : OnResultCallbackListener<Any?> {
                    override fun onResult(result: MutableList<Any?>?) {
                        //check difference
                        if (singleSelectedMode) {
                            val media: WritableMap = createAttachmentResponse(result?.get(0) as LocalMedia);
                            promise.resolve(media);
                            return;
                        }
                        val localMedia: WritableArray = WritableNativeArray();
                        if (result?.size == 0) {
                            promise.resolve(localMedia);
                            return;
                        }
                        if (result?.size == selectedAssets.size && (result[result.size - 1] as LocalMedia).id == (selectedAssets[selectedAssets.size - 1].id)) {
                            return;
                        }
                        if (result != null) {
                            for (i in 0 until result.size) {
                                val item: LocalMedia = result[i] as LocalMedia;
                                val media: WritableMap = createAttachmentResponse(item)
                                localMedia.pushMap(media)
                            }
                        }
                        promise.resolve(localMedia);
                    }

                    override fun onCancel() {
                        promise.reject("user cancel")
                    }
                })
    }

    private fun setConfiguration(options: ReadableMap?) {
        if (options != null) {
            handleSelectedAssets(options)
            singleSelectedMode = options.getBoolean("singleSelectedMode");
            maxVideoDuration = options.getInt("maxVideoDuration")
            numberOfColumn = options.getInt("numberOfColumn")
            maxSelectedAssets = options.getInt("maxSelectedAssets")
            allowedVideo = options.getBoolean("allowedVideo")
            isPreview = options.getBoolean("isPreview")

            mPictureParameterStyle = getStyle(options);
        }
    }

    private fun getStyle(options: ReadableMap): PictureParameterStyle? {
        val pictureStyle = PictureParameterStyle()
        pictureStyle.pictureCheckedStyle = R.drawable.picture_selector

        //bottom style
        pictureStyle.pictureCompleteText = options.getString("doneTitle")
        pictureStyle.isOpenCheckNumStyle = true
        pictureStyle.isCompleteReplaceNum = true
        pictureStyle.pictureCompleteTextSize = 16
        pictureStyle.pictureCheckNumBgStyle = R.drawable.num_oval_orange
        pictureStyle.pictureCompleteTextColor = Color.parseColor("#ffffff")
        pictureStyle.pictureNavBarColor = Color.parseColor("#000000")
        pictureStyle.pictureBottomBgColor = Color.parseColor("#393a3e")
        //preview Style
        pictureStyle.picturePreviewBottomBgColor = Color.parseColor("#000000")
        pictureStyle.pictureUnPreviewTextColor = Color.parseColor("#ffffff")
        //header
        pictureStyle.pictureTitleDownResId = R.drawable.picture_icon_arrow_down
        pictureStyle.pictureCancelTextColor = Color.parseColor("#393a3e")
        pictureStyle.pictureStatusBarColor = Color.parseColor("#393a3e")
        pictureStyle.pictureTitleBarBackgroundColor = Color.parseColor("#393a3e")
        return pictureStyle
    }

    private fun handleSelectedAssets(options: ReadableMap?) {
        if (options?.hasKey("selectedAssets")!!) {
            val assetsType = options.getType("selectedAssets")
            if (assetsType == ReadableType.Array) {
                val assets: ReadableNativeArray = options.getArray("selectedAssets") as ReadableNativeArray
                if (assets.size() > 0) {
                    val list = mutableListOf<LocalMedia>()
                    for (i in 0 until assets.size()) {
                        val asset: ReadableNativeMap = assets.getMap(i) as ReadableNativeMap
                        val localMedia: LocalMedia = handleSelectedAssetItem(asset)
                        list.add(localMedia)
                    }
                    selectedAssets = list
                    return;
                }
                selectedAssets = emptyList();
            }
            if (assetsType == ReadableType.Map) {
                println("type Map");
            }
        }
    }

    private fun handleSelectedAssetItem(asset: ReadableNativeMap): LocalMedia {
        val id: Long? = asset.getDouble("localIdentifier").toLong()
        val path: String? = asset.getString("path")
        val realPath: String? = asset.getString("realPath")
        val fileName: String? = asset.getString("fileName")
        val parentFolderName: String? = asset.getString("parentFolderName")
        val duration: Long? = asset.getDouble("duration").toLong()
        val chooseModel: Int? = asset.getInt("chooseModel")
        val mimeType: String? = asset.getString("mine")
        val width: Int? = asset.getInt("width")
        val height: Int? = asset.getInt("height")
        val size: Long? = asset.getDouble("size").toLong()
        val bucketId: Long? = asset.getDouble("bucketId").toLong()
        val localMedia = LocalMedia(id!!, path, realPath, fileName, parentFolderName, duration!!, chooseModel!!, mimeType, width!!, height!!, size!!, bucketId!!);
        return localMedia
    }

    private fun createAttachmentResponse(item: LocalMedia): WritableMap {
        val media: WritableMap = WritableNativeMap();
        media.putString("path", item.path);
        media.putString("realPath", item.realPath);
        media.putString("fileName", item.fileName);
        media.putInt("width", item.width);
        media.putInt("height", item.height);
        media.putString("mine", item.mimeType);
        media.putString("type", if (item.mimeType.startsWith("video/")) "video" else "image");
        media.putInt("localIdentifier", item.id.toInt());
        media.putInt("position", item.position);
        media.putInt("chooseModel", item.chooseModel);
        media.putDouble("duration", item.duration.toDouble());
        media.putDouble("size", item.size.toDouble());
        media.putDouble("bucketId", item.bucketId.toDouble());
        media.putString("parentFolderName", item.parentFolderName);
        return media
    }

    override fun getAppContext(): Context {
        return reactApplicationContext
    }

    override fun getPictureSelectorEngine(): PictureSelectorEngine {
        return PictureSelectorEngineImp()
    }

}

