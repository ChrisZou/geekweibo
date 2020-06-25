module ApplicationHelper
  def user_avatar(user, size = 100)
    if user && user.avatar.attached?
      user.avatar.variant(resize: "#{size}x#{size}")
    else
      "avatar-not-logged-in.png"
    end
  end
end
