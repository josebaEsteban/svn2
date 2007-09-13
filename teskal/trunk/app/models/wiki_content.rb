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



require 'zlib'

class WikiContent < ActiveRecord::Base
  set_locking_column :version
  belongs_to :page, :class_name => 'WikiPage', :foreign_key => 'page_id'
  belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
  validates_presence_of :text
  
  acts_as_versioned
  class Version
    belongs_to :page, :class_name => 'WikiPage', :foreign_key => 'page_id'
    belongs_to :author, :class_name => 'User', :foreign_key => 'author_id'
    attr_protected :data
    
    def text=(plain)
      case Setting.wiki_compression
      when 'gzip'
      begin
        self.data = Zlib::Deflate.deflate(plain, Zlib::BEST_COMPRESSION)
        self.compression = 'gzip'
      rescue
        self.data = plain
        self.compression = ''
      end
      else
        self.data = plain
        self.compression = ''
      end
      plain
    end
    
    def text
      @text ||= case compression
      when 'gzip'
         Zlib::Inflate.inflate(data)
      else
        # uncompressed data
        data
      end      
    end
  end
  
end
