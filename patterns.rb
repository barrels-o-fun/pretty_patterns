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

include Math

### Debug ###
$build_diagnostics=0
$painter_diagnostics=0
$board_diagnostics=1
$board_persp_diagnostics=0 
$oneimage=1
$pretty_patterns="on"
$game_board=true
$persp_board=false
$delay=0
$delay_refresh_space=2
$delay_refresh_pattern=1

### Constants
# Dimension of program window
WIDTH=1200
HEIGHT=800

# Constants for testing
TEST_IMG_WIDTH=450
TEST_IMG_HEIGHT=2
TEST_HEX_COLOR="#0000FF"
TEST_HEX_OFFSET="FF" 
TEST_IMG_X_MULTI=1
TEST_IMG_Y_MULTI=1
###

### Game board variables
$board_thickness=10
$border_increase=20
$border_offset=6
$board_sections=8
$line_length=10

### Changing these has no effect, they will be computed in the program.
$multiplier=0
$board_dimension=0
$board_square_dimension=0
$board_square_move_x=0
$board_square_move_y=0
######################

### Image positioning within the window 
$initial_image_x = 100
$initial_image_y = 50
$image_offset_x = 0
$image_offset_y = 0

## Perspective board
$board_persp_bottom= WIDTH - ( 2 * $initial_image_x )
$board_persp_offset= 60
$board_persp_top= $board_persp_bottom - $board_persp_offset
$board_persp_height= HEIGHT - ( 2 * $initial_image_y )


# Required for perspective board
$top_divisors=[]
$bottom_divisors=[]
$triangle_lengths=[]
$triangle_sections=[]

### Pattern variables
$img_width=TEST_IMG_WIDTH 
$img_height=TEST_IMG_HEIGHT
$img_hex_color=TEST_HEX_COLOR
$img_hex_offset=TEST_HEX_OFFSET
$img_x_multi=TEST_IMG_X_MULTI
$img_y_multi=TEST_IMG_Y_MULTI

$pattern="none"
$offset=2

### Global Arrays
$orig_images = []
$active_images = []
$active_images_2 = []


####


