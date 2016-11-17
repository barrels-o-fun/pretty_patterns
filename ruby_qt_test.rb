# The main workings o ruby_qt_diag program
#
# Author: Barrels-o-fun
# Created: November 2016
#
# Using Qt 4.8

### Constants
WIDTH=1800
HEIGHT=900

TEST_IMG_HEIGHT=1
TEST_IMG_WIDTH=800
TEST_START_HEX_COLOR="#000698"
TEST_START_HEX_OFFSET="10000" 

# Scale up/down CONSTANTS
TEST_OFFSET=2
SCALE="up"

### Global vars
$build_diagnostics=0
$painter_diagnostics=0
$ourimages = []
$image_x = 500
$image_y = -200
$image_offset_x = 0
$oneimage=1
$image_offset_y = 0

$test_img_hex_color=TEST_START_HEX_COLOR
$test_img_hex_offset=TEST_START_HEX_OFFSET
#
#

class Board < Qt::Widget

  
  def initialize(parent)
    super(parent)
        
    setFocusPolicy Qt::StrongFocus
    
    initProg
  end
  ### END of def initialize ###



  def initProg

    setStyleSheet "QWidget { background-color: #000000 }"
    ### build_image(width=20, height=10, hex_color="#00FF00", hex_offset="100", x_multiplier=10, y_multiplier=100)
#    $ourimages.push build_image( 16 , 10, "#008000", "100", 1, 1)
    $ourimages.push build_image(TEST_IMG_WIDTH, TEST_IMG_HEIGHT, $test_img_hex_color, $test_img_hex_offset, 1, 1)
    
    scale_things
      

    if $oneimage != 1
      $ourimages.push $ourimages[0].mirrored(true,false)
      $ourimages.push $ourimages[0].rgbSwapped
      $ourimages.push build_image(20, 10, "#0000FF", "F", 5, 10)
      $ourimages.push build_image(10, 20, "#00FF00", "F", 1, 5)
      $ourimages.push build_image(10, 20, "#FF0000", "F", 10, 5)
      # $ourimages.push $ourimages[3].invertPixels
    
      # outputs to console, shows attributes
      print "Our Image, W:", $ourimages[0].width, ", H:", $ourimages[0].height, "\n"
      puts $ourimages[0].color(0)
      @test_abc=$ourimages[0].copy(0,0,5,5)
      print "@test_abc, W:", @test_abc.width, ", H:", @test_abc.height, "\n"
      print "Pixel(2,3): ",@test_abc.pixel(2,3), "\n"
      @redColor = Qt::Color.new 255, 175, 175
      print "@redColor: ", @redColor, "\n"
    else
      print "*** One Image Only *** \n"

    end
  end
 
  def scale_things
    case SCALE
    when "up"
      p = $image_y
      q = 0
      while p < ( HEIGHT + $image_x + TEST_IMG_HEIGHT )
        q+=TEST_OFFSET
        $ourimages.push $ourimages[0].scaled( ( TEST_IMG_WIDTH + q ), TEST_IMG_HEIGHT ) 
        p+=( TEST_IMG_HEIGHT )
