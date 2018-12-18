/**

Copyright (c) 2009 Todd M. Yard

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

*/
package aether.effects.common {

	import aether.effects.ImageEffect;
	import aether.utils.ImageUtil;
	
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	
	/**
	 * The CompositeEffect class provides the means to combine multiple effects and apply them at once, with the 
	 * additional feature of allowing the whole composite effect applied to the original image as an overlay
	 * using an alpha and blend mode.
	 * 
	 * The class also allows for a separate bitmap data to be affected than the one passed to its apply method.
	 * This is to enable nested composite effects to use an unaffected copy of the original, as is demonstrated
	 * in the example below.
	 * 
	 * <pre>
	 * // the following demonstrates a nested composite effect that is overlaid on top of other effects using
	 * // a SCREEN blend mode; since the bitmap data is altered by the preceding effects before it reaches the
	 * // nested composite, the nested composite is passed the original, unaltered image to affect
	 * 
	 * new CompositeEffect(
	 *   [
	 *   new PosterizeEffect(),
	 *   new BlurEffect(2, 2),
	 *   new LevelsEffect(0, 100, 160),
	 *   new SaturationEffect(.2),
	 *   // a second composite it used here so that this subeffect
	 *   // can be applied to the original image and then overlaid
	 *   // using another blend mode
	 *   new CompositeEffect(
	 *     [
	 *     new FindEdgesEffect(),
	 *     new SaturationEffect(0),
	 *     new LevelsEffect(50, 127, 200)
	 *     ], bitmapData, BlendMode.SCREEN
	 *   )
	 *   ]
	 * ).apply(image);
	 * </pre>
	 */
	public class CompositeEffect extends ImageEffect {
	
		private var _bitmapToAffect:BitmapData;
		private var _effects:Array;
	
		/**
		 * Constructor.
		 * 
		 * @param effects The array of image effects to apply as a composite effect.
		 * @param bitmapToEffect The bitmap to which to apply the effect. This allows for the composite to be applied
		 *                       to data other than that specified in the apply() method, which is useful for nested
		 *                       composite effects.
		 * @param blendMode The blend mode to use, if any, in the final effect. This should be a constant of
		 *                  <code>BlendMode</code>. Setting this will result in the effect being applied as an
		 *                  overlay of the original image.
		 * @param alpha The alpha to apply, if other than the default 1, in the final effect. Setting this will result
		 *              in the effect being applied as an overlay of the original image.
		 */
		public function CompositeEffect(
			effects:Array,
			bitmapToAffect:BitmapData=null,
			blendMode:String=null,
			alpha:Number=1
		) {
			init(blendMode, alpha);
			_effects = effects;
			_bitmapToAffect = bitmapToAffect;
		}
	
		/**
		 * @inheritDoc
		 */
		override protected function applyEffect(bitmapData:BitmapData):void {
			for each (var effect:ImageEffect in _effects) {
				effect.apply(bitmapData);
			}
		}
	
		/**
		 * @inheritDoc
		 */
		override public function apply(bitmapData:BitmapData):void {
			if (_bitmapToAffect == null) {
				super.apply(bitmapData);
			} else {
				var clone:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
				ImageUtil.copyPixels(_bitmapToAffect, clone);
				applyEffect(clone);
				bitmapData.draw(clone, null, new ColorTransform(1, 1, 1, _alpha), _blendMode);
			}
		}

	}
	
}