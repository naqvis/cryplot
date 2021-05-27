require "./base"
require "./offset"
require "./text"

module Cryplot
  # mixin used to attach title options to a type
  module TitleMixin(T)
    include BaseMixin(T)

    # the text of the title
    @title : String = ""
    # The text options for the title
    @text : Text = Text.new
    # The offset options for the title
    @offset : Offset = Offset.new

    # Set the text of the title.
    def title(text : String)
      @title = "'#{text}'"
      self.as(T)
    end

    # Shift the title element along the x direction by given number of characters (can be fraction).
    def title_shift_along_x(val : Number)
      @offset.shift_along_x(val)
      self.as(T)
    end

    # Shift the title element along the y direction by given number of characters (can be fraction).
    def title_shift_along_y(val : Number)
      @offset.shift_along_y(val)
      self.as(T)
    end

    # Shift the title element along the x direction within the graph coordinate system.
    def title_shift_along_graph_x(val : Number)
      @offset.shift_along_graph_x(val)
      self.as(T)
    end

    # Shift the title element along the y direction within the graph coordinate system.
    def title_shift_along_graph_y(val : Number)
      @offset.shift_along_graph_y(val)
      self.as(T)
    end

    # Shift the title element along the x direction within the screen coordinate system.
    def title_shift_along_screen_x(val : Number)
      @offset.shift_along_screen_x(val)
      self.as(T)
    end

    # Shift the title element along the y direction within the screen coordinate system.
    def title_shift_along_screen_y(val : Number)
      @offset.shift_along_screen_y(val)
      self.as(T)
    end

    # Set the color of the title text (e.g., `"blue"`, `"#404040"`)
    def title_text_color(color : String)
      @text.text_color(color)
      self.as(T)
    end

    # Set the font name of the title text (e.g., Helvetica, Georgia, Times).
    def title_font_name(name : String)
      @text.font_name(name)
      self.as(T)
    end

    # Set the font point size of the title text (e.g., 10, 12, 16).
    def title_font_size(size : Int32)
      @text.font_size(size)
      self.as(T)
    end

    def title_repr
      return "" if @title.blank? || @title == "''"
      String.build do |sb|
        sb << "title #{@title} "
        sb << @text.repr << " "
        sb << @offset.repr << " "
      end.squeeze(' ').strip
    end
  end

  class Title
    include TitleMixin(Title)

    def initialize
      super
      title("")
    end

    def repr : String
      title_repr
    end

    def to_s(io : IO) : Nil
      io << repr
    end
  end
end