class Board < Qt::Widget

  
  def initialize(parent)
    super(parent)
        
    setFocusPolicy Qt::StrongFocus
    
    initProg
  end
  ### END of def initialize ###



  def initProg
    # REF: def build_image \
    # (width=20, height=10, hex_color="000000", hex_offset="100", x_multiplier=10, y_multiplier=100, orientation="horiz") \
    # - build an image up from one pixel

    setStyleSheet "QWidget { background-color: #000000 }"
    ### REF: 
    #
    # Creates initial images
    #
    
    calculate_board if $game_board==true
    calculate_board_persp if $persp_board == true
    build_image_arrays
    build_lines
 
    
    
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
    $active_images_3=[]
    $active_images_4=[]
    $orig_images=[]
    $orig_images.push build_image($img_width, $img_height, $img_hex_color, $img_hex_offset, $img_x_multi, $img_y_multi)
    # Create mirror of the first array
    $orig_images.push $orig_images[0].mirrored(true,false)
  end
  ### END of def build_image_arrays 


  
  def calculate_board
    if WIDTH < HEIGHT
      short_dimension = ( WIDTH - ( $initial_image_x * 2 ) - $board_thickness )
    else
      short_dimension = ( HEIGHT - ( $initial_image_y * 2 ) - $board_thickness )
    end

    temp_board_dimension = ( short_dimension  ) 
    $board_dimension = ( temp_board_dimension - ( temp_board_dimension % $board_sections ) ) 
    $board_square_dimension = ( $board_dimension / $board_sections )
    $board_left_limit = ( ( WIDTH - $board_dimension ) / 2  )
    $board_right_limit = $board_left_limit + ( ( $board_sections - 1 ) * $board_square_dimension )  
    $board_top_limit = $initial_image_y 
    $board_bottom_limit = HEIGHT - $initial_image_y

    if $board_diagnostics == 1
      print "***** BOARD ATTRIBUTES ******\n"
      print "$board_dimension: ", $board_dimension, "\n"
      print "$board_thickness: ", $board_thickness, "\n"
      print "$board_left_limit: ", $board_left_limit, "\n"
      print "$board_right_limit: ", $board_right_limit, "\n"
      print "$board_top_limit: ", $board_top_limit, "\n"
      print "$board_bottom_limit: ", $board_bottom_limit, "\n"
      print "$board_sections: ", $board_sections, "\n"
      print "$board_square_dimension: ", $board_square_dimension, "\n"
      print "Modulus: ", $board_dimension % $board_sections, "\n"
      print "$board_square_move_x: ", $board_square_move_x, "\n"
      print "$board_square_move_x_actual: ", $board_square_move_x + $board_left_limit, "\n"
      print "$board_square_move_y: ", $board_square_move_y, "\n"
      print "$board_square_move_y_actual: ", $board_square_move_y + $board_left_limit, "\n"
      print "*****************************\n"
    end
  end
  ### END of def calculate_board
  


  def calculate_board_persp
    if WIDTH < HEIGHT
      short_dimension = ( WIDTH - ( $initial_image_x * 2 ) - $board_thickness )
    else
      short_dimension = ( HEIGHT - ( $initial_image_y *2 ) - $board_thickness )
    end
   
    # Calculate length
    # $board_persp_bottom= WIDTH - ( 2 * $initial_image_x )
    # $board_persp_offset=100
    # $board_persp_top= $board_persp_bottom - $board_persp_offset
    
    
    # Reset arrays, prior to building with new parameters     
    $top_divisors=[]
    $bottom_divisors=[]
    $triangle_lengths=[]
    $triangle_sections=[]

    top_division = $board_persp_top / $board_sections
    bottom_division = ($board_persp_bottom - $board_thickness )/ $board_sections
    (0..$board_persp_top).each do |divisor|
      if divisor % top_division == 0
        $top_divisors.push divisor
      end 
    end
    (0..$board_persp_bottom).each do |divisor|
      if divisor % bottom_division == 0
        $bottom_divisors.push divisor
      end 
    end

    (0..$board_sections).each do |num|
        case num
