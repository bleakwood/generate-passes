require 'RMagick'

dst = Magick::Image.read("background.jpg") {self.size = "905x1280"}.first

Dir.glob('images/*.JPG') do |rb_file|
	puts rb_file
	im = Magick::Image.read(rb_file).first

	im = im.adaptive_resize(204, 204)

	circle = Magick::Image.new 204, 204
	gc = Magick::Draw.new
	gc.fill 'black'
	gc.circle 102, 102, 102, 1
	gc.draw circle

	mask = circle.blur_image(0,1).negate

	mask.matte = false
	im.matte = true
	im.composite!(mask, Magick::CenterGravity, Magick::CopyOpacityCompositeOp)

	result = dst.composite(im, 349, 303, Magick::OverCompositeOp)

	name = rb_file.split(/\//)[1].split(".")[0]

	text = Magick::Draw.new
	  text.font ='Xihei.ttf'
	  text.pointsize = 42
	  text.gravity = Magick::NorthGravity
	  text.annotate(result, 0,0,2,510, name) {
	     self.fill = 'black'
	  }

	result.write("generated_passes/#{name}_通关证.jpg")
end