# frozen_string_literal: true

module UrlHelper
	def index_url_table(url)
		content_tag(:th, scope: 'row') do
			link_to(url.short_url, visit_path(url.short_url))
		end +
		content_tag(:td) do
			link_to(url.original_url, url.original_url.truncate(20))
		end +
		content_tag(:td) do
			I18n.l(url.created_at, format: :short)
		end +
		show_preview_url_graphic(url)
	end

	def data_chart(id, data_name, values)
		return t(:no_data_available) if values.blank?
		content_tag(:div, '', id: id, data_name => "#{raw values}")
	end

	private

	def show_preview_url_graphic(url)
		content_tag(:td, url.clicks_count.to_i) +
		content_tag(:td) do
			link_to(url_path(url.short_url), 'data-turbolinks' => false) do
				content_tag(:svg, class: 'octicon octicon-graph', viewBox: '0 0 16 16', version: '1.1', width: '16', height: '16', 'aria-hidden' => true) do
					content_tag(:path, '', 'fill-rule' => 'evenodd', d:'M16 14v1H0V0h1v14h15zM5 13H3V8h2v5zm4 0H7V3h2v10zm4 0h-2V6h2v7z')
				end
			end
		end
	end
end