#        when 0
 #         a = $board_persp_offset 
        when (0..( $board_sections / 2 ))
          a = $top_divisors[num] + ( $board_persp_offset / 2 )- $bottom_divisors[num]
        when (($board_sections / 2 )..$board_sections)
          a = $bottom_divisors[num] - ( $top_divisors[num] + ( $board_persp_offset / 2 ) )
        else
          a = 500
        end      
      b = HEIGHT - ( $initial_image_y * 2)
      c = sqrt(Complex((a * a) + (b*b)))
      $triangle_lengths.push c.to_i
      if a > 0
        $triangle_sections.push ( $triangle_lengths[num] / a )
      else
        $triangle_sections.push 0
      end
    end
    if $board_persp_diagnostics == 1
      print "Top divisors: ", $top_divisors.to_s, "\n"
      print "Bottom divisors: ", $bottom_divisors.to_s, "\n"
      print "Triangle_lengths: ", $triangle_lengths.to_s, "\n"
      print "Triangle_sections: ", $triangle_sections.to_s, "\n"
    end

  end
     



  def build_lines
    if HEIGHT > WIDTH
      $multiplier=( $board_dimension / $line_length ) 
    else
      $multiplier=( $board_dimension / $line_length )
    end
    @line_horiz = build_image($line_length, 1, $img_hex_color, $img_hex_offset, $multiplier, $board_thickness, "horiz")
    @line_verti = build_image(1, $line_length, $img_hex_color, $img_hex_offset, $board_thickness, $multiplier, "verti")

    # Create border
    # 
    $board_horiz_border=[]
    local_hex_color=0
    local_x_offset=0
    (1..$board_thickness+$border_increase).each do  |step|
      $board_horiz_border.push build_image($board_dimension - $board_thickness + ( 2 *  $border_offset ) + 2 + local_x_offset, 1, ($img_hex_color.hex + local_hex_color).to_s(16), $img_hex_offset, 1, 1, "verti")
      local_hex_color+=$img_hex_offset.hex
      local_x_offset+=2
    end

    $board_verti_border=[]
    local_hex_color=0
    local_y_offset=0
    (1..$board_thickness+$border_increase).each do |step|
      $board_verti_border.push build_image(1, $board_dimension - $board_thickness + ( 2 * $border_offset ) + 2 + local_y_offset, ($img_hex_color.hex + local_hex_color).to_s(16), $img_hex_offset, 1, 1, "horiz")
      local_hex_color+=$img_hex_offset.hex
      local_y_offset+=2
    end
    print "Horiz_border: ", $board_horiz_border.count, "\n"
    print "Verti_border: ", $board_verti_border.count, "\n"

  end
  ### END of def build_lines


  def patterns(image_num=$orig_images[0], image_array=$active_images)
      # Builds the pattern from the base image, used for building on the Y axis only at the moment.
      # Patterns were added as part of testing, maybe tidy up later?
      case $pattern
      when "up"
        width = HEIGHT / 4
        p = 0
        q = 0
        while p < ( HEIGHT )
          q+=$offset
          image_array.push image_num.scaled( ( width + q ), $img_height ) 
        p+=( $img_height * 2)
        end
  
      when "down"
        width = HEIGHT / 2
        p = 0
        q = 0
        while p < ( HEIGHT )
          q+=$offset
          image_array.push image_num.scaled( ( width - q ), $img_height ) 
          p+=( $img_height )
        break if ( image_array[-1].width < 1 )
        end

      when "down-up"
        p = 0
        q = 0
        while p < ( HEIGHT  )
          if p < ( HEIGHT / 2 )
            q+=$offset
          else
            q-=$offset
          end
          image_array.push image_num.scaled( ( $img_width - q ), $img_height ) 
          p+=( $img_height )
          if ( image_array[-1].width < 1 && p < (HEIGHT / 2  ))
            q-=( $offset * 2 )
          end
      end

      when "up-down"
        width = $img_width / 4
        p = 0
        q = 0
        while p < ( HEIGHT  )
          if p < ( HEIGHT / 2 )
            q+=$offset
          else
            q-=$offset
          end
          image_array.push image_num.scaled( ( width + q ), $img_height ) 
        p+=( $img_height )
        end
   
      when "random"
        p = 0
        q = rand(15)
        pre_height=height
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

    # Scale lines to board dimension
    board_horiz = @line_horiz.scaled($board_dimension + $board_thickness, $board_thickness )
    board_verti = @line_verti.scaled($board_thickness, $board_dimension + $board_thickness )
    board_square_horiz_top = @line_horiz.scaled($board_square_dimension + $board_thickness, $board_thickness )
    board_square_horiz_top.invertPixels
    board_square_horiz_bottom = board_square_horiz_top.mirrored(false,true)
    board_square_verti_left = @line_horiz.scaled($board_thickness, $board_square_dimension + $board_thickness)
    board_square_verti_left.invertPixels
    board_square_verti_right = board_square_verti_left.mirrored(true, false)
   
    if $game_board==true
      # Paint horizontal lines
      board_lines_pos_y= 0
      while board_lines_pos_y <= $board_dimension 
        painter.drawImage $board_left_limit, $initial_image_y + board_lines_pos_y, board_horiz
        board_lines_pos_y+= ( $board_dimension /  $board_sections  )
      end

      # Paint vertical lines
      board_lines_pos_x= 0
      while board_lines_pos_x <= $board_dimension 
        painter.drawImage $board_left_limit + board_lines_pos_x, $initial_image_y, board_verti
        board_lines_pos_x+= ( $board_dimension / $board_sections )
      end
 
      # Painter border
      # Horizontal
      local_x_offset=0
      local_y_offset=0
      $board_horiz_border.each do |paint|
        painter.drawImage $board_left_limit + $board_thickness - $border_offset - local_x_offset, $initial_image_y + $board_thickness - $border_offset - 2 - local_y_offset, paint
        painter.drawImage $board_left_limit + $board_thickness - $border_offset - local_x_offset, $initial_image_y + $board_dimension + $border_offset + 1 + local_y_offset, paint
        local_x_offset+=1
        local_y_offset+=1
      end
 
      # Vertical
      local_x_offset=0
      local_y_offset=0
      $board_verti_border.each do |paint|
        painter.drawImage $board_left_limit + $board_thickness - $border_offset - local_x_offset, $initial_image_y + $board_thickness - $border_offset  - 1 - local_y_offset, paint
        painter.drawImage $board_right_limit + $board_square_dimension + $border_offset + 1 + local_x_offset, $initial_image_y + $board_thickness - $border_offset - 1 - local_y_offset, paint
        local_x_offset+=1
        local_y_offset+=1
      end




      # Paint the highlight box
      square_pos_x= $board_left_limit + $board_square_move_x
      square_pos_y= $initial_image_y + $board_square_move_y
      painter.drawImage square_pos_x, square_pos_y, board_square_horiz_top
      painter.drawImage square_pos_x, square_pos_y, board_square_verti_left
      painter.drawImage square_pos_x, square_pos_y + $board_square_dimension, board_square_horiz_bottom
      painter.drawImage square_pos_x + $board_square_dimension, square_pos_y, board_square_verti_right
    
    end


    if $persp_board==true
    # Paint 3D board (in progress)

      board_top = @line_horiz.scaled($board_persp_top, $board_thickness )
      board_bottom = @line_horiz.scaled($board_persp_bottom, $board_thickness )
      painter.drawImage $initial_image_x + ( $board_persp_offset / 2 ), $initial_image_y, board_top
      painter.drawImage $initial_image_x, HEIGHT - $initial_image_y, board_bottom
 
      (0..$triangle_lengths.count-1).each do |num|
        if $triangle_sections[num]!=0
          line_sec = @line_verti.scaled($board_thickness, $triangle_sections[num] )
          x_adjust=0
          y_adjust=$initial_image_y
          (0..$triangle_lengths.count-1).each do |adjust|
          if $triangle_sections[num]!=0
            while y_adjust < $board_persp_height + $initial_image_y
              painter.drawImage $top_divisors[num] + ($board_persp_offset / 2 ) + $initial_image_x - x_adjust, y_adjust,  line_sec
              if num < ( $board_sections / 2 )
                x_adjust+=1
              elsif num > ( $board_sections / 2 )
                x_adjust-=1
              end
              y_adjust+=$triangle_sections[num]  
            end
          else
          end
        end
        elsif$triangle_sections[num]==0
          print "HERE"
          middle_line = @line_verti.scaled($board_thickness, $board_persp_height ) 
          painter.drawImage $top_divisors[num] + ($board_persp_offset / 2 ) + $initial_image_x, $initial_image_y, middle_line
        else # Catch negative numbers
        end
      end 
    end
    # END of perspective board code

    ### PRETTY PATTERNS ###
    ## 
    # Check pattern and place origin
    draw_image_y = 0
    case $pattern
    when "up"
      draw_image_x = rand(( $initial_image_x * 2)..( WIDTH / 2 ))
    when "down"
      draw_image_x = $initial_image_x
    when "down-up"
      draw_image_x = WIDTH - $initial_image_x - $active_images[0].width
    when "up-down"
      draw_image_x = WIDTH - ( $initial_image_x / 2 ) - $active_images[0].width
    when "random"
      draw_image_x = rand(300) if $pattern=="random"
    else
      draw_image_x = $initial_image_x
    end

    # Draw images from first array, stacking each based on the Y axis (starting from top)
    $active_images.each do |image|
      painter.drawImage draw_image_x, draw_image_y, image
      draw_image_y+=image.height + $image_offset_y
      case $pattern
      when "up"
        draw_image_x-=1
      when "down-up"
        if draw_image_y < ( HEIGHT / 2 )
         draw_image_x+=3
        elsif draw_image_y > (HEIGHT / 2 )
         draw_image_x-=3
        else
        end
      when "up-down"
        if draw_image_y < ( HEIGHT / 2 ) 
         draw_image_x-=1
        elsif draw_image_y > ( HEIGHT / 2 ) 
         draw_image_x+=1
        else
        end
      else
        draw_image_x+=1
      end
      if $painter_diagnostics==1
        print "Image, W:", image.width, ", H:", image.height, ", draw_image_x: ", draw_image_x, ", draw_image_y: ", draw_image_y, "\n"
      end
    end
   
    print "First array, draw_image_y, stopped at: ", draw_image_y, "\n"
  

    # Draw images from second array, stacking based on Y axis (starting from bottom)
    draw_image_y = HEIGHT - $active_images[0].height
    case $pattern
    when "up"
      draw_image_x = rand( ( WIDTH / 2 )..WIDTH - ( $initial_image_x * 2 ) ) 
    when "down"
      draw_image_x = $initial_image_x
    when "down-up"
      draw_image_x = $initial_image_x 
    when "down-up"
      draw_image_x = $initial_image_x / 2 
    when "random"
      draw_image_x = rand(WIDTH)
    else
      draw_image_x = $initial_image_x
    end

    $count_me=0  # Added this var to check all images were being printed
    $active_images_2.each do |image|
      $count_me+=1
      draw_image_y-=image.height + $image_offset_y
        painter.drawImage draw_image_x, draw_image_y, image
      case $pattern
      when "up"
        draw_image_x-=1
      when "down-up"
        if draw_image_y < ( HEIGHT / 2 )
         draw_image_x+=1
        elsif draw_image_y > ( HEIGHT / 2 )
         draw_image_x-=1
        else
        end
      when "up-down"
        if draw_image_y < ( HEIGHT / 2 )
         draw_image_x+=1
        elsif draw_image_y > ( HEIGHT / 2 )
         draw_image_x-=1
        else
        end
      when "random"
        temp_rand=rand()
        draw_image_x+=temp_rand
      else
        draw_image_x+=1
      end
      if $painter_diagnostics==1
        print $count_me, ":: Image, W:", image.width, ", H:", image.height, ", draw_image_x: ", draw_image_x, ", draw_image_y: ", draw_image_y, "\n"
        print "$active_images_2.count: ", $active_images_2.count, "\n"
        print "Second array, draw_image_y, stopped at: ", draw_image_y, "\n"
        print "*** END *** \n\n"
      end
    end
    

    # Draw images for the third pattern (if enabled) - Stacks images starting from the TOP
    case $pattern
    when "down"
      draw_image_x = WIDTH - $initial_image_x - $active_images[0].width 
      draw_image_y = 0
      # Draw images from first array, but place on new Y
      $active_images.each do |image|
      painter.drawImage draw_image_x, draw_image_y, image
      draw_image_y+=image.height + $image_offset_y
        draw_image_x+=1
      end
    when "down-up"
      draw_image_x = ( WIDTH / 2 ) - ( $active_images[0].width / 2 )
      draw_image_y-= 0
      $active_images.each do |image|
        painter.drawImage draw_image_x, draw_image_y, image
        draw_image_y+=image.height + $image_offset_y
        if draw_image_y < ( HEIGHT / 2 )
         draw_image_x+=1
        else
         draw_image_x-=1
        end
      end
    # when "random"
    # draw_image_x = rand(300) if $pattern=="random"
    else
    end

    
    # Draw images for the fourth pattern (if enabled) - Stacks images, starting from the BOTTOM
    case $pattern
    when "down"
      draw_image_x = WIDTH - $initial_image_x - $active_images[0].width 
      draw_image_y = HEIGHT - $active_images[0].height
      # Draw images from first array, but place on new Y
      $active_images_2.each do |image|
      painter.drawImage draw_image_x, draw_image_y, image
      draw_image_y-=image.height + $image_offset_y
        draw_image_x+=1
      end
