module StreetsHelper
  def self.factorial(n,k)
    if n<=k
      return n
    else
      return n*self.factorial(n-1,k)
    end
  end
  def self.n_choose_k(n,k)
    return self.factorial(n,n-k+1)/factorial(k,1)
  end
  def self.get_probability l,t,n,k
    ## l is the street length,
    ## t is the total street length,
    ## n is the number of issues,
    ## and k is the number of issues
    ## that occur on this street
    probability=((BigDecimal.new((1-(l/t)).to_s))**(n-k))
    probability*=(BigDecimal((l/t).to_s)**k)
    probability*=n_choose_k(n,k)
    probability.to_f
  end
end
