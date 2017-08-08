require 'digest'

class BloomFilterSet
  BITMAP_SIZE = 1 << 18

  def initialize bitmap_size
    @digester = Digest::MD5.new
    @bitmap = "\x00" * (BITMAP_SIZE / 8)
  end

  def add item
    hashes(item).each { |hash| set_bit hash }
  end

  def include? item
    hashes(item).all? { |hash| get_bit hash }
  end

  def hashes item
    @digester.digest(item).unpack('LL').map { |hash| hash % BITMAP_SIZE }
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