#    when "random"
#      draw_image_x = rand(300) if $pattern=="random"
    else
    end

  end
  ### END of def drawObjects painter ###



  def keyPressEvent event
   
    key = event.key
    puts key

    case key
      when Qt::Key_Q.value
        exit 0
      
      when Qt::Key_Space.value
        $delay+=1
        if $delay==$delay_refresh_space
          $img_hex_color=rand("ffffff".hex).to_s(16)
          print "Color: ", $img_hex_color, "\n"
          $delay=0
          $board_square_move_x=( rand(1..$board_sections-1) * $board_square_dimension )
          $board_square_move_y=( rand(1..$board_sections-1) * $board_square_dimension )
        end
      
      when Qt:: Key_B.value # Blue
        temp_rand=rand(1000)
        $img_hex_offset=( temp_rand -( temp_rand % 256 )  ).to_s(16)
        print "hex_offset: ", $img_hex_offset, "\n"
      
      when Qt:: Key_G.value
        temp_rand=rand(1677215)
        $img_hex_offset=( temp_rand -( temp_rand % 65535 )  ).to_s(16)
        print "hex_offset: ", $img_hex_offset, "\n"
      
      when Qt::Key_S.value
          case $pattern
          when "up"
            $pattern = "down"
          when "down"
            $pattern = "up-down"
          when "up-down"
            $pattern = "down-up"
          when "down-up"
            $pattern = "up"
          else
            $pattern = "up"
          end 
 
      when Qt::Key_R.value
        $pattern = "random" # unless $pretty_patterns=="off"
     
      when Qt::Key_I.value
        # Just refreshes        
    
      when Qt::Key_L.value
        $line_length=rand(1..$board_dimension)
        print "$line_length: ", $line_length, "\n"

      when Qt::Key_T.value
        print "$board_thickness: ", $board_thickness, "\n"
        print "$board_dimension: ", $board_dimension, "\n"
        print "$board_dimension / $board_sections: ",  ( $board_dimension / $board_sections ), "\n"
        print "$multiplier: ", $multiplier, "\n"
        print "@horiz length: ", @line_horiz.width, "\n"
        print "@verti length: ", @line_verti.height, "\n"
        $board_thickness=rand(1..50)
        $board_square_move_x = 0
        $board_square_move_y = 0

      ## Board highlight_movement
      when Qt::Key_Left.value
        $board_square_move_x-= $board_square_dimension  unless $board_square_move_x <= 0
      when Qt::Key_Right.value
        $board_square_move_x+= $board_square_dimension  unless $board_square_move_x >= $board_right_limit - $board_left_limit
      when Qt::Key_Up.value
        $board_square_move_y-= $board_square_dimension  unless $board_square_move_y <= 0
      when Qt::Key_Down.value
        $board_square_move_y+= $board_square_dimension  unless $board_square_move_y >= $board_bottom_limit -  ( 2 * $board_square_dimension )

      # Change board size
      when Qt::Key_Plus.value
        $board_sections+=1
        $board_square_move_x=0
        $board_square_move_y=0
      when Qt::Key_Minus.value
        $board_sections-=1 unless $board_sections==1
        $board_square_move_x=0
        $board_square_move_y=0
      else
    end  


    if key  # Prevents things happening when interacting with Window (e.g. moving with mouse)
      build_image_arrays
     
      if $pretty_patterns=="on"
        patterns($orig_images[0], $active_images)
        patterns($orig_images[1], $active_images_2)
      else
        $active_images.push $orig_images[0].scaled( $img_width, $img_height ) 
        $active_images_2.push $orig_images[0].mirrored(true,false)
      end
     
      calculate_board 
      build_lines
      calculate_board_persp
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


  def build_image(width=20, height=10, hex_color="000000", hex_offset="100", x_multiplier=10, y_multiplier=100, orientation="horiz")    # Build an image up from one pixel
    case orientation
    when "horiz"
      pixelmax=width
    when "verti"
      pixelmax=height
    end

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
      image_temp.setPixel( p, 0, color )  if pixelmax==width
      image_temp.setPixel( 0, p, color )  if pixelmax==height
      if pixelmax==width
        (0..height-1).each { |pixel_y| image_temp.setPixel( p, pixel_y, color ) }
      elsif pixelmax==height
          (0..width-1).each { |pixel_x| image_temp.setPixel( pixel_x, p, color ) }
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
