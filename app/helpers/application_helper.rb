module ApplicationHelper
  def user_avatar(user, size = 100)
    if user && user.avatar.attached?
      "#{user.avatar_url}?x-oss-process=image/resize,m_fill,h_#{size},w_#{size}"
    else
      "https://ui-avatars.com/api/?name=#{user.nickname}&size=#{size}&background=444444&length=1&color=eeeeee"
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

  def owner?(item) 
    user_signed_in? && current_user.id == item.user_id
  end
end
