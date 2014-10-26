package kernel
{
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.filters.*;
	
	public class Lighting extends Sprite
	{
        public var distanceMap          :BitmapData;
        public var reducedDistanceMap   :BitmapData;
        public var result   :BitmapData;
        public var resultBlurTemp   :BitmapData;
        public var obstacleMap   :BitmapData;
        public var dataBMP   :Bitmap;
        public var resultBMP   :Bitmap;
        public var obstacles   :Sprite;
        
		public const BLUR:Number = 2;
		public const LIGHT_RADIUS:Number = 20.5;
		public const TWO_PI:Number = 6.3;
		
		public var NUM_OBSTACLES:int = 0;
		public const OBSTACLE_SIZE:int = 16;
		public const OBSTACLE_SIZE_VAR:int = 0;
		
		public const DIST_BLUR_FACTOR:Number = 0.1;
		public const DIST_BLUR_THRESHOLD:Number = 0.9;
		
		public var gr:Array = [];
		public var mx:Number = 160;
	    public var my:Number = 120;
            
        public function Lighting() 
        {

			// ARRAY POPULATION			
			gr = new Array(80); 
			for(var arrCreationCount:int = 0; arrCreationCount < gr.length; arrCreationCount++) 
			{    
			 gr[arrCreationCount] = new Array(60); 
			}
			
            init();
            //addEventListener(MouseEvent.MOUSE_MOVE, mainLoop);
        }
        
        private function init():void 
        {
            
            result             = new BitmapData(320, 240, false, 0xFFFFFF);
            resultBlurTemp     = new BitmapData(320, 240, false, 0xFFFFFF);
            obstacleMap        = new BitmapData(320, 240, false, 0xFFFFFF);
            distanceMap        = new BitmapData(240, 240, false, 0xFFFFFF);
            reducedDistanceMap = new BitmapData(  1, 240, false, 0xFFFFFF);
            
            dataBMP = new Bitmap();
            //dataBMP.scaleX=dataBMP.scaleY=2;
            //this.addChild(dataBMP);
            
            resultBMP = new Bitmap(result);
            //resultBMP.scaleX=resultBMP.scaleY=2;
            //resultBMP.scaleX =  320 / result.width;
            //resultBMP.scaleY =  240/ result.height;
            //this.addChild(resultBMP);
            
            obstacles = new Sprite();
            //addChild(obstacles);

            //regenerateObstacles();
        }
        
        private function mainLoop(e:Event = null):void 
        {
            result.lock();
            distanceMap.lock();
            reducedDistanceMap.lock();
            
            //pre-processing
            updateDistanceMap();
            reduceDistanceMap();
            
            //rendering
            result.fillRect(result.rect, 0xFFFFFF);
            renderLight();
            blurLight();
            renderObstacles();
            
            result.unlock();
            distanceMap.unlock();
            reducedDistanceMap.unlock();
        }
        
        private function updateDistanceMap():void 
        {
            distanceMap.fillRect(distanceMap.rect, 0xFFFFFF);
            
            //var mx:Number = 160 * obstacleMap.width / 320;
            //var my:Number = 120 * obstacleMap.height / 240;
            
            for (var j:int = 0; j < distanceMap.height; ++j)
            {
                for (var i:int = 0; i < distanceMap.width; ++i)
                {
                    //polar to cartesian
                    var r:Number = LIGHT_RADIUS * (i / distanceMap.width);
                    var t:Number = TWO_PI * (j/ distanceMap.height);
                    var cx:Number = r * Math.cos(t) + mx;
                    var cy:Number = r * Math.sin(t) + my;
                    
                    if 
                    (
                        cx >= 0 && cx <= obstacleMap.width 
                        && cy >= 0 && cy <= obstacleMap.height
                    )
                    {
                        var dx:Number = cx - mx;
                        var dy:Number = cy - my;
                        var dist:Number = Math.sqrt(dx * dx + dy * dy);
                        
                        if (dist > LIGHT_RADIUS)
                        {
                            //out of light radius
                            distanceMap.setPixel(i, j, 0xFFFFFF);
                        }
                        else
                        {
                            //draw distance color
                            var channel:uint = 0xFF * (dist / LIGHT_RADIUS);
                            var color:uint = 0;
                            color |= channel << 16;
                            color |= channel << 8;
                            color |= channel;
                            distanceMap.setPixel
                            (
                                i, j, 
                                (obstacleMap.getPixel(cx, cy) < 0xFFFFFF)
                                ?(color):(0xFFFFFF)
                            );
                        }
                    }
                }
            }
        }
        
        private function reduceDistanceMap():void 
        {
            reducedDistanceMap.fillRect(reducedDistanceMap.rect, 0xFFFFFF);
            for (var t:int = 0; t < reducedDistanceMap.height; ++t)
            {
                for (var i:int = 0; i < distanceMap.width; ++i)
                {
                    var color:uint = distanceMap.getPixel(i, t);
                    if (color != 0xFFFFFF)
                    {
                        reducedDistanceMap.setPixel(0, t, color);
                        break;
                    }
                }
            }
        }
        
        private function renderLight():void 
        {
            //var mx:Number = 160 * result.width / 320;
            //var my:Number = 120 * result.height / 240;
            
			for (var j:int = 0; j < result.width; ++j)
            {
                for (var i:int = 0; i < result.height; ++i)
                {
                    var dx:Number = i - mx;
                    var dy:Number = j - my;
                    var dist:Number = Math.sqrt(dx * dx + dy * dy);
                    var obstacleDist:Number;
                    var color:uint;
                    var channel:uint;
                    var distFactor:Number = Math.atan2(dy, dx);
                    if (distFactor < 0) distFactor += TWO_PI;
                    distFactor /= TWO_PI;
                    
                    obstacleDist = 
                        LIGHT_RADIUS
                        * reducedDistanceMap.getPixel
                        (0, reducedDistanceMap.height * distFactor);
                        
                    obstacleDist /= 0xFFFFFF;
                    
                    if (dist < obstacleDist)
                    {
                        channel = 0xFF * (1 - dist / LIGHT_RADIUS);
                        color = 0;
                        color |= channel << 16;
                        color |= channel << 8;
                        color |= channel;
                    }
                    else
                    {
                        color = 0x000000;
                    }
                    
                    result.setPixel(i, j, color);
                }
            }
        }
        
        private function blurLight():void
        {
            var mx:Number = 160 * result.width / 320;
            var my:Number = 120 * result.height / 240;
            
            resultBlurTemp.copyPixels(result, result.rect, new Point(0, 0));
            
            //distance-based blur
            for (var j:int = 0; j < result.height; ++j)
            {
                for (var i:int = 0; i < result.width; ++i)
                {
                    var dx:Number = i - mx;
                    var dy:Number = j - my;
                    var d:Number = DIST_BLUR_FACTOR 
                        * (Math.sqrt(dx * dx + dy * dy) - DIST_BLUR_THRESHOLD);
                        
                    d = (d < 0)?(0):(d);
                    var channel:uint = 
                        (
                            4 * (result.getPixel(i, j) & 0xFF)
                            + 2 * (result.getPixel(i - d / 2, j - d / 2) & 0xFF)
                            + 2 * (result.getPixel(i + d / 2, j - d / 2) & 0xFF)
                            + 2 * (result.getPixel(i + d / 2, j + d / 2) & 0xFF)
                            + 2 * (result.getPixel(i - d / 2, j + d / 2) & 0xFF)
                            + (result.getPixel(i - d, j) & 0xFF)
                            + (result.getPixel(i, j - d) & 0xFF)
                            + (result.getPixel(i + d, j) & 0xFF)
                            + (result.getPixel(i, j + d) & 0xFF)
                        ) / 16;
                    var color:uint = 0;
                    color |= channel << 16;
                    color |= channel << 8;
                    color |= channel;
                    
                    resultBlurTemp.setPixel(i, j, color);
                }
            }
            
            var temp:BitmapData = result;
            result = resultBlurTemp;
            resultBlurTemp = temp;
            resultBMP.bitmapData = result;
            
            //global blur
            result.applyFilter
            (
                result, result.rect, new Point(0, 0), 
                new BlurFilter(BLUR, BLUR, 2)
            );
        }
        
        private function renderObstacles():void 
        {
            result.draw
            (
                obstacles, 
                new Matrix
                (
                    result.width / 320, 0, 
                    0, result.height / 240
                )
            );
        }
        
        public function regenerateObstacles():void
        {
			
            while (obstacles.numChildren) obstacles.removeChildAt(0);
            
			//bufferBD.copyPixels(backgroundBD, backgroundBD.rect,backgroundPoint, null, null, true);  

			var rect:Rectangle=new Rectangle(0,0,16,16);
			var point:Point=new Point(0,0);

			var tilex:int=int(Reg.player.mapstartX/16);
			var tiley:int=int(Reg.player.mapstartY/16);
			//tiley=0;
NUM_OBSTACLES = 0;
			for(var coldraw:int=0; coldraw<(Globals.SCREEN_WIDTH/16)+1; coldraw++)
			{
				for(var rowdraw:int=0; rowdraw<(Globals.SCREEN_HEIGHT/16)+1; rowdraw++)
				{							
					//drawpoint=new Point(coldraw*16,rowdraw*16);

					var curr_col:int=coldraw+tilex;
					var curr_row:int=rowdraw+tiley;

					//if(curr_col>theTileMap.widthInTiles-1)
					//{curr_col=theTileMap.widthInTiles-1;}
					//if(curr_row>theTileMap.heightInTiles-1)
					//{curr_row=theTileMap.heightInTiles-1;}

					if (gr[curr_col][curr_row]==1)
					{ 
						var shape:Shape = new Shape();
						var size:Number = 16;
						shape.graphics.beginFill(0xcc808080, 1);
						shape.graphics.drawRect( 0, 0, size, size);
						//shape.rotation = 360 * Math.random();
						shape.x = (coldraw*16);
						shape.y = (rowdraw*16);
						obstacles.addChild(shape);
						NUM_OBSTACLES++;
					}
				}
			}	
			
						shape = new Shape();
						size = 16;
						shape.graphics.beginFill(0xcc808080, 1);
						shape.graphics.drawRect( 0, 0, size, size);
						//shape.rotation = 360 * Math.random();
						shape.x = 140;
						shape.y = 140;
						obstacles.addChild(shape);
												NUM_OBSTACLES++;
/*
						
						
			for (var i:int = 0; i < NUM_OBSTACLES; ++i)
            {
                var shape:Shape = new Shape();
                var size:Number = 
                    OBSTACLE_SIZE 
                    + OBSTACLE_SIZE_VAR * (2 * (0.5 - Math.random()));
                
                shape.graphics.beginFill(0x808080, 1);
                shape.graphics.drawRect( -0.5 * size, -0.5 * size, size, size);
                shape.rotation = 360 * Math.random();
                shape.x = 320 * Math.random();
                shape.y = 240 * Math.random();
                obstacles.addChild(shape);
            }*/
			
            obstacleMap.lock();
            
            obstacleMap.fillRect(obstacleMap.rect, 0xFFFFFF);
            obstacleMap.draw
            (
                obstacles, 
                new Matrix
                (
                    obstacleMap.width / 320, 0, 
                    0, obstacleMap.height / 240
                )
            );
            obstacleMap.threshold
            (
                obstacleMap, obstacleMap.rect, new Point(0, 0), "<", 
                0xFF0000, 0x000000, 0xFF0000, true
            );
            
            obstacleMap.unlock();
            //update
            mainLoop();
        }
        
        private function showResult(e:Event = null):void
        {
            resultBMP.visible = true;
            obstacles.visible = true;
            dataBMP.visible = false;
        }
        
        private function showObstacleMap(e:Event = null):void
        {
            resultBMP.visible = false;
            obstacles.visible = false;
            dataBMP.visible = true;
            
            dataBMP.bitmapData = obstacleMap;
            dataBMP.scaleX = 320 / obstacleMap.width;
            dataBMP.scaleY = 240 / obstacleMap.height;
        }
        
        private function showDistanceMap(e:Event = null):void
        {
            resultBMP.visible = false;
            obstacles.visible = false;
            dataBMP.visible = true;
            
            dataBMP.bitmapData = distanceMap;
            dataBMP.scaleX = 320 / distanceMap.width;
            dataBMP.scaleY = 240 / distanceMap.height;
        }
        
        private function showReducedDistanceMap(e:Event = null):void
        {
            resultBMP.visible = false;
            obstacles.visible = false;
            dataBMP.visible = true;
            
            dataBMP.bitmapData = reducedDistanceMap;
            dataBMP.scaleX = 320 / reducedDistanceMap.width;
            dataBMP.scaleY = 240 / reducedDistanceMap.height;
        }
    }
}