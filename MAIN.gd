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
	noise.lacunarity = 2
	noise.octaves = 2
	noise.period = 13.0
	noise.persistence = 0.5
	
	self.preview = $Preview
	self.paint = Image.new()
	self.paint.create(self.width,self.height,false,Image.FORMAT_RGBA8) 
	self.TestNoise()
	
func TestNoise():
	self.paint.lock()
	for x in range(self.width):
		for y in range(self.height):
			var value = 1+noise.get_noise_2d(x,y)
			
			self.paint.set_pixel(x,y,Color(value,value,value,1))
			if value>0.5 and value<0.7:
				self.paint.set_pixel(x,y,Color(0,0,0,1))
			else:
				self.paint.set_pixel(x,y,Color(1,1,1,1))
		pass
	self.paint.unlock()
		
	$Preview.set_texture(Utils.CreateTextureFromImage(self.paint))
	pass