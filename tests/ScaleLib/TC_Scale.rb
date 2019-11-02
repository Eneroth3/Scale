require 'testup/testcase'
require_relative '../../lib/scale'

class TC_Scale < TestUp::TestCase
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
end
