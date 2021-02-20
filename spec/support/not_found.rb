RSpec.shared_examples :render_404 do |parameter|
  it { expect(response).to render_template '_shared/404' }

  it { expect(response).to have_http_status(:not_found) }
end