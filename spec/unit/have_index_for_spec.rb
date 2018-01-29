require 'spec_helper'

RSpec.describe Mongoid::Matchers::HaveIndexFor do
  subject do
    Class.new do
      include Mongoid::Document

      field :fizz, as: :buzz, type: String

      index(foo: 1)
      index({ bar: 1 }, unique: true, background: true, drop_dups: true)
      index(foo: 1, bar: -1)
      index('baz._id' => 1)
      index(buzz: 1)
    end
  end

  it 'detects an index for singular field key' do
    is_expected.to have_index_for(foo: 1)
  end

  it 'detects an index for multipple fields key' do
    is_expected.to have_index_for(foo: 1, bar: -1)
  end

  it 'detects an index with options' do
    is_expected
      .to have_index_for(bar: 1)
      .with_options(unique: true, background: true, drop_dups: true)
  end

  it 'detects an index with only part of options' do
    is_expected
      .to have_index_for(bar: 1)
      .with_options(unique: true)
  end

  it 'detects an index for string key' do
    is_expected.to have_index_for('baz._id' => 1)
  end

  it 'detect an index for aliased fields' do
    is_expected.to have_index_for(fizz: 1)
    is_expected.to have_index_for(buzz: 1) if Mongoid::Compatibility::Version.mongoid4_or_newer?
  end
end
