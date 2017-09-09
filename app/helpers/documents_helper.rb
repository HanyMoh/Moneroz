module DocumentsHelper
  def doc_type_tag(doc_type)
    content_tag(:span, Document::DOC_TYPE[doc_type])
  end
end
