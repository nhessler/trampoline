class Bounce
  attr_reader :meth

  def initialize(&meth)
    @meth = meth
  end

  def call()
    meth.call()
  end
end
