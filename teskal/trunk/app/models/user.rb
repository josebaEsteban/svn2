# Copyright (C)2007  Teskal

require "digest/sha1"

class User < ActiveRecord::Base
  # Account statuses
  STATUS_ANONYMOUS  = 0
  STATUS_ACTIVE     = 1
  STATUS_REGISTERED = 2
  STATUS_LOCKED     = 3
  ROLE_GRATIS       = 1
  ROLE_ATHLETE      = 2
  ROLE_COACH        = 3
  ROLE_TUTOR        = 4

  has_attached_file :picture,
  # :path => ":rails_root/public/pictures/:id_:extension",
  :url => "/:attachment/:id/:style/:basename.:extension",
  :styles => { :medium => "200x200>", :thumb => "65x65>" }

  has_many :answers
  has_one :preference, :dependent => :destroy, :class_name => 'UserPreference'
  composed_of :timezone, :class_name => 'TZInfo::Timezone', :mapping => %w( time_zone time_zone )

  attr_accessor :password, :password_confirmation
  attr_accessor :last_before_login_on
  # Prevents unauthorized assignments
  attr_protected :login, :admin, :password, :password_confirmation, :hashed_password

  validates_presence_of :login, :mail
  # validates_presence_of :firstname, :lastname,
  validates_uniqueness_of :login, :mail
  # Login must contain lettres, numbers, underscores only
  validates_format_of :login, :with => /^[a-z0-9_\-@\.]+$/i
  validates_length_of :login, :maximum => 30
  # validates_format_of :firstname, :lastname, :with => /^[\w\s\'\-]*$/i
  # validates_length_of :firstname, :lastname, :maximum => 30
  validates_format_of :mail, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_length_of :mail, :maximum => 60
  # Password length between 4 and 12
  validates_length_of :password, :in => 4..12, :allow_nil => true
  validates_confirmation_of :password, :allow_nil => true

  def before_save
    # update hashed_password if password was set
    self.hashed_password = User.hash_password(self.password) if self.password
  end

  def self.active
    with_scope :find => { :conditions => [ "status = ?", STATUS_ACTIVE ] } do
      yield
    end
  end

  def self.find_active(*args)
    active do
      find(*args)
    end
  end

  # Returns the user that matches provided login and password, or nil
  def self.try_to_login(login, password)
    user = find(:first, :conditions => ["login=?", login])
    if user
      # user is already in local database
      return nil if !user.active?
      entra=0
      if entra==1
        # aqui habia una autentificacion ldap
      else
        # authentication with local password
        return nil unless User.hash_password(password) == user.hashed_password
      end
    else
      # user is not yet registered, try to authenticate with available sources

    end
    user.update_attribute(:last_login_on, Time.now) if user
    user

  rescue => text
    raise text
  end

  # Return user's full name for display
  def name
    if (self.firstname+ self.lastname).length == 0
      "#{login}"
    else
      "#{firstname} #{lastname}"
    end
  end

  def active?
    self.status == STATUS_ACTIVE
  end

  def registered?
    self.status == STATUS_REGISTERED
  end

  def locked?
    self.status == STATUS_LOCKED
  end

  def check_password?(clear_password)
    User.hash_password(clear_password) == self.hashed_password
  end

  def pref
    self.preference ||= UserPreference.new(:user => self)
  end

  def suscription?
    self.role > ROLE_GRATIS
  end

  def gratis?
    self.role == ROLE_GRATIS
  end

  def show?
    self.role > ROLE_ATHLETE
  end

  def athlete?
    self.role == ROLE_ATHLETE
  end

  def coach?
    self.role == ROLE_COACH
  end

  def tutor?
    self.role == ROLE_TUTOR
  end

  def managed_by?
  end

  def my_role
    my_role=""
    case self.role
    when ROLE_GRATIS
      my_role= l(:label_role_1)
    when ROLE_ATHLETE
      my_role=l(:label_role_2)
    when ROLE_COACH
      my_role=l(:label_role_3)
    when ROLE_TUTOR
      my_role=l(:label_role_4)
    end
    return my_role
  end


  def self.find_by_autologin_key(key)
    token = Token.find_by_action_and_value('autologin', key)
    token && (token.created_on > Setting.autologin.to_i.day.ago) && token.user.active? ? token.user : nil
  end


  def <=>(user)
    user.nil? ? -1 : (lastname == user.lastname ? firstname <=> user.firstname : lastname <=> user.lastname)
  end

  def to_s
    name
  end

  def logged?
    true
  end

  def self.current=(user)
    @current_user = user
  end

  def self.current
    @current_user ||= User.anonymous
  end

  def self.anonymous
    return @anonymous_user if @anonymous_user
    anonymous_user = AnonymousUser.find(:first)
    if anonymous_user.nil?
      anonymous_user = AnonymousUser.create(:lastname => 'Anonymous', :firstname => '', :mail => '', :login => '', :status => 0)
      raise 'Unable to create the anonymous user.' if anonymous_user.new_record?
    end
    @anonymous_user = anonymous_user
  end

  private
  # Return password digest
  def self.hash_password(clear_password)
    Digest::SHA1.hexdigest(clear_password || "")
  end
end


class AnonymousUser < User

  def validate_on_create
    # There should be only one AnonymousUser in the database
    errors.add_to_base 'An anonymous user already exists.' if AnonymousUser.find(:first)
  end

  # Overrides a few properties
  def logged?; false end
  def admin; false end
  def name; 'Anonymous' end
  def mail; nil end
  def time_zone; nil end
  def rss_key; nil end
end
