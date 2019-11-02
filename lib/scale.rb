# Represents the scale of a view or drawing.
class Scale
  include Comparable

  # Get source string scale was created from, or nil if it was created
  # from a number.
  #
  # @return [String, nil]
  attr_reader :source_string

  # Create a Scale object.
  # If not a valid object can be created, the `invalid?` method on the object
  # will return false.
  #
  # @param number_or_string [Numeric, String]
  #
  # @example
  #   Scale.new("1:100")
  #   Scale.new("10%")
  #   Scale.new(0.01)
  #   Scale.new("1\" = 4 m")
  def initialize(number_or_string)
    if number_or_string.is_a?(Numeric)
      @factor = number_or_string
    else
      @factor = parse(number_or_string)
      @source_string = number_or_string
    end
  end

  # Compare Scales.
  #
  # @param other [Scale]
  #
  # @return [-1, 0, 1, nil]
  def <=>(other)
    return unless other.is_a?(self.class)
    return unless other.valid?
    return unless valid?
    return 0 if (@factor - other.factor).abs <= FLOAT_TOLERANCE

    @factor <=> other.factor
  end

  # Get developer friendly string representation of Scale.
  #
  # @return [String]
  def inspect
    return "<#{self.class.name} (Invalid)>" unless valid?

    "<#{self.class.name} #{@factor}>"
  end

  # Get scale factor for Scale.
  #
  # @return [Numeric, nil]
  def factor
    @factor if valid?
  end

  # Format human readable string based on scale factor, e.g. "1:100" or "~1:42".
  #
  # @return [String]
  def format
    string =
      if @factor > 1
        "#{@factor.round}:1"
      else
        "1:#{(1 / @factor).round}"
      end
    string = "~#{string}" unless self == self.class.new(string)

    string
  end

  # Get string representation of Scale. If Scale was created from string the
  # same string is returned, otherwise a new string is formatted.
  #
  # @return [String]
  def to_s
    @source_string || format
  end

  # Check if Scale is valid. A Scale is not valid if the scale factor is 0 or
  # undetermined.
  #
  # @return [Boolean]
  def valid?
    !!@factor && !@factor.zero?
  end

  private

  # Float tolerance used internally in SketchUp.
  # From testup-2\src\testup\sketchup_test_utilities.rb
  FLOAT_TOLERANCE = 1.0e-10
  private_constant :FLOAT_TOLERANCE

  def parse(string)
    # REVIEW: What to do if starting with ~?
    return if string.empty?

    division = string.split(/:|=/)
    return if division.size > 2

    division.map! { |r| parse_length(r) }
    division[1] ||= "1".to_l
    return unless division[0]

    division[0] / division[1]
  end

  def parse_length(string)
    string.strip.sub("%", "").to_l / (string.end_with?("%") ? 100 : 1)
  rescue ArgumentError
    nil
  end
end
