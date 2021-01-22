package com.air.ai_barcode.custom_zxing_scanner

import android.content.Context
import android.graphics.Canvas
import android.view.View
import me.dm7.barcodescanner.core.IViewFinder
import me.dm7.barcodescanner.core.ViewFinderView
import me.dm7.barcodescanner.zxing.ZXingScannerView


class CustomZXingScanner(context: Context?) : ZXingScannerView(context) {
    override fun createViewFinderView(context: Context): IViewFinder {
        return NoViewFinderView(context)
    }

    //make changes in CustomViewFinderView to customise the Viewfinder
    //Check ViewFinderView class for more modifications
    //to change viewFinder's colours override appropriate values in Colors.xml
    internal inner class NoViewFinderView(context: Context) : ViewFinderView(context) {
        override fun drawLaser(canvas: Canvas) {
            //do nothing for no laser, even remove super call
        }

        init {
            visibility = View.GONE
        }
    }
}