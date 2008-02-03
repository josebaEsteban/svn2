# Copyright (C) 2007 Teskal

require "digest/md5"

class Attachment < ActiveRecord::Base
  belongs_to :container, :polymorphic => true
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"
  
  validates_presence_of :container, :filename
  
  cattr_accessor :storage_path
  @@storage_path = "#{RAILS_ROOT}/files"
  
  def validate
    errors.add_to_base :too_long if self.filesize > Setting.attachment_max_size.to_i.kilobytes
  end

	def file=(incomming_file)
		unless incomming_file.nil?
			@temp_file = incomming_file
			if @temp_file.size > 0
				self.filename = sanitize_filename(@temp_file.original_filename)
				self.disk_filename = DateTime.now.strftime("%y%m%d%H%M%S") + "_" + self.filename
				self.content_type = @temp_file.content_type
				self.filesize = @temp_file.size
			end
		end
	end
	
	def file
	 nil
	end
	
	# Copy temp file to its final location
	def before_save
		if @temp_file && (@temp_file.size > 0)
			logger.debug("saving '#{self.diskfile}'")
			File.open(diskfile, "wb") do |f| 
				f.write(@temp_file.read)
			end
			self.digest = Digest::MD5.hexdigest(File.read(diskfile))
		end
	end
	
	# Deletes file on the disk
	def after_destroy
		if self.filename?
			File.delete(diskfile) if File.exist?(diskfile)
		end
	end
	
	# Returns file's location on disk
	def diskfile
		"#{@@storage_path}/#{self.disk_filename}"
	end
  
  def increment_download
    increment!(:downloads)
  end
	
	# returns last created projects
	def self.most_downloaded
		find(:all, :limit => 5, :order => "downloads DESC")	
	end

  def project
    container.is_a?(Project) ? container : container.project
  end
  
private
  def sanitize_filename(value)
      # get only the filename, not the whole path
      just_filename = value.gsub(/^.*(\\|\/)/, '')
      # NOTE: File.basename doesn't work right with Windows paths on Unix
      # INCORRECT: just_filename = File.basename(value.gsub('\\\\', '/')) 

      # Finally, replace all non alphanumeric, underscore or periods with underscore
      @filename = just_filename.gsub(/[^\w\.\-]/,'_') 
  end
    
end
