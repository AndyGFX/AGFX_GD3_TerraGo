extends Node2D

export (float,0,1) var noise_range = 0.5
var noise = OpenSimplexNoise.new()
var preview = null
var paint = null
var width:int = 256
var height:int = 128

# Called when the node enters the scene tree for the first time.
func _ready():
	
	noise.seed = 2019
	noise.lacunarity = 1
	noise.octaves = 1
	noise.period = 10.0
	noise.persistence = 0.8
	
	self.preview = $Preview
	self.paint = Image.new()
	self.paint.create(self.width,self.height,false,Image.FORMAT_RGBA8) 
	
	self.GetAsImage(self.width,self.height)
	self.BuildLandscape(32)
	self.BuildTerrain()
	
	
	$Preview.set_texture(Utils.CreateTextureFromImage(self.paint))
	
func GetAsImage(w,h):
	self.paint = noise.get_image(w,h)
	$Preview.set_texture(Utils.CreateTextureFromImage(self.paint))
	pass

func BuildTerrain():
	var c:Color = Color.black
	var gray:float = 0
	self.paint.lock()
	for x in range(self.width):
		for y in range(self.height):
			c = self.paint.get_pixel(x,y)
			gray = self.paint.get_pixel(x,y).gray()
			if c!=Color.blue:
				if gray<=0.5:
					self.paint.set_pixel(x,y,Color(0,0,0,1))
				else:
					self.paint.set_pixel(x,y,Color(1,1,1,1))
				
			pass
		pass
	
	self.paint.unlock()
	
	pass

func BuildLandscape(height):
	
	var line = rand_range(0,self.height)
	self.paint.lock()
	for x in range(self.width):
		var gray = self.paint.get_pixel(x,line).gray()
		for y in range(0,gray*height):
			self.paint.set_pixel(x,y,Color.blue)
		pass
	self.paint.unlock()
	pass


func TestNoise():
	self.paint.lock()
	for x in range(self.width):
		for y in range(self.height):
			var value = lerp(0.0,1.0,1+noise.get_noise_2d(x,y))
			
			#self.paint.set_pixel(x,y,Color(value,value,value,1))
			if value>=0.1 and value<=0.9:
				self.paint.set_pixel(x,y,Color(0,0,0,1))
			else:
				self.paint.set_pixel(x,y,Color(1,1,1,1))
		pass
	self.paint.unlock()
		
	
	pass