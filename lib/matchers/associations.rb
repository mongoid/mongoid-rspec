module Mongoid
  module Matchers
    module Associations
      class HaveAssociationMatcher
        def initialize(name, association_type)
          @association = {}
          @association[:name] = name.to_s
          @association[:type] = association_type
          begin
            @association[:class] = name.to_s.classify.constantize
          rescue
          end
          @expectation_message = "#{type_description} #{@association[:name].inspect}"
          @expectation_message << " of type #{@association[:class].inspect}"
        end
        
        def of_type(klass)
          @association[:class] = klass
          @expectation_message << " of type #{@association[:class].inspect}"
          self
        end
        
        def as_inverse_of(association_inverse_name)
          raise "#{@association[:type].inspect} does not respond to :inverse_of" unless [Mongoid::Associations::BelongsToRelated, Mongoid::Associations::EmbeddedIn].include?(@association[:type])
          @association[:inverse_of] = association_inverse_name.to_s
          @expectation_message << " which is an inverse of #{@association[:inverse_of].inspect}"
          self
        end
        
        def matches?(actual)
          @actual = actual.is_a?(Class) ? actual : actual.class
          association = @actual.associations[@association[:name]]
          
          
          if association.nil?
            @negative_result_message = "no association named #{@association[:name]}"
            return false
          else
            @positive_result_message = "association named #{@association[:name]}"
          end
          
          if association.association != @association[:type]
            @negative_result_message = "#{@actual.inspect} #{type_description(association.association, false)} #{@association[:name]}"
            return false
          else
            @positive_result_message = "#{@actual.inspect} #{type_description(association.association, false)} #{@association[:name]}"
          end
          
          if @association[:class] != association.klass
            @negative_result_message = "#{@positive_result_message} of type #{association.klass.inspect}"
            return false
          else
            @positive_result_message = "#{@positive_result_message} of type #{association.klass.inspect}"
          end
          
          if @association[:inverse_of]
            if @association[:inverse_of].to_s != association.inverse_of.to_s
              @negative_result_message = "#{@positive_result_message} which is an inverse of #{association.inverse_of}"
              return false
            else
              @positive_result_message = "#{@positive_result_message} which is an inverse of #{association.inverse_of}"
            end
          end
          
          true
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
          when "Mongoid::Associations::EmbedsOne"
            (passive ? 'embed' : 'embeds') << ' one'
          when "Mongoid::Associations::EmbedsMany"
            (passive ? 'embed' : 'embeds') << ' many'
          when "Mongoid::Associations::EmbeddedIn"
            (passive ? 'be' : 'is') << ' embedded in'
          when "Mongoid::Associations::HasOneRelated"
            (passive ? 'have' : 'has') << ' one related'
          when "Mongoid::Associations::HasManyRelated"
            (passive ? 'have' : 'has') << ' many related'          
          when "Mongoid::Associations::BelongsToRelated"
            (passive ? 'belong' : 'belongs') << ' to related'
          else
            raise "Unknown association type"
          end
        end
      end      
      
      def embed_one(association_name)
        HaveAssociationMatcher.new(association_name, Mongoid::Associations::EmbedsOne)
      end
      
      def embed_many(association_name)
        HaveAssociationMatcher.new(association_name, Mongoid::Associations::EmbedsMany)
      end    
      
      def be_embedded_in(association_name)
        HaveAssociationMatcher.new(association_name, Mongoid::Associations::EmbeddedIn)
      end
      
      def have_one_related(association_name)
        HaveAssociationMatcher.new(association_name, Mongoid::Associations::HasOneRelated)
      end        
      
      def have_many_related(association_name)
        HaveAssociationMatcher.new(association_name, Mongoid::Associations::HasManyRelated)
      end        
      
      def belong_to_related(association_name)
        HaveAssociationMatcher.new(association_name, Mongoid::Associations::BelongsToRelated)
      end      
    end 
  end
end