class Jump
  attr_reader :meth

  def initialize(meth)
    @meth = meth
  end

  def call(*args)
    thunk = meth.call(*args)

    loop do
      return thunk unless thunk.is_a? Bounce
      thunk = thunk.call()
    end
  end

end
