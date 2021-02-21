package com.reactnativemultipleimagepicker

import android.util.Log
import com.luck.picture.lib.engine.ImageEngine
import com.luck.picture.lib.engine.PictureSelectorEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.listener.OnResultCallbackListener

class PictureSelectorEngineImp : PictureSelectorEngine {
  override fun createEngine(): ImageEngine {
    return GlideEngine.createGlideEngine()!!
  }

  override fun getResultCallbackListener(): OnResultCallbackListener<LocalMedia?> {
    return object : OnResultCallbackListener<LocalMedia?> {
      override fun onResult(result: List<LocalMedia?>) {
        Log.i(TAG, "onResult:" + result.size)
      }

      override fun onCancel() {
        Log.i(TAG, "PictureSelector onCancel")
      }
    }
  }

  companion object {
    private val TAG = PictureSelectorEngineImp::class.java.simpleName
  }
}
