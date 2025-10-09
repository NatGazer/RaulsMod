@tool
extends "res://Components/starlight/StarManager.gd"
## Procedurally generates main sequence stars and populates StarManager with them.

## Radius of a sphere in which to place stars.
@export var size: float = 5000.0:
	set(value):
		size = value
		_regenerate = true
## Number of stars to generate.
@export var star_count: int = 10000:
	set(value):
		star_count = value
		_regenerate = true
## RNG seed, which can be used to re-roll the random generation.
@export var rng_seed: int = 1234:
	set(value):
		rng_seed = value
		_regenerate = true
## If set to true, a Sol-like star will be placed at 0,0,0.
@export var generate_at_origin: bool = false:
	set(value):
		generate_at_origin = value
		_regenerate = true


var _regenerate: bool = true


class RangeF:
	var rmin: float
	var rmax: float

	func _init(_min: float, _max: float) -> void:
		self.rmin = _min
		self.rmax = _max

	func sample(value: float) -> float:
		return lerp(rmin, rmax, value)


class StarClass:
	var weight: int
	var stellar_class: String
	var temp_range: RangeF
	var luminosity_range: RangeF
	var mass_range: RangeF

	func _init(dict: Dictionary) -> void:
		self.weight = dict["weight"]
		self.stellar_class = dict["stellar_class"]
		self.temp_range = dict["temp_range"]
		self.luminosity_range = dict["luminosity_range"]
		self.mass_range = dict["mass_range"]

	func sample(value: float) -> Dictionary:
		return {
			"stellar_class": stellar_class,
			"temp": temp_range.sample(value),
			"luminosity": luminosity_range.sample(value),
			"mass": mass_range.sample(value),
		}

	func get_star(position: Vector3, value: float) -> Star:
		var p: Dictionary = self.sample(value)
		# B and O-class stars are obscenely bright, so spawn them further away than other stars.
		var modified_position: Vector3 = position * max(1.0, p["luminosity"] / 400.0)
		return Star.new(modified_position, p["luminosity"], p["temp"])


var class_O: StarClass = StarClass.new({
	"weight": 1, "stellar_class": "O",
	"temp_range": RangeF.new(30_000, 60_000),
	"luminosity_range": RangeF.new(30_000, 60_000),
	"mass_range": RangeF.new(16, 32),
})
var class_B: StarClass = StarClass.new({
	"weight": 13, "stellar_class": "B",
	"temp_range": RangeF.new(10_000, 30_000),
	"luminosity_range": RangeF.new(25, 30_000),
	"mass_range": RangeF.new(2.1, 16),
})
var class_A: StarClass = StarClass.new({
	"weight": 60, "stellar_class": "A",
	"temp_range": RangeF.new(7500, 10_000),
	"luminosity_range": RangeF.new(5, 25),
	"mass_range": RangeF.new(1.4, 2.1),
})
var class_F: StarClass = StarClass.new({
	"weight": 300, "stellar_class": "F",
	"temp_range": RangeF.new(6000, 7500),
	"luminosity_range": RangeF.new(1.5, 5),
	"mass_range": RangeF.new(1.04, 1.4),
})
var class_G: StarClass = StarClass.new({
	"weight": 760, "stellar_class": "G",
	"temp_range": RangeF.new(5200, 6000),
	"luminosity_range": RangeF.new(0.6, 1.50),
	"mass_range": RangeF.new(0.8, 1.04),
})
var class_K: StarClass = StarClass.new({
	"weight": 1210, "stellar_class": "K",
	"temp_range": RangeF.new(3700, 5200),
	"luminosity_range": RangeF.new(0.08, 0.6),
	"mass_range": RangeF.new(0.45, 0.8),
})
var class_M: StarClass = StarClass.new({
	"weight": 7645, "stellar_class": "M",
	"temp_range": RangeF.new(2400, 3700),
	"luminosity_range": RangeF.new(0.01, 0.08), # Corrected range from original
	"mass_range": RangeF.new(0.08, 0.45),
})


var star_table: Array[StarClass] = [
	class_O, class_B, class_A, class_F, class_G, class_K, class_M
]


func sample_sphere(rng: RandomNumberGenerator, radius: float) -> Vector3:
	while true:
		var pos := Vector3(
			rng.randf_range(-1.0, 1.0),
			rng.randf_range(-1.0, 1.0),
			rng.randf_range(-1.0, 1.0)
		)
		if pos.length_squared() <= 1.0:
			return pos * radius
	return Vector3.INF


func random_category(rng: RandomNumberGenerator) -> StarClass:
	var sum: int = 0
	for category: StarClass in star_table:
		sum += category.weight

	var weight: int = rng.randi_range(1, sum)

	sum = 0
	for category: StarClass in star_table:
		sum += category.weight
		if weight <= sum:
			return category
	
	# Fallback in case something goes wrong, though it shouldn't be reached
	return star_table[-1]


func _process(_delta: float) -> void:
	if not _regenerate:
		return

	_regenerate = false

	var rng := RandomNumberGenerator.new()
	rng.seed = rng_seed

	var stars: Array[Star] = []

	if generate_at_origin:
		stars.push_back(class_G.get_star(Vector3.ZERO, 0.5))

	for i: int in range(star_count):
		var category: StarClass = random_category(rng)
		stars.push_back(category.get_star(sample_sphere(rng, size), rng.randf()))

	set_star_list(stars)
