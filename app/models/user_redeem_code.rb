class UserRedeemCode < ActiveRecord::Base

  attr_accessor :code

  belongs_to :user
  belongs_to :redeem_code

  validates :user_id, presence: true
  validates :redeem_code_id, presence: true


  def save_and_redeem(params)
    redeem_code = RedeemCode.where(code: params[:code].strip).first

    if redeem_code
      if redeem_code.still_valid?
        if UserRedeemCode.redeem_code_used_by_user?(redeem_code, self.user)
          errors.add :redeem_code_id, "You already used this code"
          false
        elsif !redeem_code.still_usable?
          errors.add :redeem_code_id, "The code is not usable anymore"
          false
        else
          self.redeem_code = redeem_code
          redeem_objects
          save
        end
      else
        errors.add :redeem_code_id, "The code has expired"
        false
      end
    else
      errors.add :redeem_code_id, "The code is invalid"
      false
    end
  end

  def self.redeem_code_used_by_user?(redeem_code, user)
    !UserRedeemCode.where(user: user, redeem_code: redeem_code).first.nil?
  end

  private

  def redeem_objects
    if redeem_code.redeemable.is_a?(Payment)
      redeem_code.redeemable.line_items.each do |line_item|
        if line_item.has_song?
          redeem_song(line_item.buyable)
        elsif line_item.has_premium_plan_as_gift?
          redeem_premium_plan_as_gift(line_item.buyable)
        end
      end
    elsif redeem_code.redeemable.is_a?(Song)
      redeem_song(redeem_code.redeemable)
    elsif redeem_code.redeemable.is_a?(PremiumPlanAsGift)
      redeem_premium_plan_as_gift(redeem_code.redeemable)
    end
  end

  def redeem_song(song)
    self.user.user_purchased_songs.create(song: song)
  end

  def redeem_premium_plan_as_gift(premium_plan_as_gift)
    self.user.premium = true
    self.user.premium_until = premium_plan_as_gift.duration_in_months.to_i.months.from_now
    self.user.save
  end

end
