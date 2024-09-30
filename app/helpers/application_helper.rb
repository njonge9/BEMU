module ApplicationHelper
    def title
        return t("bemu") unless content_for?(:title)

        "#{content_for(:title)} | #{t("bemu")}"
    end
end
