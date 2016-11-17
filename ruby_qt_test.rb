# The main workings o ruby_qt_diag program
#
# Author: Barrels-o-fun
# Created: November 2016
#
# Using Qt 4.8

### Constants
WIDTH=1600
HEIGHT=900

TEST_IMG_HEIGHT=1
TEST_IMG_WIDTH=400
TEST_START_HEX_COLOR="#000698"
TEST_START_HEX_OFFSET="10000" 

# Scale up/down CONSTANTS
$test_offset=2
$pattern="up-down"

### Global vars
$build_diagnostics=0
$painter_diagnostics=0
$orig_images = []
$ourimages = []
$ourimages_2 = []
$image_x = 205
$image_y = 0
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
    $orig_images.push build_image(TEST_IMG_WIDTH, TEST_IMG_HEIGHT, $test_img_hex_color, $test_img_hex_offset, 1, 1)
    $orig_images.push build_image(TEST_IMG_WIDTH, TEST_IMG_HEIGHT, $test_img_hex_color, $test_img_hex_offset, 1, 1)
    
    patterns($orig_images[0], $ourimages)
    patterns($orig_images[1], $ourimages_2)
      

    if $oneimage != 1
      $ourimages.push $orig_images[0].mirrored(true,false)
      $ourimages.push $orig_images[0].rgbSwapped
      $ourimages.push build_image(20, 10, "#0000FF", "F", 5, 10)
      $ourimages.push build_image(10, 20, "#00FF00", "F", 1, 5)
      $ourimages.push build_image(10, 20, "#FF0000", "F", 10, 5)
      # $ourimages.push $ourimages[3].invertPixels
    
      # outputs to console, shows attributes
      print "Our Image, W:", $orig_images[0].width, ", H:", $orig_images[0].height, "\n"
      puts $orig_imagess[0].color(0)
      @test_abc=$orig_images[0].copy(0,0,5,5)
      print "@test_abc, W:", @test_abc.width, ", H:", @test_abc.height, "\n"
      print "Pixel(2,3): ",@test_abc.pixel(2,3), "\n"
      @redColor = Qt::Color.new 255, 175, 175
      print "@redColor: ", @redColor, "\n"
    else
      print "*** One Image Only *** \n"

    end
  end
 
  def patterns(image_num=$orig_images[0], image_array=$ourimages)
      case $pattern
      when "up"
        p = $image_y
        q = 0
        while p < ( HEIGHT + $image_y + TEST_IMG_HEIGHT )
          q+=$test_offset
          image_array.push image_num.scaled( ( TEST_IMG_WIDTH + q ), TEST_IMG_HEIGHT ) 
          p+=( TEST_IMG_HEIGHT )
        end
  
      when "down"
        p = $image_y
        q = 1
        while p < ( HEIGHT + $image_y + TEST_IMG_HEIGHT )
          q+=$test_offset
          image_array.push image_num.scaled( ( TEST_IMG_WIDTH - q ), TEST_IMG_HEIGHT ) 
          p+=( TEST_IMG_HEIGHT )
          break if ( image_array[-1].width < 1 )
        end

      when "down-up"
        p = $image_y
        q = 1
        while p < ( HEIGHT + $image_y + TEST_IMG_HEIGHT )
          if p < ( HEIGHT / 2 )
            q+=$test_offset
          else
            q-=$test_offset
          end
          image_array.push image_num.scaled( ( TEST_IMG_WIDTH - q ), TEST_IMG_HEIGHT ) 
          p+=( TEST_IMG_HEIGHT )
          if ( image_array[-1].width < 1 )
            q-=( $test_offset * 2 )
          end
        end

      when "up-down"
        p = $image_y
        q = 1
        while p < ( HEIGHT + $image_y + TEST_IMG_HEIGHT )
          if p < ( HEIGHT / 2 )
            q+=$test_offset
          else
            q-=$test_offset
          end
          image_array.push image_num.scaled( ( TEST_IMG_WIDTH + q ), TEST_IMG_HEIGHT ) 
          p+=( TEST_IMG_HEIGHT )
        end
   
      when "random"
        p = 0
        q = rand(15)
        height=rand(0.1..0.2)*10
        print "height: ", height, "\n"
        while p < ( HEIGHT * 2 )
          which_way=rand(10)
          if p < ( HEIGHT / 2 )
            case which_way
            when 0..8
              q+=$test_offset
            when 9..10
              q-=$test_offset
            end
         else
           case which_way
           when 0..3
             q+=$test_offset
           when 4..10
             q-=$test_offset
           end
        end

        image_array.push image_num.scaled( ( TEST_IMG_WIDTH + q ), height ) 
        p+=( height )
 #        print "p: ", p, "  ]"
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
   
    draw_image_x = 5
    draw_image_y = $image_y


    
    $ourimages.each do |image|
      painter.drawImage draw_image_x, draw_image_y, image
      draw_image_y+=image.height + $image_offset_y
      draw_image_x+=1
      if $painter_diagnostics==1
        print "Image, W:", image.width, ", H:", image.height, ", draw_image_x: ", draw_image_x, ", draw_image_y: ", draw_image_y, "\n"
      end
    end
   
    print "$ourimages_2.count: ", $ourimages_2.count, "\n"
    print "draw_image_y, stopped at: ", draw_image_y, "\n"
  
    draw_image_x = 5
    draw_image_y = HEIGHT 

      $count_me=0
    $ourimages_2.each do |image|
      $count_me+=1
      draw_image_y-=image.height + $image_offset_y
      painter.drawImage draw_image_x, draw_image_y, image
      temp_rand=rand()
      draw_image_x+=temp_rand
      if $painter_diagnostics==1
        print $count_me, ":: Image, W:", image.width, ", H:", image.height, ", draw_image_x: ", draw_image_x, ", draw_image_y: ", draw_image_y, "\n"
      end
    end

    print "$ourimages_2.count: ", $ourimages_2.count, "\n"
    print "draw_image_y, stopped at: ", draw_image_y, "\n"
    print "*** END *** \n\n"
  end



  def keyPressEvent event
   
    key = event.key

    case key
      when Qt::Key_Q.value
        exit 0
      when Qt::Key_Space.value
        $test_img_hex_color=rand("ffffff".hex).to_s(16)
        print "Color: ", $test_img_hex_color, "\n"
      when Qt:: Key_B.value # Blue
        temp_rand=rand(1000)
        $test_img_hex_offset=( temp_rand -( temp_rand % 256 )  ).to_s(16)
        print "hex_offset: ", $test_img_hex_offset, "\n"
      when Qt:: Key_G.value
        temp_rand=rand(1677215)
        $test_img_hex_offset=( temp_rand -( temp_rand % 65535 )  ).to_s(16)
        print "hex_offset: ", $test_img_hex_offset, "\n"
      when Qt::Key_S.value
        temp_rand=rand(4) 
        print "S rand(", temp_rand, ")\n"
        case temp_rand 
        when 0
          $pattern = "up"
        when 1
          $pattern = "down"
        when 2
          $pattern = "up-down"
        when 3
          $pattern = "down-up"
        else
        end 
 
      when Qt::Key_R.value
        $pattern = "random"        
      else
    end  

    $ourimages=[]
    $ourimages_2=[]
    $orig_images=[]
    # $ourimages.push build_image(TEST_IMG_WIDTH, TEST_IMG_HEIGHT, $test_img_hex_color, $test_img_hex_offset, 1, 1)
    $orig_images.push build_image(TEST_IMG_WIDTH, TEST_IMG_HEIGHT, $test_img_hex_color, $test_img_hex_offset, 1, 1)
    $orig_images.push $orig_images[0].mirrored(true,false)
    patterns($orig_images[0], $ourimages)
    patterns($orig_images[1], $ourimages_2)
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