#        break if ( $ourimages[-1].width > ( WIDTH - $image_x ) )
      end
  
    when "down"
      p = $image_y
      q = 1
      while p < ( HEIGHT + $image_x + TEST_IMG_HEIGHT )
        q+=TEST_OFFSET
        $ourimages.push $ourimages[0].scaled( ( TEST_IMG_WIDTH - q ), TEST_IMG_HEIGHT ) 
        p+=( TEST_IMG_HEIGHT )
        break if ( $ourimages[-1].width < 1 )
      end

    when "down-up"
      p = $image_y
      q = 1
      while p < ( HEIGHT + $image_x + TEST_IMG_HEIGHT )
        if p < ( HEIGHT / 2 )
          q+=TEST_OFFSET
        else
          q-=TEST_OFFSET
        end
        $ourimages.push $ourimages[0].scaled( ( TEST_IMG_WIDTH - q ), TEST_IMG_HEIGHT ) 
        p+=( TEST_IMG_HEIGHT )
        if ( $ourimages[-1].width < 1 )
          q-=( TEST_OFFSET * 2 )
        end
      end

    when "up-down"
      p = $image_y
      q = 1
      while p < ( HEIGHT + $image_x + TEST_IMG_HEIGHT )
        if p < ( HEIGHT / 2 )
          q+=TEST_OFFSET
        else
          q-=TEST_OFFSET
        end
        $ourimages.push $ourimages[0].scaled( ( TEST_IMG_WIDTH + q ), TEST_IMG_HEIGHT ) 
        p+=( TEST_IMG_HEIGHT )
      end

    else
    end
  end

  def paintEvent event
 
    painter = Qt::Painter.new
    painter.begin self

    drawObjects painter

    painter.end
  
  end


  
  def drawObjects painter
   
    draw_image_x = $image_x
    draw_image_y = $image_y


    
    $ourimages.each do |image|
      painter.drawImage draw_image_x, draw_image_y, image
      draw_image_y+=image.height+$image_offset_y
      draw_image_x-=1
      if $painter_diagnostics==1
        print "Image, W:", image.width, ", H:", image.height, ", draw_image_x: ", draw_image_x, ", draw_image_y: ", draw_image_y, "\n"
      end
    end
  end



  def keyPressEvent event
   
    key = event.key

    case key
      when Qt::Key_Q.value
        exit 0
      when Qt::Key_Space.value
        $test_img_hex_color=rand("ffffff".hex).to_s(16)
      when Qt:: Key_B.value # Blue
        temp_rand=rand(10000)
        $test_img_hex_offset=( temp_rand -( temp_rand % 256 )  ).to_s(16)
      when Qt:: Key_G.value
        $test_img_hex_offset=rand(10000).to_s(16)
        
      else
    end  

    $ourimages=[]
    $ourimages.push build_image(TEST_IMG_WIDTH, TEST_IMG_HEIGHT, $test_img_hex_color, $test_img_hex_offset, 1, 1)
    scale_things
    repaint

  end
   

      

=begin
puts "HERE"
puts $ourimages["left"].width
puts $ourimages["left"].height
puts $ourimages["left"].color(0)
puts $ourimages["left"].colorCount
puts $ourimages["left"].colorTable
@test_abc=$ourimages["left"].copy(0,0,5,5)
puts @test_abc.height
puts @test_abc.width
print "Pixel: ",@test_abc.pixel(2,3), "\n"
print "PixelIndex: ",@test_abc.pixelIndex(2,3), "\n"
@test_abc.save("local_copy.png")
$ourimages["left"].save("shooty_left_100.png")
$ourimages["left"].save("shooty_left_100.jpg")
puts "END"
###
    $temp_123=$pewpew_sprites["up"].mirrored(true,false)
    @marine=$temp_123.rgbSwapped
=end


  def build_image(width=20, height=10, hex_color="000000", hex_offset="100", x_multiplier=10, y_multiplier=100)    # Build an image up from one pixel
    pixelmax=width
#    pixelmax=height unless width > height
    one_pixel = Qt::Image.new(1,1,4)  # third arg is format (see Qt Image ref)
    one_pixel.setPixel( 0, 0, 0 )  # third arg is color, decimal equiv of hex
  
    case pixelmax
    when width 
       image_temp=one_pixel.scaled(width, 1)
    when height 
      image_temp=one_pixel.scaled(1, height)
    end
    
    # Get decimacl from hex (required for Qt::Image.setPixel   
    hex_color.gsub!('#', '')
    hex_offset.gsub!('#', '')
    color=hex_color.hex
    offset=hex_offset.hex
   
    if $build_diagnostics > 0
      print "***** Building image ", width, ",", height, "|  color: ", color.to_s(16), "(", color, "), offset: ", offset.to_s(16), ", pixelmax: ", pixelmax, "\n"
    end

    p=0
    while p < pixelmax
      if $build_diagnostics > 1
      print "...building image ", width, ",", height, "|  color: ", color.to_s(16), "(", color, "), offset: ", offset.to_s(16), ", pixelmax: ", pixelmax, "\n"
      end
      image_temp.setPixel( p, 0, color )  if pixelmax==width
#      image_temp.setPixel( 0, p, color )  if pixelmax==height
      color+=offset
    p+=1
    end
    
    if $build_diagnostics > 0
      print "***** Built image ", width, ",", height, "|  color: ", color.to_s(16), "(", color, "), offset: ", offset.to_s(16), ", pixelmax: ", pixelmax, "\n"
    end

    built_image = image_temp.scaled( ( width * x_multiplier ), ( height * y_multiplier ) ) 

  return built_image 

  end
  ### END of def build_image

end 


# Accidental find, keeping for reference 
=begin
  image_temp.setPixel( p, 0, color )  if pixelmax=width
  image_temp.setPixel( 0, p, color )  if pixelmax=height
=end
