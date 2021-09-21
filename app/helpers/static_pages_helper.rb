module StaticPagesHelper

  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = "More Beauty"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end
