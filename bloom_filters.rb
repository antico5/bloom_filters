require 'digest'

class BloomFilterSet
  UNPACK_FORMAT = 'L*'.freeze

  def initialize bitmap_size
    @bitmap_bits = bitmap_size * 8
    @digester = Digest::SHA256.new
    @bitmap = "\x00" * bitmap_size
  end

  def add item
    hashes(item).each { |hash| set_bit hash }
  end

  def include? item
    hashes(item).all? { |hash| get_bit hash }
  end

  private

  def hashes item
    @digester.digest(item).unpack(UNPACK_FORMAT).map { |hash| hash % @bitmap_bits }
  end

  def set_bit position
    byte_index = position / 8
    offset = position % 8
    new_byte = @bitmap.getbyte(byte_index) | (1 << offset)
    @bitmap.setbyte(byte_index, new_byte)
  end

  def get_bit position
    byte_index = position / 8
    offset = position % 8
    @bitmap.getbyte(byte_index) >> offset & 1 == 1
  end
end
