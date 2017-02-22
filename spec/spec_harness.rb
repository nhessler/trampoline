module StackDepth
  def initialize(*)
    reset_depth
    super
  end

  def record_depth
    #subtract 1 for the current scope
    @depth = caller.length - 1 if caller.length - 1 > @depth
  end

  def max_depth
    @depth || 0
  end

  def reset_depth
    @depth = 0
  end
end

class Base
  include StackDepth

  def factorial(acc, n)
    record_depth
    return acc if n <= 1
    factorial acc * n, n - 1
  end

  "def simple(n)
    return n if n <= 0
    simple(n - 1)
  end"
end

class Trampoliner
  include StackDepth
  include Trampoline

  def factorial(acc, n)
    jump(method(:factorial_helper)).call(acc, n)
  end

  def factorial_helper(acc, n)
    record_depth
    return acc if  n <= 1
    bounce { factorial_helper(acc * n, n - 1) }
  end

  def simple(n)
    jump(method(:simple_helper)).call(n)
  end

  def simple_helper(n)
    return n if n <= 0
    bounce { simple_helper n - 1 }
  end
end

# class Metabouncer
#   include StackDepth
#   include Trampoline

#   trampoline :factorial
#   trampoline :simple

#   def factorial(n, acc = 0)
#     record_depth
#     return acc if  n <= 1
#     factorial(acc * n, n - 1)
#   end

#   def simple(n)
#     return n if n <= 0
#     simple n - 1
#   end
# end
