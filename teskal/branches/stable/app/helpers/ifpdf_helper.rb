# Teskal


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



require 'iconv'
require 'rfpdf/chinese'

module IfpdfHelper  
  
  class IFPDF < FPDF
    include GLoc
    attr_accessor :footer_date
    
    def initialize(lang)
      super()
      set_language_if_valid lang
      case current_language
      when :ja
        extend(PDF_Japanese)
        AddSJISFont()
        @font_for_content = 'SJIS'
        @font_for_footer = 'SJIS'
      when :zh
        extend(PDF_Chinese)
        AddBig5Font()
        @font_for_content = 'Big5'
        @font_for_footer = 'Big5'
      else
        @font_for_content = 'Arial'
        @font_for_footer = 'Helvetica'              
      end
      SetCreator("Teskal #{Teskal::VERSION}")
      SetFont(@font_for_content)
    end
    
    def SetFontStyle(style, size)
      SetFont(@font_for_content, style, size)
    end
      
    def Cell(w,h=0,txt='',border=0,ln=0,align='',fill=0,link='')
      @ic ||= Iconv.new(l(:general_pdf_encoding), 'UTF-8')
      txt = begin
        @ic.iconv(txt)
      rescue
        txt
      end
      super w,h,txt,border,ln,align,fill,link
    end
    
    def Footer
      SetFont(@font_for_footer, 'I', 8)
      SetY(-15)
      SetX(15)
      Cell(0, 5, @footer_date, 0, 0, 'L')
      SetY(-15)
      SetX(-30)
      Cell(0, 5, PageNo().to_s + '/{nb}', 0, 0, 'C')
    end
    
  end

end
