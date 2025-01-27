extends Sprite2D

# Kecepatan gerakan dan amplitudo
@export var speed: float = 1.0  # Kecepatan gerakan naik/turun
@export var amplitude: float = 50  # Amplitudo gerakan naik/turun (semakin besar, semakin tinggi gerakannya)

# Variabel waktu untuk perhitungan sinus
var time: float = 0.0
var original_y: float = 0.0

func _ready():
	# Menyimpan posisi Y awal sprite agar gerakan naik turun tetap relatif terhadap posisi awal
	original_y = position.y

func _process(delta):
	time += delta * speed  # Perbarui waktu berdasarkan frame rate
	var y_offset = amplitude * sin(time)  # Hitung gerakan naik-turun dengan fungsi sin()
	
	# Set posisi sprite tetap di X yang lama, hanya posisi Y yang bergerak naik turun
	position.y = original_y + y_offset
