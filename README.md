Traceur
==========

An experiment to have some fun with SVG and learn a little more
about Ruby.
If you want to get a visual for what is going on in your code you can
pass in a regular expression like ".+" or "downthetube".
Be specific otherwise you will end up with an SVG file so big 
that no program can open it. 

Usage:
------

```ruby
require 'rubygems'
require 'traceur'
require 'downthetube'

Traceur.watch_paths("downthetube", ".")

playlists = Youtube.playlists_for "stephensam"
videos = playlists.last.videos
puts videos.last.title

Traceur.stop
```


LICENSE:

(The MIT License)

Copyright © 2011 Mike Williamson


Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the ‘Software’), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED ‘AS IS’, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. 

