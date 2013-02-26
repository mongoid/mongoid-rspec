require 'mongoid/relations'

module Mongoid
  module Matchers
    module Associations

      HAS_MANY = Mongoid::Relations::Referenced::Many
      HAS_AND_BELONGS_TO_MANY = Mongoid::Relations::Referenced::ManyToMany
      HAS_ONE = Mongoid::Relations::Referenced::One
      BELONGS_TO = Mongoid::Relations::Referenced::In
      EMBEDS_MANY = Mongoid::Relations::Embedded::Many
      EMBEDS_ONE = Mongoid::Relations::Embedded::One
      EMBEDDED_IN = Mongoid::Relations::Embedded::In


      class HaveAssociationMatcher
        def initialize(name, association_type)
          @association = {}
          @association[:name] = name.to_s
          @association[:type] = association_type
          # begin
          #   @association[:class] = name.to_s.classify.constantize
          # rescue
          # end
          @expectation_message = "#{type_description} #{@association[:name].inspect}"
          @expectation_message << " of type #{@association[:class].inspect}" unless @association[:class].nil?
        end

        def of_type(klass)
          @association[:class] = klass
          @expectation_message << " of type #{@association[:class].inspect}"
          self
        end

        def as_inverse_of(association_inverse_name)
          raise "#{@association[:type].inspect} does not respond to :inverse_of" unless [HAS_MANY, HAS_AND_BELONGS_TO_MANY, BELONGS_TO, EMBEDDED_IN].include?(@association[:type])
          @association[:inverse_of] = association_inverse_name.to_s
          @expectation_message << " which is an inverse of #{@association[:inverse_of].inspect}"
          self
        end

        def with_dependent(method_name)
          @association[:dependent] = method_name
          @expectation_message << " which specifies dependent as #{@association[:dependent].to_s}"
          self
        end

        def with_autosave
          @association[:autosave] = true
          @expectation_message << " which specifies autosave as #{@association[:autosave].to_s}"
          self
        end

        def with_index
          @association[:index] = true
          @expectation_message << " which specifies index as #{@association[:index].to_s}"
          self
        end

        def with_autobuild
          @association[:autobuild] = true
          @expectation_message << " which specifies autobuild as #{@association[:autobuild].to_s}"
          self
        end

        def stored_as(store_as)
          raise NotImplementedError, "`references_many #{@association[:name]} :stored_as => :array` has been removed in Mongoid 2.0.0.rc, use `references_and_referenced_in_many #{@association[:name]}` instead"
        end

        def with_foreign_key(foreign_key)
          @association[:foreign_key] = foreign_key.to_s
          @expectation_message << " using foreign key #{@association[:foreign_key].inspect}"
          self
        end

        def matches?(actual)
          @actual = actual.is_a?(Class) ? actual : actual.class
          metadata = @actual.relations[@association[:name]]

          if metadata.nil?
            @negative_result_message = "no association named #{@association[:name]}"
            return false
          else
            @positive_result_message = "association named #{@association[:name]}"
          end

          relation = metadata.relation
          if relation != @association[:type]
            @negative_result_message = "#{@actual.inspect} #{type_description(relation, false)} #{@association[:name]}"
            return false
          else
            @positive_result_message = "#{@actual.inspect} #{type_description(relation, false)} #{@association[:name]}"
          end

          if !@association[:class].nil? and @association[:class] != metadata.klass
            @negative_result_message = "#{@positive_result_message} of type #{metadata.klass.inspect}"
            return false
          else
            @positive_result_message = "#{@positive_result_message}#{" of type #{metadata.klass.inspect}" if @association[:class]}"
          end

          if @association[:inverse_of]
            if @association[:inverse_of].to_s != metadata.inverse_of.to_s
              @negative_result_message = "#{@positive_result_message} which is an inverse of #{metadata.inverse_of}"
              return false
            else
              @positive_result_message = "#{@positive_result_message} which is an inverse of #{metadata.inverse_of}"
            end
          end

          if @association[:dependent]
            if @association[:dependent].to_s != metadata.dependent.to_s
              @negative_result_message = "#{@positive_result_message} which specified dependent as #{metadata.dependent}"
              return false
            else
              @positive_result_message = "#{@positive_result_message} which specified dependent as #{metadata.dependent}"
            end
          end

          if @association[:autosave]
            if metadata.autosave != true
              @negative_result_message = "#{@positive_result_message} which did not set autosave"
              return false
            else
              @positive_result_message = "#{@positive_result_message} which set autosave"
            end
          end

          if @association[:autobuild]
            if metadata.autobuilding? != true
              @negative_result_message = "#{@positive_result_message} which did not set autobuild"
              return false
            else
              @positive_result_message = "#{@positive_result_message} which set autobuild"
            end
          end

          if @association[:index]
            if metadata.index != true
              @negative_result_message = "#{@positive_result_message} which did not set index"
              return false
            else
              @positive_result_message = "#{@positive_result_message} which set index"
            end
          end

          if @association[:foreign_key]
            if metadata.foreign_key != @association[:foreign_key]
              @negative_result_message = "#{@positive_result_message} with foreign key #{metadata.foreign_key.inspect}"
              return false
            else
              @positive_result_message = "#{@positive_result_message} with foreign key #{metadata.foreign_key.inspect}"
            end
          end

          return true
        end

        def failure_message_for_should
          "Expected #{@actual.inspect} to #{@expectation_message}, got #{@negative_result_message}"
        end

        def failure_message_for_should_not
          "Expected #{@actual.inspect} to not #{@expectation_message}, got #{@positive_result_message}"
        end

        def description
          @expectation_message
        end

        def type_description(type = nil, passive = true)
          type ||= @association[:type]
          case type.name
          when EMBEDS_ONE.name
            (passive ? 'embed' : 'embeds') << ' one'
          when EMBEDS_MANY.name
            (passive ? 'embed' : 'embeds') << ' many'
          when EMBEDDED_IN.name
            (passive ? 'be' : 'is') << ' embedded in'
          when HAS_ONE.name
            (passive ? 'reference' : 'references') << ' one'
          when HAS_MANY.name
            (passive ? 'reference' : 'references') << ' many'
          when HAS_AND_BELONGS_TO_MANY.name
            (passive ? 'reference' : 'references') << ' and referenced in many'
          when BELONGS_TO.name
            (passive ? 'be referenced in' : 'referenced in')
          else
            raise "Unknown association type '%s'" % type
          end
        end
      end

      def embed_one(association_name)
        HaveAssociationMatcher.new(association_name, EMBEDS_ONE)
      end

      def embed_many(association_name)
        HaveAssociationMatcher.new(association_name, EMBEDS_MANY)
      end

      def be_embedded_in(association_name)
        HaveAssociationMatcher.new(association_name, EMBEDDED_IN)
      end

      def have_one_related(association_name)
        HaveAssociationMatcher.new(association_name, HAS_ONE)
      end
      alias :have_one :have_one_related

      def have_many_related(association_name)
        HaveAssociationMatcher.new(association_name, HAS_MANY)
      end
      alias :have_many :have_many_related

      def have_and_belong_to_many(association_name)
        HaveAssociationMatcher.new(association_name, HAS_AND_BELONGS_TO_MANY)
      end

      def belong_to_related(association_name)
        HaveAssociationMatcher.new(association_name, BELONGS_TO)
      end
      alias :belong_to :belong_to_related
    end
  end
end
