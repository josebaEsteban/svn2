# Copyright (C) 2007 Teskal


class Change < ActiveRecord::Base
  belongs_to :changeset
  
  validates_presence_of :changeset_id, :action, :path
end
