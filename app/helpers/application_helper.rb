module ApplicationHelper
  def user_avatar(user, size = 100)
    if user && user.avatar.attached?
      user.avatar.variant(resize: "#{size}x#{size}")
    else
      "avatar-not-logged-in.png"
    end
  end

  class MarkdownRenderer < Redcarpet::Render::HTML
    def block_code(code, language)
      CodeRay.scan(code, language || :ruby).div
    end
  end

  def markdown(text)
    rndr = MarkdownRenderer.new(:filter_html => true, :hard_wrap => true)
    options = {
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => true,
      :superscript => true
    }
    markdown_to_html = Redcarpet::Markdown.new(rndr, options)
    markdown_to_html.render(text).html_safe
  end
  # def markdown(text)
  #   options = [:hard_wrap, :autolink, :no_intra_emphasis, :fenced_code_blocks]
  #   Markdown.new(text, *options).to_html.html_safe
  # end
end
