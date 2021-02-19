RSpec.shared_examples :do_not_set_flash do
  it 'do not set a flash message' do
    expect(flash.count).to eq 0
  end
end

RSpec.shared_examples :set_flash do |type:, message:|
  it "set a flash :#{type} message" do
    expect(flash[type]).to eq message
  end
end