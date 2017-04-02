class Numeric
  def seconds
    self
  end
  alias_method :second, :seconds

  def minutes
    self * 60
  end
  alias_method :minute, :minutes

  def hours
    self * 3600
  end
  alias_method :hour, :hours

  def days
    self * 86400
  end
  alias_method :day, :days
end
