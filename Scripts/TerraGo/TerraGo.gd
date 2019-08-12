class_name TerraGo

class Terrainlayer:
	var depth:int = 0
	var distorsion:Array = []
	var type:String = "undefined"
	var color:Color = Color.black
	var chance:float = 1.0

class NoiseProperties:
	var balance:float = 0.5
	var userSeed:int = 0
	var lacunarity:float = 2
	var octaves:float = 1
	var period:float = 10
	var persistence:float = 0.8
	
var width:int = 512
var height:int = 128

var noise_cave_properties:NoiseProperties = null
var noise_cave:OpenSimplexNoise = null
var noise_ore:OpenSimplexNoise = null
var noise_ore_properties:NoiseProperties = null
var layers:Array = []

var _cave_noise_img:Image
var _ore_noise_img:Image
var _cave_img:Image
var _ore_img:Image
var _final_img:Image

func _init(w:int,h:int)->void:
	self.width = w
	self.height = h
	
	
	self.noise_cave = OpenSimplexNoise.new()
	self.noise_cave_properties = NoiseProperties.new()
	
	self.noise_ore = OpenSimplexNoise.new()
	self.noise_ore_properties = NoiseProperties.new()
	
	self._cave_img = Image.new()
	self._cave_img.create(self.width,self.height,false,Image.FORMAT_RGBA8) 
	
	self._ore_img = Image.new()
	self._ore_img.create(self.width,self.height,false,Image.FORMAT_RGBA8) 
	
	self._final_img = Image.new()
	self._final_img.create(self.width,self.height,false,Image.FORMAT_RGBA8) 
	
	pass

func AddDepthLayer(depth:int,type:String,color:Color, chance:float)->void:
	var layer:Terrainlayer = Terrainlayer.new()
	layer.depth = depth
	layer.type = type
	layer.color = color
	layer.chance = chance

	self.layers.append(layer)

func Build()->void:
	
	self._SetCave()
	self._SetOre()
	self._InitializeLayers()
	self._BuildCave()
	self._BuildOre()
	self._BuildFinalTerrain()
	
	pass
	
func _InitializeLayers()->void:
	
	self._cave_noise_img.lock()
	for i in range(self.layers.size()):
		for x in range(self.width):
			self.layers[i].distorsion.append(self._cave_noise_img.get_pixel(x,self.layers[i].depth).gray())

	self._cave_noise_img.unlock()
	pass
	
func _SetCave()->void:
	
	self.noise_cave.seed = self.noise_cave_properties.userSeed
	
	self.noise_cave.lacunarity = self.noise_cave_properties.lacunarity
	self.noise_cave.octaves = self.noise_cave_properties.octaves
	self.noise_cave.period = self.noise_cave_properties.period
	self.noise_cave.persistence = self.noise_cave_properties.persistence
	
	self._cave_noise_img = self.noise_cave.get_image(self.width,self.height)
	
	pass

func _SetOre()->void:
	
	self.noise_ore.seed = self.noise_ore_properties.userSeed
	
	self.noise_ore.lacunarity = self.noise_ore_properties.lacunarity
	self.noise_ore.octaves = self.noise_ore_properties.octaves
	self.noise_ore.period = self.noise_ore_properties.period
	self.noise_ore.persistence = self.noise_ore_properties.persistence
	
	self._ore_noise_img = self.noise_ore.get_image(self.width,self.height)
	
	pass


func _BuildCave()->void:
	var c:Color = Color.black
	var gray:float = 0
	self._cave_img.lock()
	self._cave_noise_img.lock()
	for x in range(self.width):
		for y in range(self.height):
			c = self._GetLayerColor(y)
			gray = self._cave_noise_img.get_pixel(x,y).gray()
			if gray<=self.noise_cave_properties.balance:
				self._cave_img.set_pixel(x,y,c)
			else:
				self._cave_img.set_pixel(x,y,Color(0,0,0,1))
	
	self._cave_noise_img.unlock()
	self._cave_img.unlock()

func _GetLayerColor(depth:int)->Color:
	
	for i in range(self.layers.size()):
		if depth<=self.layers[i].depth:
			return self.layers[i].color
	return Color.black

func _GetLayerId(depth:int)->int:
	
	for i in range(self.layers.size()):
		if depth<=self.layers[i].depth:
			return i
	return 0
	
func _BuildOre()->void:
	var c:Color = Color.black
	var gray:float = 0
	var layer_id:float = 0
	self._ore_img.lock()
	self._ore_noise_img.lock()
	for x in range(self.width):
		for y in range(self.height):
			c = self._GetLayerColor(y)
			layer_id = self._GetLayerId(y)
			gray = self._ore_noise_img.get_pixel(x,y).gray()
			if gray>=self.noise_ore_properties.balance:
				if randf()<self.layers[layer_id].chance:
					self._ore_img.set_pixel(x,y,c)
				else:
					self._ore_img.set_pixel(x,y,Color.black)
			else:
				self._ore_img.set_pixel(x,y,Color.black)
	
	self._ore_noise_img.unlock()
	self._ore_img.unlock()
	
func _BuildFinalTerrain()->void:
	pass
	