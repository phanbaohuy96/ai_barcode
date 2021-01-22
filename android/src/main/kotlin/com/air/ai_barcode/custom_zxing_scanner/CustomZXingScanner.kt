package com.air.ai_barcode.custom_zxing_scanner

import android.content.Context
import android.graphics.Canvas
import android.graphics.Color
import me.dm7.barcodescanner.core.IViewFinder
import me.dm7.barcodescanner.core.ViewFinderView
import me.dm7.barcodescanner.zxing.ZXingScannerView


class CustomZXingScanner(context: Context?) : ZXingScannerView(context) {
    override fun createViewFinderView(context: Context): IViewFinder {
        return NoViewFinderView(context)
    }

    internal inner class NoViewFinderView(context: Context) : ViewFinderView(context) {
        override fun drawLaser(canvas: Canvas) { }

        init {
            setSquareViewFinder(true)
            setBorderColor(Color.TRANSPARENT)
            setBorderAlpha(0f)
            setLaserColor(Color.TRANSPARENT)
            setMaskColor(Color.TRANSPARENT)
            onSetAlpha(0)
        }
    }
}