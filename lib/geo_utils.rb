module GeoUtils
  def sexagesimal_to_decimal_degrees(degrees, minutes, seconds)
    degrees.to_f + (minutes.to_f / 60) + (seconds.to_f / 3600)
  end
end