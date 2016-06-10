module Permits
  USER = [
      :id,
      :email,
      :username,
      :password,
      :password_confirmation
  ]

  def self.controller(name)
    self.send name.gsub(/\W/,'_').singularize.downcase.gsub('manage_','')
  end

  def self.user
    USER.dup
  end
end