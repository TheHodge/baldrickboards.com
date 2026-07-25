module FaqHelper
  def site_faq_questions
    I18n.t('faq.questions').values
  end

  def site_faq_toc
    site_faq_questions.map do |faq|
      {
        id: faq[:key],
        title: faq[:question],
        items: []
      }
    end
  end
end
