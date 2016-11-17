# The main workings o ruby_qt_diag program
#
# Author: Barrels-o-fun
# Created: November 2016
#
# Using Qt 4.8

### Constants
WIDTH=1800
HEIGHT=768

TEST_IMG_HEIGHT=1
TEST_IMG_WIDTH=255
TEST_HEX_OFFSET=
TEST_OFFSET=5
SCALE="up"

### Global vars
$ourimages = []
$image_x = 5
$image_y = 5
$image_offset_x = 2
$oneimage=1
$image_offset_y = 0




class Board < Qt::Widget

  
  def initialize(parent)
    super(parent)
        
    setFocusPolicy Qt::StrongFocus
    
    initProg
  end
  ### END of def initialize ###



  def initProg

    setStyleSheet "QWidget { background-color: #000000 }"
    # build_image(width=20, height=10, hex_color="#00FF00", hex_offset="A", x_multiplier=10, y_multiplier=100)
    $ourimages.push build_image(TEST_IMG_WIDTH, TEST_IMG_HEIGHT, "#000000", "FF", 1, 1)
    

    case SCALE
    when "up"
      p = $image_y + ( TEST_IMG_HEIGHT + 2 )
      q = 0
      while p < ( HEIGHT + $image_x + TEST_IMG_HEIGHT )
        q+=TEST_OFFSET
        $ourimages.push $ourimages[0].scaled( ( TEST_IMG_WIDTH + q ), TEST_IMG_HEIGHT ) 
        p+=( TEST_IMG_HEIGHT + 2 )
        break if ( q > ( WIDTH + $image_x ) )
      end
    when "down"
      p = $image_y + ( TEST_IMG_HEIGHT + 2 )
      q = 1
      while p < ( HEIGHT + $image_x + TEST_IMG_HEIGHT )
        q+=TEST_OFFSET
        $ourimages.push $ourimages[0].scaled( ( TEST_IMG_WIDTH - q ), TEST_IMG_HEIGHT ) 
        p+=( TEST_IMG_HEIGHT + 2 )
        break if ( q > ( WIDTH + $image_x ) )
      end
    else
    end

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
 


  def paintEvent event
 
    painter = Qt::Painter.new
    painter.begin self

    drawObjects painter

    painter.end
  
  end


  
  def drawObjects painter
   
    draw_image_x = $image_x
    cur_image_y = $image_y


    print "***** REFRESH ****** \n" 
    
    $ourimages.each do |image|
      painter.drawImage draw_image_x, cur_image_y, image
      cur_image_y+=image.height+$image_offset_y
      print "Image, W:", image.width, ", H:", image.height, ", cur_image_x: ", draw_image_x, ", cur_image_y: ", cur_image_y, "\n"
    end
  end



  def keyPressEvent event
   
    key = event.key

    case key
      when Qt::Key_Q.value
        exit 0
      else
    end  

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


  def build_image(width=20, height=10, hex_color="000000", hex_offset="1", x_multiplier=10, y_multiplier=100)    # Build an image up from one pixel
    pixelmax=width
    pixelmax=height unless width > height
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
   

    p=0
    while p < pixelmax
    print "Building image ", width, ",", height, " color: ", color, ", offset: ", offset, ", pixelmax: ", pixelmax, "\n"
      image_temp.setPixel( p, 0, color )  if pixelmax==width
      image_temp.setPixel( 0, p, color )  if pixelmax==height
      color+=offset
    p+=1
    end

    built_image = image_temp.scaled( ( width * x_multiplier ), ( height * y_multiplier ) ) 

  return built_image 

  end
  ### END of def build_house

end 


# Accidental find, keeping for reference 
=begin
  image_temp.setPixel( p, 0, color )  if pixelmax=width
  image_temp.setPixel( 0, p, color )  if pixelmax=height
=end
