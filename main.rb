#!/usr/bin/ruby

# Author: Barrels-o-fun

require 'Qt'
require_relative 'ruby_qt_test'

class QtApp < Qt::MainWindow
    
    def initialize
        super
        
        setWindowTitle "Look mum, no hands!"
       
        setCentralWidget Board.new(self)
       
        resize WIDTH, HEIGHT
        center

        show
    end

    def center
    qdw = Qt::DesktopWidget.new

    screenWidth = qdw.width
    screenHeight = qdw.height

    x = (screenWidth - WIDTH) / 2
    y = (screenHeight - HEIGHT) / 2

    move x-550, y-200
  end

end

app = Qt::Application.new ARGV
QtApp.new
app.exec
