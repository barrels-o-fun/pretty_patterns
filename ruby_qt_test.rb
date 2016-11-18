# The main workings o ruby_qt_diag program
#
# Author: Barrels-o-fun
# Created: November 2016
#
# Using Qt 4.8
#
# This program is a mess!
#
# Just been playing around, it's not put together that well.
#
# Maybe one day I will tidy it up and make it more functional
#
# But hey, not the most important thing,
#
# It makes pretty colors!!!
#

### Debug ###
$build_diagnostics=0
$painter_diagnostics=0
$oneimage=1


### Constants
# Dimension of program window
WIDTH=600
HEIGHT=800

# Constants for testing
TEST_IMG_HEIGHT=1
TEST_IMG_WIDTH=200
TEST_START_HEX_COLOR="#000698"
TEST_START_HEX_OFFSET="10000" 
TEST_IMG_X_MULTI=1
TEST_IMG_Y_MULTI=200
###

### Pattern variables
$img_width=TEST_IMG_WIDTH 
$img_height=TEST_IMG_HEIGHT
$img_hex_color=TEST_START_HEX_COLOR
$img_hex_offset=TEST_START_HEX_OFFSET
$img_x_multi=TEST_IMG_X_MULTI
$img_y_multi=TEST_IMG_Y_MULTI

$pattern="none"
$offset=2

### Global Arrays
$orig_images = []
$active_images = []
$active_images_2 = []

### Image positioning within the window 
$initial_image_x = 200
$initial_image_y = 5
$image_offset_x = 0
$image_offset_y = 0

####


