package com.margelo.nitro.multipleimagepicker

import com.margelo.nitro.NitroModules
import com.margelo.nitro.multipleimagepicker.HybridMultipleImagePickerSpec
import com.margelo.nitro.multipleimagepicker.NitroConfig
import com.margelo.nitro.multipleimagepicker.Result


class MultipleImagePicker: HybridMultipleImagePickerSpec() {
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




}