
/**
 * Copyright (c) Facebook, Inc. and its affiliates.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

package com.facebook.react.views.text;

import javax.annotation.Nullable;

import android.content.res.AssetManager;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.text.TextPaint;
import android.text.style.MetricAffectingSpan;

public class CustomStyleSpan extends MetricAffectingSpan implements ReactSpan {

  /**
   * A {@link MetricAffectingSpan} that allows to change the style of the displayed font.
   * CustomStyleSpan will try to load the fontFamily with the right style and weight from the
   * assets. The custom fonts will have to be located in the res/assets folder of the application.
   * The supported custom fonts extensions are .ttf and .otf. For each font family the bold,
   * italic and bold_italic variants are supported. Given a "family" font family the files in the
   * assets/fonts folder need to be family.ttf(.otf) family_bold.ttf(.otf) family_italic.ttf(.otf)
   * and family_bold_italic.ttf(.otf). If the right font is not found in the assets folder
   * CustomStyleSpan will fallback on the most appropriate default typeface depending on the style.
   * Fonts are retrieved and cached using the {@link ReactFontManager}
   */

  private final AssetManager mAssetManager;

  private final int mStyle;
  private final int mWeight;
  private final @Nullable String mFontFamily;
  private final @Nullable String mFontPath;

  public CustomStyleSpan(
      int fontStyle,
      int fontWeight,
      @Nullable String fontFamily,
      @Nullable String fontPath,
      AssetManager assetManager) {
    mStyle = fontStyle;
    mWeight = fontWeight;
    mFontFamily = fontFamily;
    mFontPath = fontPath;
    mAssetManager = assetManager;
  }

  public CustomStyleSpan(
      int fontStyle,
      int fontWeight,
      @Nullable String fontFamily,
      AssetManager assetManager) {
    mStyle = fontStyle;
    mWeight = fontWeight;
    mFontFamily = fontFamily;
    mFontPath = null;
    mAssetManager = assetManager;
  }

  @Override
  public void updateDrawState(TextPaint ds) {
    apply(ds, mStyle, mWeight, mFontFamily, mFontPath, mAssetManager);
  }

  @Override
  public void updateMeasureState(TextPaint paint) {
    apply(paint, mStyle, mWeight, mFontFamily,mFontPath, mAssetManager);
  }

  /**
   * Returns {@link Typeface#NORMAL} or {@link Typeface#ITALIC}.
   */
  public int getStyle() {
    return (mStyle == ReactTextShadowNode.UNSET ? 0 : mStyle);
  }

  /**
   * Returns {@link Typeface#NORMAL} or {@link Typeface#BOLD}.
   */
  public int getWeight() {
    return (mWeight == ReactTextShadowNode.UNSET ? 0 : mWeight);
  }

  /**
   * Returns the font family set for this StyleSpan.
   */
  public @Nullable String getFontFamily() {
    return mFontFamily;
  }

  /**
   * Returns the font path set for this StyleSpan.
   */
  public @Nullable String getFontPath() {
    return mFontPath;
  }

  private static void apply(
      Paint paint,
      int style,
      int weight,
      @Nullable String family,
      @Nullable String path,
      AssetManager assetManager) {
    int oldStyle;
    Typeface typeface = paint.getTypeface();
    if (typeface == null) {
      oldStyle = 0;
    } else {
      oldStyle = typeface.getStyle();
    }

    int want = 0;
    if ((weight == Typeface.BOLD) ||
        ((oldStyle & Typeface.BOLD) != 0 && weight == ReactTextShadowNode.UNSET)) {
      want |= Typeface.BOLD;
    }

    if ((style == Typeface.ITALIC) ||
        ((oldStyle & Typeface.ITALIC) != 0 && style == ReactTextShadowNode.UNSET)) {
      want |= Typeface.ITALIC;
    }

    if (path != null && family != null) {
      typeface = ReactFontManager.getInstance().getTypeface(path, family, want);
    } else if (family != null) {
      typeface = ReactFontManager.getInstance().getTypeface(family, want, assetManager);
    } else if (typeface != null) {
      // TODO(t9055065): Fix custom fonts getting applied to text children with different style
      typeface = Typeface.create(typeface, want);
    }

    if (typeface != null) {
      paint.setTypeface(typeface);
    } else {
      paint.setTypeface(Typeface.defaultFromStyle(want));
    }
    paint.setSubpixelText(true);
  }

}
