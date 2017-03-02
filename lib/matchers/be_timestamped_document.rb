RSpec::Matchers.define :be_timestamped_document do
  match do |doc|
    if [*@timestamped_module].any?
      modules = [*@timestamped_module].map{|m| "Mongoid::Timestamps::#{m.to_s.classify}".constantize }
      (modules - doc.class.included_modules).empty?
    else
      doc.class.included_modules.include?(Mongoid::Timestamps) or
      doc.class.included_modules.include?(Mongoid::Timestamps::Created) or
      doc.class.included_modules.include?(Mongoid::Timestamps::Updated)
    end
  end

  chain :with do |timestamped_module|
    @timestamped_module = timestamped_module
  end

  description do
    desc = "be a timestamped Mongoid document"
    desc << " with #{@timestamped_module}" if @timestamped_module
    desc
  end
end
