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
    probability=((1-(l/t))**(n-k))
    probability*=((l/t)**k)
    probability*=n_choose_k(n,k)
  end
end
