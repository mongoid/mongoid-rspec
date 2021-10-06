require 'spec_helper'

RSpec.describe 'Validations' do
  describe Site do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  describe User do
    it { is_expected.to validate_presence_of(:login) }
    it { is_expected.to validate_uniqueness_of(:login).scoped_to(:site) }
    it { is_expected.to validate_uniqueness_of(:email).case_insensitive.with_message('is already taken') }
    it { is_expected.to validate_format_of(:login).to_allow('valid_login').not_to_allow('invalid login') }
    it { is_expected.to validate_associated(:profile) }
    it { is_expected.to validate_exclusion_of(:login).to_not_allow('super', 'index', 'edit') }
    it { is_expected.to validate_exclusion_of(:password).to_not_allow('password') }
    it { is_expected.to validate_inclusion_of(:role).to_allow('admin', 'member') }
    it { is_expected.to validate_inclusion_of(:role).to_allow(%w[admin member]) }
    it { is_expected.to validate_confirmation_of(:email) }
    it { is_expected.to validate_presence_of(:age).on(:create, :update) }
    it { is_expected.to validate_numericality_of(:age).on(:create, :update) }
    it { is_expected.to validate_inclusion_of(:age).to_allow(23..42).on(%i[create update]) }
    it { is_expected.to validate_presence_of(:password).on(:create) }
    it { is_expected.to validate_confirmation_of(:password).with_message('Password confirmation must match given password') }
    it { is_expected.to validate_presence_of(:provider_uid).on(:create) }
    it { is_expected.to validate_inclusion_of(:locale).to_allow(%i[en ru]) }
  end

  describe Profile do
    it { is_expected.to validate_numericality_of(:age).greater_than(0) }
    it { is_expected.not_to validate_numericality_of(:age).greater_than(0).only_integer(true) }
    it { is_expected.to validate_acceptance_of(:terms_of_service) }
    it { is_expected.to validate_length_of(:hobbies).with_minimum(1).with_message('requires at least one hobby') }
  end

  describe Article do
    it { is_expected.to validate_length_of(:title).within(8..16) }
    it { is_expected.not_to validate_length_of(:content).greater_than(200).less_than(16) }
    it { is_expected.to validate_length_of(:content).greater_than(200) }
    it { is_expected.to validate_inclusion_of(:status).to_allow([:pending]).on(:create) }
    it { is_expected.to validate_inclusion_of(:status).to_allow(%i[approved rejected]).on(:update) }
    it { is_expected.to validate_absence_of(:deletion_date) } if Mongoid::Compatibility::Version.mongoid4_or_newer?
  end

  describe MovieArticle do
    it { is_expected.to validate_numericality_of(:rating).greater_than(0) }
    it { is_expected.to validate_numericality_of(:rating).to_allow(greater_than: 0).less_than_or_equal_to(5) }
    it { is_expected.to validate_numericality_of(:classification).to_allow(even: true, only_integer: true, nil: false) }
  end

  describe Person do
    it { is_expected.to custom_validate(:ssn).with_validator(SsnValidator) }
    it { is_expected.not_to custom_validate(:name) }
  end

  describe Message do
    it { is_expected.to validate_uniqueness_of(:identifier).with_message('uniqueness') }
    it { is_expected.to validate_presence_of(:from).with_message('required') }
    it { is_expected.to validate_format_of(:to).with_message('format') }
  end
end

if Mongoid::Compatibility::Version.mongoid4_or_newer?
  RSpec.describe 'Conditional validations' do
    describe 'validations with if condition using symbol' do
      context 'when the condition is met' do
        subject { User.new(role: 'admin') }

        it { is_expected.to validate_length_of(:password).greater_than(20) }
      end

      context 'when the condition is not met' do
        subject { User.new(role: 'member') }

        it { is_expected.not_to validate_length_of(:password) }
      end
    end

    describe 'validations with if condition using lambda' do
      context 'when the condition is met' do
        subject { User.new(role: 'moderator') }

        it { is_expected.to validate_length_of(:password).greater_than(10) }
      end

      context 'when the condition is not met' do
        subject { User.new(role: 'member') }

        it { is_expected.not_to validate_length_of(:password) }
      end
    end

    describe 'validations with unless condition using symbol' do
      context 'when the condition is met' do
        subject { Article.new(allow_comments: false) }

        it { is_expected.to validate_absence_of(:comments) }
      end

      context 'when the condition is not met' do
        subject { Article.new(allow_comments: true) }

        it { is_expected.not_to validate_absence_of(:comments) }
      end
    end

    describe 'validations with unless condition using lambda' do
      context 'when the condition is met' do
        subject { Article.new(status: :rejected) }

        it { is_expected.to validate_presence_of(:reviewer) }
      end

      context 'when the condition is not met' do
        subject { Article.new(status: :pending) }

        it { is_expected.not_to validate_presence_of(:reviewer) }
      end
    end
  end
end
