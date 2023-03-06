class AgreementPolicy < PlannerPolicy
  # Anyone can see ...
  # def index?
  #   return true
  # end
  # def show?
  #   return true
  # end

  def latest?
    allowed?(action: :latest)
  end

  def signed?
    # return true if @person
    allowed?(action: :signed)
  end

  def unsigned?
    # return true if @person
    allowed?(action: :unsigned)
  end

  def sign?
    # return true if @person
    # allowed?(action: :sign)
    true
  end
end
