class Traceur

  class NoBlockError < StandardError; end
  ##
  # The traceur class provides methods to trace the execution
  # of the Ruby interpreter and writes an SVG file into the
  # directory you choose.
  #
  @start_time = nil
  @svg_file = nil
  @trace_points = []
  @x = 0
  @y = 100
  @max_y = @y
  @footer = <<-EOSVG
  </g>
</svg>
EOSVG

  def self.watch_paths(expr, output_dir)
    raise NoBlockError "You must call this method with a block" unless block_given?
    block = Proc.new #this grabs the block

    raise SystemCallError "Directory does not exist" unless Dir.exists?(output_dir)

    labels = []
    points = []
    expression = Regexp.new expr
    proc = Proc.new do |event, file, line, methodname, binding, classname|
      if expression.match file
        @start_time ||= Time.now.strftime("%s.%L").to_f
        @x += 1
        if event.to_s == "call"
          points << " #{@x},#{@y}"
          labels << ["#{classname}##{methodname}", [@x + 1, @y]]
          @y += 10
          @max_y = @y if @y > @max_y
          points << " #{@x},#{@y}"
        elsif event.to_s == "return"
          points << " #{@x},#{@y}"
          @y -= 10
          points << " #{@x},#{@y}"
          labels << ["#{classname}##{methodname}", [@x - 1, @y]]
        end
      end
    end
    Object.send(:set_trace_func, proc)
    block.call
    Object.send(:set_trace_func, nil)
    write_svg points, labels, output_dir, {x: @x, y: @max_y}
  end

  private

  def self.write_svg points, labels, directory, dimensions
    filename = "trace_#{Time.now.strftime('%Y%m%d%H%M%S')}.svg"
    @svg_file = File.open(File.join(directory, filename), 'w+')
    @svg_file.write(header(dimensions))
    @svg_file.write(polygon(points))
    labels.each do |details|
      @svg_file.write label(details)
    end
    @svg_file.write(@footer)
    @svg_file.close
  end

  def self.header dimensions
  header = <<-EOXML
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!-- Created with Inkscape (http://www.inkscape.org/) -->

<svg
   xmlns:dc="http://purl.org/dc/elements/1.1/"
   xmlns:cc="http://creativecommons.org/ns#"
   xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
   xmlns:svg="http://www.w3.org/2000/svg"
   xmlns="http://www.w3.org/2000/svg"
   xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
   xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
   id="svg2"
   version="1.1"
   inkscape:version="0.48.2 r9819"
   sodipodi:docname="drawing.svg"
   width="#{dimensions[:x]}"
   height="#{dimensions[:y]}">
  <defs
     id="defs4" />
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="1"
     inkscape:document-units="px"
     inkscape:current-layer="layer1"
     showgrid="false"
     inkscape:window-maximized="1"
     fit-margin-top="0"
     fit-margin-left="0"
     fit-margin-right="0"
     fit-margin-bottom="0" />
  <metadata
     id="metadata7">
    <rdf:RDF>
      <cc:Work
         rdf:about="">
        <dc:format>image/svg+xml</dc:format>
        <dc:type
           rdf:resource="http://purl.org/dc/dcmitype/StillImage" />
        <dc:title></dc:title>
      </cc:Work>
    </rdf:RDF>
  </metadata>
  <g inkscape:label="Layer 1"
     inkscape:groupmode="layer"
     id="layer1">
EOXML
  end

  def self.polygon points
    "<polyline points=\"0,100#{ points.join }\" style=\"fill:none;stroke:black;stroke-width:1;opacity:0.5\" />"
  end

  def self.label details
    text =<<-EOTXT
       <text style="font-size:1px;fill:#000000;stroke:none;font-family:Sans"
       transform="rotate(90 #{details[1][0]},#{details[1][1]})"
       x="#{details[1][0]}"
       y="#{details[1][1]}"
       id="text2988">#{details[0]}</text>
    EOTXT
  end

end