class Board < Qt::Widget

  
  def initialize(parent)
    super(parent)
        
    setFocusPolicy Qt::StrongFocus
    
    initProg
  end
  ### END of def initialize ###



  def initProg

    setStyleSheet "QWidget { background-color: #000000 }"
    ### REF: build_image(width=20, height=10, hex_color="#00FF00", hex_offset="100", x_multiplier=10, y_multiplier=100)
    #
    # Creates initial images
    build_image_arrays
    
    # Build patterns from the orginial images, and pass to separate arrays for display later.
    patterns($orig_images[0], $active_images)
    patterns($orig_images[1], $active_images_2)
      
    # This was used as part of the build process, might get rid of it, or reincorporate.
    #
    if $oneimage != 1
      $active_images.push $orig_images[0].mirrored(true,false)
      $active_images.push $orig_images[0].rgbSwapped
      $active_images.push build_image(20, 10, "#0000FF", "F", 5, 10)
      $active_images.push build_image(10, 20, "#00FF00", "F", 1, 5)
      $active_images.push build_image(10, 20, "#FF0000", "F", 10, 5)
      # $active_images.push $active_images[3].invertPixels
    
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
  ### END of def initProg ###


 
  def build_image_arrays
    # Empty existing array
    $active_images=[]
    $active_images_2=[]
    $orig_images=[]
    $orig_images.push build_image($img_width, $img_height, $img_hex_color, $img_hex_offset, $img_x_multi, $img_y_multi)
    # Create mirror of the first array
    $orig_images.push $orig_images[0].mirrored(true,false)
  end
  ### END of def build_image_arrays 



  def patterns(image_num=$orig_images[0], image_array=$active_images)
      # Builds the pattern from the base image, used for building on the Y axis only at the moment.
      # Patterns were added as part of testing, maybe tidy up later?
      case $pattern
      when "up"
        image_array.each do |image|
          p = $initial_image_y
          q = 0
          while p < ( HEIGHT + $initial_image_y )
            q+=$offset
            image_array.push image_num.scaled( ( image.width - q ), image.height ) 
          p+=( image.height )
          end
        end
  
      when "down"
        image_array.each do |image|
          p = $initial_image_y
          q = 1
          while p < ( HEIGHT + $initial_image_y  )
            q+=$offset
            image_array.push image_num.scaled( ( image.width - q ), image.height ) 
            p+=( image.height )
            break if ( image_array[-1].width < 1 )
          end
        end

      when "down-up"
        image_array.each do |image|
          p = $initial_image_y
          q = 1
          while p < ( HEIGHT + $initial_image_y  )
            if p < ( HEIGHT / 2 )
              q+=$offset
            else
              q-=$offset
            end
            image_array.push image_num.scaled( ( image.width - q ), image.height ) 
            p+=( image.height )
            if ( image_array[-1].width < 1 )
              q-=( $offset * 2 )
            end
          end
        end

      when "up-down"
        image_array.each do |image|
          p = $initial_image_y
          q = 1
          while p < ( HEIGHT + $initial_image_y )
            if p < ( HEIGHT / 2 )
              q+=$offset
            else
              q-=$offset
            end
            image_array.push image_num.scaled( ( image.width + q ), image.height ) 
            p+=( image.height )
          end
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
              q+=$offset
            when 9..10
              q-=$offset
            end
          else
            case which_way
            when 0..3
             q+=$offset
            when 4..10
             q-=$offset
            end
          end
        image_array.push image_num.scaled( ( TEST_IMG_WIDTH + q ), height ) 
        p+=( height )
        end

      when "none"
          image_array.push image_num


    else # Catch all $pattern, not in case statement.
    end
  end
  ### END of def patterns ###


  def paintEvent event
 
    painter = Qt::Painter.new
    painter.begin self

    drawObjects painter

    painter.end
  
  end
  ### END of def paintEvent event


  
  def drawObjects painter
  
 
    draw_image_x = $initial_image_x
    draw_image_x = rand(300) if $pattern=="random"
    draw_image_y = $initial_image_y


    # Draw images from first array, stacking each based on the Y axis (starting from top)
    $active_images.each do |image|
      painter.drawImage draw_image_x, draw_image_y, image
      draw_image_y+=image.height + $image_offset_y
      draw_image_x+=1
      if $painter_diagnostics==1
        print "Image, W:", image.width, ", H:", image.height, ", draw_image_x: ", draw_image_x, ", draw_image_y: ", draw_image_y, "\n"
      end
    end
   
    print "First array, draw_image_y, stopped at: ", draw_image_y, "\n"
  

    # Draw images from second array, stacking based on Y axis (starting from bottom)
    draw_image_x = $initial_image_x
    draw_image_x = rand(200) if $pattern=="random"
    draw_image_y = HEIGHT

    $count_me=0  # Added this var to check all images were being printed
    $active_images_2.each do |image|
      $count_me+=1
      draw_image_y-=image.height + $image_offset_y
      painter.drawImage draw_image_x, draw_image_y, image
      temp_rand=rand()
      draw_image_x+=temp_rand
      if $painter_diagnostics==1
        print $count_me, ":: Image, W:", image.width, ", H:", image.height, ", draw_image_x: ", draw_image_x, ", draw_image_y: ", draw_image_y, "\n"
      end
    end

    print "$active_images_2.count: ", $active_images_2.count, "\n"
    print "Second array, draw_image_y, stopped at: ", draw_image_y, "\n"
    print "*** END *** \n\n"
  end
  ### END of def drawObjects painter ###



  def keyPressEvent event
   
    key = event.key
    puts key

    case key
      when Qt::Key_Q.value
        exit 0
      when Qt::Key_Space.value
        $img_hex_color=rand("ffffff".hex).to_s(16)
        print "Color: ", $img_hex_color, "\n"
      when Qt:: Key_B.value # Blue
        temp_rand=rand(1000)
        $img_hex_offset=( temp_rand -( temp_rand % 256 )  ).to_s(16)
        print "hex_offset: ", $img_hex_offset, "\n"
      when Qt:: Key_G.value
        temp_rand=rand(1677215)
        $img_hex_offset=( temp_rand -( temp_rand % 65535 )  ).to_s(16)
        print "hex_offset: ", $img_hex_offset, "\n"
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


    if key  # Prevents things happening when interacting with Window (e.g. moving with mouse)
      build_image_arrays
      patterns($orig_images[0], $active_images)
      patterns($orig_images[1], $active_images_2)
      repaint 
    else
    end

  end
  ### END of def keyPressEvent event ###
  


      

=begin
### Keeping here for reference ###
puts "HERE"
@test_abc=$active_images["left"].copy(0,0,5,5)
print "Pixel: ",@test_abc.pixel(2,3), "\n"
print "PixelIndex: ",@test_abc.pixelIndex(2,3), "\n"
@test_abc.save("local_copy.png")
$active_images["left"].save("shooty_left_100.png")
$active_images["left"].save("shooty_left_100.jpg")
puts "END"
###
    $temp_123=$pewpew_sprites["up"].mirrored(true,false)
    @marine=$temp_123.rgbSwapped
=end


  def build_image(width=20, height=10, hex_color="000000", hex_offset="100", x_multiplier=10, y_multiplier=100)    # Build an image up from one pixel
    pixelmax=width
   #  pixelmax=height unless width > height
    one_pixel = Qt::Image.new(1,1,4)  # third arg is format (see Qt Image ref)
    one_pixel.setPixel( 0, 0, 0 )  # third arg is color, decimal equiv of hex
  
    image_temp=one_pixel.scaled(width, height )
    
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
      image_temp.setPixel( p, 0, color )  
      if $pattern=="random"
        # Need the minus one here, as pixel co-ordinates start at zero
        (0..height-1).each do |pixel_y|
          image_temp.setPixel(p+rand(6), pixel_y, color )  
        end
      end
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
