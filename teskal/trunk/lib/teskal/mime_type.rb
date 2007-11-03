# Teskal

# Copyright (C) 2007 Teskal
#

# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 


# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License



module Teskal
  module MimeType

    MIME_TYPES = {
      'text/plain' => 'txt',
      'text/css' => 'css',
      'text/html' => 'html,htm,xhtml',
      'text/x-javascript' => 'js',
      'text/x-html-template' => 'rhtml',
      'text/x-ruby' => 'rb,ruby',
      'image/gif' => 'gif',
      'image/jpeg' => 'jpg,jpeg,jpe',
      'image/png' => 'png',
      'image/tiff' => 'tiff,tif'
    }.freeze
    
    EXTENSIONS = MIME_TYPES.inject({}) do |map, (type, exts)|
      exts.split(',').each {|ext| map[ext] = type}
      map
    end
    
    # returns mime type for name or nil if unknown
    def self.of(name)
      return nil unless name
      m = name.to_s.match(/\.([^\.]+)$/)
      EXTENSIONS[m[1]] if m
    end
    
    def self.main_mimetype_of(name)
      mimetype = of(name)
      mimetype.split('/').first if mimetype
    end
    
    # return true if mime-type for name is type/*
    # otherwise false
    def self.is_type?(type, name)
      main_mimetype = main_mimetype_of(name)
      type.to_s == main_mimetype
    end  
  end
end
