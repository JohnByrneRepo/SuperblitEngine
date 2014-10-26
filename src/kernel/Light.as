package kernel
{
    //import com.bit101.components.PushButton;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Shape;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.geom.Point;
	import kernel.Tilemap;
    
    [SWF(width="465",height="465",backgroundColor="#FFFFFF",frameRate="60")]
    
    //Shadow-casting vertex finding algorithm reference:
    //http://board.flashkit.com/board/showthread.php?t=798017
    //
    //Scanline flood algorithm reference:
    //http://lodev.org/cgtutor/floodfill.html#Scanline_Floodfill_Algorithm_With_Stack
    public class Light extends Sprite
    {
		public var tmap:Tilemap = new Tilemap();
		
        private const STAGE_WIDTH:Number = 465;
        private const STAGE_HEIGHT:Number = 465;
        
        private const LIGHT_RADIUS:Number = 80;
        
        //private const NUM_OBSTACLES:uint = 8;
        public var NUM_OBSTACLES:uint = 0;
		
        private const OBSTACLE_SIZE:Number = 40;
        private const OBSTACLE_SIZE_VAR:Number = 15;
        
        private const OBSTACLE_OUTLINE_COLOR:uint = 0xFF00FF00;
        private const LIGHT_REGION_FILL_COLOR:uint = 0x80808080;
        private const LIGHT_REGION_LINE_COLOR:uint = 0xFFFF0000;
        
		public var bg:Shape = new Shape();

        public var _obstacles:Vector.<Polygon>;
		public var _obstacleOutline:Sprite;
        public var _lightRegionBMPD:BitmapData;
        public var _lightRegionBMP:Bitmap;
        public var _lightMaskBMPD:BitmapData;
        public var _lightMaskBMP:Bitmap;
        
        private var _ui:Sprite;
        private var _light:Sprite;

		public var gr:Array = [];
		public var mx:Number = 160;
	    public var my:Number = 120;
        
		
        //init
        //----------------------------------------------------------------------
        
        public function Light()
        {
			// ARRAY POPULATION			
			gr = new Array(80); 
			for(var arrCreationCount:int = 0; arrCreationCount < gr.length; arrCreationCount++) 
			{    
			 gr[arrCreationCount] = new Array(60); 
			}
			
            //addEventListener(Event.ENTER_FRAME, mainLoop);
            //addChild(_ui);
        }
        
        //private function mainLoop(e:Event):void
        public function mainLoop():void
        {
            drawObstacleOutlines();
            drawLightRegion();
        }
        
        //----------------------------------------------------------------------
        //end of init
        
        
        //core algorithm
        //----------------------------------------------------------------------
        
        private function drawLightRegion():void
        {
            //mouse position
             mx = mouseX;
             my = mouseY;
            
            //early abort (mouse not on stage)
            //if (mx < 0 || mx > STAGE_WIDTH || my < 0 || my > STAGE_HEIGHT) return;
            
            //light radius
            drawCircle(_lightRegionBMPD, mx, my, LIGHT_RADIUS, LIGHT_REGION_LINE_COLOR);
            
            //shadow edges
            for (var i:int = 0; i < NUM_OBSTACLES; ++i)
            {
                for (var j:int = 0; j < 4; ++j)
                {
                    //get 3 adjacent vertices
                    var current:Vertex = _obstacles[i].vertices[j];
                    var prev:Vertex = current.prev;
                    var next:Vertex = current.next;
                    
                    //vector 0 (v0): mouse to current vertex
                    var v0x:Number = current.x - mx;
                    var v0y:Number = current.y - my;
                    
                    //vector 1 (v1): mouse to previous vertex
                    var v1x:Number = prev.x - mx;
                    var v1y:Number = prev.y - my;
                    
                    //vector 2 (v2): mouse to next vertex
                    var v2x:Number = next.x - mx;
                    var v2y:Number = next.y - my;
                    
                    //vertex is casing shadow <=> v0 cross v1 and v0 cross v2 has the same sign
                    if ((v0x * v1y - v0y * v1x) * (v0x * v2y - v0y * v2x) >= 0)
                    {
                        //draw line from light source (mouse position)
                        var theta:Number = Math.atan2(v0y, v0x);
                        drawLine
                        (
                            _lightRegionBMPD, 
                            current.x, current.y, 
                            current.x + LIGHT_RADIUS * Math.cos(theta), 
                            current.y + LIGHT_RADIUS * Math.sin(theta), 
                            LIGHT_REGION_LINE_COLOR
                        );
                    }
                }
            }
            
            
            //flood fill light color
            lightFloodFill(_lightMaskBMPD, _lightRegionBMPD, mx, my, LIGHT_REGION_FILL_COLOR);
        }
        
        
        //----------------------------------------------------------------------
        //end of core algorithm
        
        
        //render functions
        //----------------------------------------------------------------------
        
        //stack used by flood fill function
        private const STACK_SIZE:uint = 465;
        private var _stackX:Vector.<Number> = new Vector.<Number>(465);
        private var _stackY:Vector.<Number> = new Vector.<Number>(465);
        private var _stackSize:int = 0;
        private function emptyStack():void
        {
            _stackSize = 0;
        }
        private function pushStack(x:Number, y:Number):void
        {
            _stackX[_stackSize] = x;
            _stackY[_stackSize] = y;
            ++_stackSize;
        }
        private function popStack():void
        {
            --_stackSize;
        }
        
        //non-recursive scanline flood fill algorithm + light color calculation
        private function lightFloodFill(target:BitmapData, source:BitmapData, x:int, y:int, color:uint):void
        {
            var cx:int = x;
            var cy:int = y;
            
            emptyStack();
            
            //source.lock();
            //target.lock();
            
            //clean target
            target.fillRect(target.rect, 0xFF000000);
            
            var oldColor:uint = source.getPixel32(x, y);
            if (color == oldColor) return;
            
            var y1:int, w:int = source.width, h:int = source.height;
            var spanLeft:Boolean, spanRight:Boolean;
            
            pushStack(x, y);
            
            while(_stackSize > 0)
            {
                popStack();
                x = _stackX[_stackSize];
                y = _stackY[_stackSize];
                
                y1 = y;
                while(y1 >= 0 && source.getPixel32(x, y1) == oldColor) --y1;
                ++y1;
                spanLeft = spanRight = false;
                while(y1 < h && source.getPixel32(x, y1) == oldColor)
                {
                    source.setPixel32(x, y1, color);
                    
                    //calculate channel
                    var dx:int = x - cx;
                    var dy:int = y1 - cy;
                    var c:uint = uint(0xFF * (1 - (Math.sqrt(dx * dx + dy * dy) / LIGHT_RADIUS)));
                    target.setPixel(x, y1, (0xFF << 24) | (c << 16) | (c << 8) | c);
                    
                    if(!spanLeft && (x > 0) && (source.getPixel32(x - 1, y1) == oldColor)) 
                    {
                        pushStack(x - 1, y1);
                        spanLeft = true;
                    }
                    else if(spanLeft && (x > 0) && (source.getPixel32(x - 1, y1) != oldColor))
                    {
                        spanLeft = false;
                    }
                    if(!spanRight && (x < w - 1) && (source.getPixel32(x + 1, y1) == oldColor)) 
                    {
                        pushStack(x + 1, y1);
                        spanRight = true;
                    }
                    else if(spanRight && (x < w - 1) && (source.getPixel32(x + 1, y1) != oldColor))
                    {
                        spanRight = false;
                    } 
                    ++y1;
                }
            }
            
            //source.unlock();
            //target.unlock();
        }
        
        
        //Bresenham's line algorithm
        private function drawLine(target:BitmapData, x0:int, y0:int, x1:int, y1:int, color:uint):void
        {
            var dx:int = x1 - x0;
            var dy:int = y1 - y0;
            var sx:int = (dx >= 0)?(1):(-1);
            var sy:int = (dy >= 0)?(1):( -1);
            dx = (dx >= 0)?(dx):(-dx);
            dy = (dy >= 0)?(dy):(-dy);
            var err:int = dx - dy, e2:int;
            
            while (true)
            {
                target.setPixel32(x0, y0, color);
                
                if ((x0 == x1) && (y0 == y1)) break;
                
                e2 = err << 1;
                if (e2 > -dy) {
                    err -= dy;
                    x0 += sx;
                }
                if (e2 < dx) {
                    err += dx;
                    y0 += sy;
                }
            }
        }
        
        //Bresenham's circle algorithm
        private function drawCircle(target:BitmapData, cx:int, cy:int, radius:Number, color:uint):void
        {
            var r:int = int(radius + 0.5);
            var error:int = -r;
            var x:int = r;
            var y:int = 0;
            
            while (x >= y)
            {
                target.setPixel32(cx + x, cy + y, color);
                if (x != 0) target.setPixel32(cx - x, cy + y, color);
                if (y != 0) target.setPixel32(cx + x, cy - y, color);
                if (x != 0 && y != 0) target.setPixel32(cx - x, cy - y, color);
                if (x != y)
                {
                    target.setPixel32(cx + y, cy + x, color);
                    if (y != 0) target.setPixel32(cx - y, cy + x, color);
                    if (x != 0) target.setPixel32(cx + y, cy - x, color);
                    if (y != 0 && x != 0) target.setPixel32(cx - y, cy - x, color);
                }
                
                error += y;
                ++y;
                error += y;
                if (error >= 0)
                {
                    --x;
                    error -= x;
                    error -= x;
                }
            }
        }
        
        //----------------------------------------------------------------------
        //end of render functions
        
        
        //helper functions
        //----------------------------------------------------------------------
        
        private function drawObstacleOutlines():void
        {
            _lightRegionBMPD.lock();
            _lightRegionBMPD.fillRect(_lightRegionBMPD.rect, 0x00000000);
            
            _obstacleOutline.graphics.clear();
            _obstacleOutline.graphics.lineStyle(0, OBSTACLE_OUTLINE_COLOR);
			
            for (var i:int = 0; i < _obstacles.length; ++i)
            {
                var v:Vector.<Vertex> = _obstacles[i].vertices;
                _obstacleOutline.graphics.moveTo(v[0].x, v[0].y);
                _obstacleOutline.graphics.lineTo(v[1].x, v[1].y);
                _obstacleOutline.graphics.lineTo(v[2].x, v[2].y);
                _obstacleOutline.graphics.lineTo(v[3].x, v[3].y);
                _obstacleOutline.graphics.lineTo(v[0].x, v[0].y);
                
                drawLine(_lightRegionBMPD, v[0].x, v[0].y, v[1].x, v[1].y, LIGHT_REGION_LINE_COLOR);
                drawLine(_lightRegionBMPD, v[1].x, v[1].y, v[2].x, v[2].y, LIGHT_REGION_LINE_COLOR);
                drawLine(_lightRegionBMPD, v[2].x, v[2].y, v[3].x, v[3].y, LIGHT_REGION_LINE_COLOR);
                drawLine(_lightRegionBMPD, v[3].x, v[3].y, v[0].x, v[0].y, LIGHT_REGION_LINE_COLOR);
            }
            
            _lightRegionBMPD.unlock();
        }
        
        public function setupBitmap():void
        {
            _lightMaskBMPD = new BitmapData(640, 480, true, 0x00000000);
            _lightMaskBMP = new Bitmap(_lightMaskBMPD);
            
            _lightRegionBMPD = new BitmapData(640, 480, true, 0x00000000);
            _lightRegionBMP = new Bitmap(_lightRegionBMPD);
            _lightRegionBMP.visible = false;
        }
        
        public function setupDisplay():void
        {
            bg = new Shape();
            bg.graphics.beginFill(0xFFFFFF);
            bg.graphics.drawRect(0, 0, STAGE_WIDTH, STAGE_HEIGHT);
            //addChild(bg);
            //addChild(_lightMaskBMP);
            //addChild(_lightRegionBMP);
            //addChild(_obstacleOutline = new Sprite());
        }
        
        private function setupUI():void
        {
            //_ui = new Sprite();
            //new PushButton(_ui, 10, 10, "Regenerate Obstacles", regenerateObstacles);
            //new PushButton(_ui, 10, 30, "Toggle Obstacles", toggleObstacleOutline);
            //new PushButton(_ui, 10, 50, "Toggle Light Region", toggleLightRegion);
            //addChild(_ui);8
        }
        
        public function regenerateObstacles():void
        {
            _obstacles = new Vector.<Polygon>();

			var point:Point=new Point(0,0);

			var tilex:int=int(Reg.player.mapstartX/16);
			var tiley:int=int(Reg.player.mapstartY/16);

			NUM_OBSTACLES = 0;
			//gr[3][4] = 1;
			
			
			for(var coldraw:int=0; coldraw<(Globals.SCREEN_WIDTH/16)+1; coldraw++)
			{
				for(var rowdraw:int=0; rowdraw<(Globals.SCREEN_HEIGHT/16)+1; rowdraw++)
				{							
	
					var curr_col:int=coldraw+tilex;
					var curr_row:int=rowdraw+tiley;

					//if (tmap.tmpGrid[curr_col][curr_row]==1)
					if (gr[curr_col][curr_row]==1)
					{ 
						var p:Polygon = new Polygon();
						var cx:Number = (coldraw*16.0);
						var cy:Number = (rowdraw*16.0);

						p.start();
						for (var j:int = 0; j < 4; ++j)
						{
							p.vertices.push(new Vertex(cx,      cy));
							p.vertices.push(new Vertex(cx + 16, cy));
							p.vertices.push(new Vertex(cx + 16, cy + 16));
							p.vertices.push(new Vertex(cx,      cy + 16));
						}
						p.end();
						
						_obstacles.push(p);
						NUM_OBSTACLES++;
					}
				}
			}	
			/*
			var p:Polygon = new Polygon();
						var cx:Number = (2*16.0);
						var cy:Number = (2*16.0);

						p.start();
						for (var j:int = 0; j < 4; ++j)
						{
							p.vertices.push(new Vertex(cx,      cy));
							p.vertices.push(new Vertex(cx + 16, cy));
							p.vertices.push(new Vertex(cx + 16, cy + 16));
							p.vertices.push(new Vertex(cx,      cy + 16));
						}
						p.end();
						
						_obstacles.push(p);
						NUM_OBSTACLES++;
						*/
        }
        
        private function toggleObstacleOutline(e:Event):void
        {
            _obstacleOutline.visible = !_obstacleOutline.visible;
        }
        
        private function toggleLightRegion(e:Event):void
        {
            _lightRegionBMP.visible = !_lightRegionBMP.visible;
        }
        
        //----------------------------------------------------------------------
        //end of helper functions
    }
}

class Vertex
{
    public var prev:Vertex;
    public var next:Vertex;
    
    public var x:Number;
    public var y:Number;
    
    public function Vertex(x:Number, y:Number)
    {
        this.x = x;
        this.y = y;
    }
}

class Polygon
{
    public var vertices:Vector.<Vertex>;
    
    public function Polygon()
    {
        vertices = new Vector.<Vertex>();
    }
    
    public function start():void
    {
    
    }
    
    public function end():void
    {
        for (var i:int = 0; i < vertices.length - 1; ++i)
        {
            vertices[i].next = vertices[i + 1];
            vertices[i + 1].prev = vertices[i];
        }
        
        vertices[vertices.length - 1].next = vertices[0];
        vertices[0].prev = vertices[vertices.length - 1];
    }
}