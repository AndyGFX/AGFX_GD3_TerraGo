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
	
	self.terrain.AddDepthLayer(16,"GROUND",Color.green,0.8)
	self.terrain.AddDepthLayer(40,"DIRT1",Color.blue,0.9)
	self.terrain.AddDepthLayer(64,"METAL",Color.aquamarine,0.8)
	self.terrain.AddDepthLayer(96,"DIRT2",Color.yellow,0.5)
	self.terrain.AddDepthLayer(104,"DIAMOD",Color.olive,0.2)
	self.terrain.AddDepthLayer(127,"LAVA",Color.red,1)
	
	self.terrain.Build()
	
	$CaveNoisePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._cave_noise_img))
	$OreNoisePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._ore_noise_img))
	
	$CavePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._cave_img))
	$OrePreview.set_texture(Utils.CreateTextureFromImage(self.terrain._ore_img))
	$LayerDistosrionPreview.set_texture(Utils.CreateTextureFromImage(self.terrain._distor_img))
	$Preview.set_texture(Utils.CreateTextureFromImage(self.terrain._final_img))
