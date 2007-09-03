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



class SysApi < ActionWebService::API::Base
  api_method :projects,
             :expects => [],
             :returns => [[Project]]
  api_method :repository_created,
             :expects => [:int, :string],
             :returns => [:int]
end
