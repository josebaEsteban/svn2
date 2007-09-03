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



module SearchHelper
  def highlight_tokens(text, tokens)
    return text unless tokens && !tokens.empty?
    regexp = Regexp.new "(#{tokens.join('|')})", Regexp::IGNORECASE    
    result = ''
    text.split(regexp).each_with_index do |words, i|
      result << (i.even? ? (words.length > 100 ? "#{words[0..44]} ... #{words[-45..-1]}" : words) : content_tag('span', words, :class => 'highlight'))
    end
    result
  end
end
