module ZXing; end
module ZXing::Java; end

class ZXing::Java::Reader
  include ZXing::Reader
  def initialize ptr
    super ptr
  end

  def decode bitmap, hints = nil
    hints ||= {}
    native_hints = java::util::Hashtable.new
    hints.each do |k, v|
      case k
      when :try_harder
        native_hints[Java::com::google::zxing::DecodeHintType::TRY_HARDER] =
          java::lang::Boolean::TRUE
      else
        raise "implement #{k} #{v}"
      end
    end
    begin
      ZXing::Java::Result.new native.decode(bitmap.native, native_hints)
    rescue Java::com::google::zxing::NotFoundException => nfe
      raise ZXing::NotFoundException.new nfe.message.sub %r{: null$},""
    rescue Java::com::google::zxing::FormatException => fe
      raise ZXing::FormatException.new fe.message.sub %r{: null$},""
    rescue Java::com::google::zxing::ChecksumException => ce
      raise ZXing::ChecksumException.new ce.message.sub %r{: null$},""
    end
  end
end