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
  @y = 0
  @footer = <<-EOSVG
  </g>
</svg>
EOSVG
  @header = <<-EOXML
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
   sodipodi:docname="drawing.svg">
  <defs
     id="defs4" />
  <sodipodi:namedview
     id="base"
     pagecolor="#ffffff"
     bordercolor="#666666"
     borderopacity="1.0"
     inkscape:pageopacity="0.0"
     inkscape:pageshadow="2"
     inkscape:zoom="0.35"
     inkscape:cx="375"
     inkscape:cy="520"
     inkscape:document-units="px"
     inkscape:current-layer="layer1"
     showgrid="false"
     inkscape:window-width="1440"
     inkscape:window-height="876"
     inkscape:window-x="0"
     inkscape:window-y="24"
     inkscape:window-maximized="1" />
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
        @x += 1 unless ((@start_time - Time.now.strftime("%s.%L").to_f).abs <= 0.1)
        if event.to_s == "call"
          points << " #{@x},#{@y}"
          labels << [methodname, [@x + 5, @y - 3]]
          @y += 10
          points << " #{@x},#{@y}"
        elsif event.to_s == "return"
          points << " #{@x},#{@y}"
          @y -= 10
          points << " #{@x},#{@y}"
        end
      end
    end
    Object.send(:set_trace_func, proc)
    block.call
    Object.send(:set_trace_func, nil)
    write_svg points, labels, output_dir
  end

  private

  def self.write_svg points, labels, directory
    filename = "trace_#{Time.now.strftime('%Y%m%d%H%M%S')}.svg"
    @svg_file = File.open(File.join(directory, filename), 'w+')
    @svg_file.write(@header)
    @svg_file.write(polygon(points))
    @svg_file.write(@footer)
    @svg_file.close
  end
  def self.polygon points
    "<polyline points=\"0,0#{ points.join }\" style=\"fill:none;stroke:black;stroke-width:3\" />"
  end

end

