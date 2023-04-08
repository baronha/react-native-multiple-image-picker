package com.reactnativemultipleimagepicker

import android.util.Log
import com.luck.picture.lib.basic.IBridgeLoaderFactory
import com.luck.picture.lib.config.InjectResourceSource
import com.luck.picture.lib.engine.*
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.interfaces.OnInjectLayoutResourceListener
import com.luck.picture.lib.interfaces.OnResultCallbackListener

class PictureSelectorEngineImp : PictureSelectorEngine {
    /**
     * 重新创建[ImageEngine]引擎
     *
     * @return
     */
    override fun createImageLoaderEngine(): ImageEngine {
        return GlideEngine.createGlideEngine()
    }

    /**
     * 重新创建[CompressEngine]引擎
     *
     * @return
     */
    override fun createCompressEngine(): CompressEngine? {
        // TODO 这种情况是内存极度不足的情况下，比如开启开发者选项中的不保留活动或后台进程限制，导致CompressEngine被回收
        return null
    }

    /**
     * 重新创建[CompressEngine]引擎
     *
     * @return
     */
    override fun createCompressFileEngine(): CompressFileEngine? {
        // TODO 这种情况是内存极度不足的情况下，比如开启开发者选项中的不保留活动或后台进程限制，导致CompressFileEngine被回收
        return null
    }

    /**
     * 重新创建[ExtendLoaderEngine]引擎
     *
     * @return
     */
    override fun createLoaderDataEngine(): ExtendLoaderEngine? {
        return null
    }

    override fun createVideoPlayerEngine(): VideoPlayerEngine<*>? {
        return null
    }

    override fun onCreateLoader(): IBridgeLoaderFactory? {
        return null
    }

    /**
     * 重新创建[SandboxFileEngine]引擎
     *
     * @return
     */
    override fun createSandboxFileEngine(): SandboxFileEngine? {
        return null
    }

    override fun createUriToFileTransformEngine(): UriToFileTransformEngine? {
        return null
    }

    override fun createLayoutResourceListener(): OnInjectLayoutResourceListener? {
        return null
    }

    override fun getResultCallbackListener(): OnResultCallbackListener<LocalMedia?> {
        return object : OnResultCallbackListener<LocalMedia?> {
            override fun onResult(result: ArrayList<LocalMedia?>) {

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