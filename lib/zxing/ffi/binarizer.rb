module ZXing; end
module ZXing::CPP; end

class ZXing::CPP::Binarizer
  include ZXing::Binarizer
  def initialize ptr, source
    super ZXing::CPP::FFI::BinarizerPointer.new ptr
    @source = source
  end
  attr_reader :source
  def black_matrix
    ZXing::CPP::BitMatrix.new ZXing::CPP::FFI.Binarizer_black_matrix(native)
  end
  def image
    width = source.width
    height = source.height
    image = Magick::Image.new width, height
    (0...height).each do |row|
      (0...width).each do |column|
        image.pixel_color(column, row, black_matrix.get(column, row) ? "black" : "white")
      end
    end
    return image
  end
end
