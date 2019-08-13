extends Node2D


export (int) var width  = 512
export (int) var height  = 128
export (int) var userSeed  = 128
export (float) var caveBalance  = 0.4
export (float) var oreBalance  = 0.6

var terrain:TerraGo = null


func _ready():
	
	
	self.terrain = TerraGo.new(self.width,self.height)
	
	self.terrain.noise_cave_properties.balance = self.caveBalance
	self.terrain.noise_cave_properties.userSeed = self.userSeed
	self.terrain.noise_cave_properties.lacunarity = 1
	self.terrain.noise_cave_properties.octaves = 1
	self.terrain.noise_cave_properties.period = 10
	self.terrain.noise_cave_properties.persistence = 0.8
	
	self.terrain.noise_ore_properties.balance = self.oreBalance
	self.terrain.noise_ore_properties.userSeed = self.userSeed
	self.terrain.noise_ore_properties.lacunarity = 8
	self.terrain.noise_ore_properties.octaves = 6
	self.terrain.noise_ore_properties.period = 30
	self.terrain.noise_ore_properties.persistence = 0.5
	
	self.terrain.AddDepthLayer(32,"SKY",Color.blue,1)
	self.terrain.AddDepthLayer(40,"GROUND",Color.green,9)
	self.terrain.AddDepthLayer(64,"DIRT",Color.brown,0.8)
	self.terrain.AddDepthLayer(96,"METAL",Color.yellow,0.5)
	self.terrain.AddDepthLayer(104,"DIAMOD",Color.olive,0.2)
	self.terrain.AddDepthLayer(127,"LAVA",Color.red,1)
	
	self.terrain.Build()
	
	$CaveNoisePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._cave_noise_img))
	$OreNoisePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._ore_noise_img))
	
	$CavePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._cave_img))
	$OrePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._ore_img))
	$LayerDistosrionPreview.set_texture(Utils.CreateTextureFromImage(self.terrain._distor_img))
	
#func GetAsImage(w,h):
#	self.paint = noise.get_image(w,h)
#	$Preview.set_texture(Utils.CreateTextureFromImage(self.paint))
#	pass
#
#func BuildTerrain():
#	var c:Color = Color.black
#	var gray:float = 0
#	self.paint.lock()
#	for x in range(self.width):
#		for y in range(self.height):
#			c = self.paint.get_pixel(x,y)
#			gray = self.paint.get_pixel(x,y).gray()
#			if c!=Color.blue:
#				if gray<=0.5:
#					self.paint.set_pixel(x,y,Color(0,0,0,1))
#				else:
#					self.paint.set_pixel(x,y,Color(1,1,1,1))
#
#			pass
#		pass
#
#	self.paint.unlock()
#
#
#func BuildLandscape(height):
#
#	var line = rand_range(0,self.height)
#	self.paint.lock()
#	for x in range(self.width):
#		var gray = self.paint.get_pixel(x,line).gray()
#		for y in range(0,gray*height):
#			self.paint.set_pixel(x,y,Color.blue)
#		pass
#	self.paint.unlock()
#	pass
#
#
#func TestNoise():
#	self.paint.lock()
#	for x in range(self.width):
#		for y in range(self.height):
#			var value = lerp(0.0,1.0,1+noise.get_noise_2d(x,y))
#
#			#self.paint.set_pixel(x,y,Color(value,value,value,1))
#			if value>=0.1 and value<=0.9:
#				self.paint.set_pixel(x,y,Color(0,0,0,1))
#			else:
#				self.paint.set_pixel(x,y,Color(1,1,1,1))
#		pass
#	self.paint.unlock()
#
#
#	pass