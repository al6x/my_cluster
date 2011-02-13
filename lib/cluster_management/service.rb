class Service
  attr_reader :box

  def initialize box
    @box = box
  end
  
  def mark! extra_mark = nil
    box.mark! self.class.marker(extra_mark)
  end
  
  def has_mark? extra_mark = nil
    box.has_mark? self.class.marker(extra_mark)
  end
  
  def apply_once extra_mark = nil, &block
    unless has_mark? extra_mark
      block.call
      mark! extra_mark
    end
  end
  
  def require services
    services = Array(services)
    services.each do |klass, method|      
      klass.new(box).send method
    end
  end
  
  class << self
    def version version = nil
      if version
        @version = version
      else
        @version ||= 1
      end
    end

    def marker extra_mark = nil
      %(#{name}:#{version}#{":#{extra_mark}" if extra_mark})
    end
  end
end