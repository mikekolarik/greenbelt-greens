class CheckZipCode
  include Concerns::Service
  attr_accessor :zip_code

  def call(zip_code)
    unless zip_code.blank?
      if check_inclusion(zip_code).empty?
        @zip_code = nil
      else
        @zip_code = zip_code
      end
    end
  end

  def check_inclusion(zip_code)
    ZipCodeRange.where('zip_from <= ? AND zip_to >= ?', zip_code, zip_code)
  end
end
