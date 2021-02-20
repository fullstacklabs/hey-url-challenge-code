RSpec.shared_examples :context_success do
  it { expect(subject.failure?).to eq false }
end

RSpec.shared_examples :context_fails do
  it { expect(subject.failure?).to eq true }
end

RSpec.shared_examples :context_with_friendly_error do |error|
  it { expect(subject.error).to eq error }
end