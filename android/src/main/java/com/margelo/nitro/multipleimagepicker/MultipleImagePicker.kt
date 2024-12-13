package com.margelo.nitro.multipleimagepicker

import com.margelo.nitro.NitroModules


class MultipleImagePicker : HybridMultipleImagePickerSpec() {
    override val memorySize: Long
        get() = 5

    private val pickerModule = MultipleImagePickerImp(NitroModules.applicationContext)

    override fun openPicker(
        config: NitroConfig,
        resolved: (result: Array<Result>) -> Unit,
        rejected: (reject: Double) -> Unit
    ) {
        pickerModule.openPicker(config, resolved, rejected)
    }

    override fun openCrop(
        image: String,
        config: NitroCropConfig,
        resolved: (result: CropResult) -> Unit,
        rejected: (reject: Double) -> Unit
    ) {
        pickerModule.openCrop(image, config, resolved, rejected)
    }

    override fun openPreview(
        media: Array<MediaPreview>,
        index: Double,
        config: NitroPreviewConfig
    ) {
        pickerModule.openPreview(media, index.toInt(), config)
    }

    override fun openCamera(
        config: NitroCameraConfig,
        resolved: (result: CameraResult) -> Unit,
        rejected: (reject: Double) -> Unit
    ) {
        pickerModule.openCamera(config, resolved, rejected)
    }

}