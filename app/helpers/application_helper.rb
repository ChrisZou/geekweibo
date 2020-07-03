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

    def header(text, header_level)
      "#" * header_level + " #{text}"
    end
  end

  def markdown(text)
    renderer = MarkdownRenderer.new(filter_html: true, hard_wrap: true)
    options = {
      fenced_code_blocks: true,
      no_intra_emphasis: true,
      autolink: true,
      strikethrough: true,
      lax_html_blocks: true,
      superscript: true,
      space_after_headers: true
    }
    markdown_to_html = Redcarpet::Markdown.new(renderer, options)
    markdown_to_html.render(text).html_safe
  end

end
