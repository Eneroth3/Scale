require 'testup/testcase'
require_relative '../../lib/scale'

class TC_Scale < TestUp::TestCase
  # Float tolerance used internally in SketchUp.
  # From testup-2\src\testup\sketchup_test_utilities.rb
  SKETCHUP_FLOAT_TOLERANCE = 1.0e-10

  def test_factor
    assert_equal(Scale.new("1:100").factor, 0.01)
    assert_equal(Scale.new("1%").factor, 0.01)
    assert_equal(Scale.new("3\"=1'").factor, 1/4.0)
    assert_equal(Scale.new("3\" = 1'").factor, 1/4.0)
    assert_equal(Scale.new("1").factor, 1)
    assert_equal(Scale.new(1).factor, 1)
  end

  def test_format
    assert_equal(Scale.new(1/40.0).format, "1:40")
    assert_equal(Scale.new(1/40.1).format, "~1:40")
    assert_equal(Scale.new("3\"=1'").format, "1:4")
  end

  def test_valid_Query
    assert(Scale.new(1).valid?)
    assert(Scale.new("1").valid?)
    refute(Scale.new("Hej").valid?)
    refute(Scale.new("0").valid?)
  end

  def test_Equal
    assert_equal(Scale.new(1), Scale.new(1))
    assert(Scale.new(1) != Scale.new(2))
    refute_equal(Scale.new(1), Scale.new(2))
    refute(Scale.new(1) != Scale.new(1))

    assert_equal(Scale.new("20%"), Scale.new("1:5"))
    assert_equal(Scale.new("20%"), Scale.new(0.2))
    assert_equal(Scale.new("20%"), Scale.new("1'=5'"))
  end

  def test_GreaterThan
    assert(Scale.new("1:100") > Scale.new("1:200"))
  end

  def test_ceil
    scale1 = Scale.new("30%")
    scale2 = scale1.ceil
    assert_in_delta(scale1.factor, 0.3, SKETCHUP_FLOAT_TOLERANCE, "Original scale should not mutate")
    assert_equal(scale2.factor, 0.5)

    assert(Scale.new("1:25").ceil > Scale.new("1:25"))
    assert(Scale.new("25").ceil > Scale.new("25"))
  end

  def test_ceil_Bang
    scale1 = Scale.new("30%")
    scale2 = scale1.ceil!
    assert_same(scale1, scale2)
    assert_equal(scale2.factor, 0.5)
  end

  def test_floor
    scale1 = Scale.new("30%")
    scale2 = scale1.floor
    assert_in_delta(scale1.factor, 0.3, SKETCHUP_FLOAT_TOLERANCE, "Original scale should not mutate")
    assert_equal(scale2.factor, 0.2)

    assert(Scale.new("1:25").floor < Scale.new("1:25"))
    assert(Scale.new("25").floor < Scale.new("25"))
  end

  def test_floor_Bang
    scale1 = Scale.new("30%")
    scale2 = scale1.floor!
    assert_same(scale1, scale2)
    assert_equal(scale2.factor, 0.2)
  end
end
